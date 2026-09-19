import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../entitlements/application/entitlements_controller.dart';
import '../../entitlements/domain/entitlement_error_codes.dart';
import '../../entitlements/domain/entitlement_paywall_copy.dart';
import '../../entitlements/domain/paywall_placement.dart';
import '../../inbox/application/inbox_controller.dart';
import '../data/dio_item_repository.dart';
import '../data/dio_upload_repository.dart';
import '../data/image_picker_item_image_picker.dart';
import '../domain/item.dart';
import '../domain/item_default_name.dart';
import '../domain/item_image_picker.dart';
import '../domain/item_repository.dart';
import '../domain/item_subcategory_patch.dart';
import '../domain/item_validators.dart';
import '../domain/picked_image.dart';
import '../domain/upload_repository.dart';
import 'add_item_state.dart';
import 'item_detail_controller.dart';
import 'item_local_preview_cache.dart';
import 'item_scope.dart';
import 'items_controller.dart';

/// Pick photo → pre-signed upload → create item, then refresh the list cache.
class AddItemController extends Notifier<AddItemState> {
  AddItemController(this.wardrobeId);

  final String wardrobeId;

  @override
  AddItemState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const AddItemState();
  }

  ItemImagePicker get _picker => ref.read(itemImagePickerProvider);

  UploadRepository get _uploads => ref.read(uploadRepositoryProvider);

  ItemRepository get _items => ref.read(itemRepositoryProvider);

  Future<void> pickFromCamera() => _pickSingle(_picker.pickFromCamera);

  Future<void> pickFromGallery() async {
    state = state.copyWith(isPicking: true, clearError: true);
    try {
      final images = await _picker.pickMultipleFromGallery();
      if (images.isEmpty) {
        state = state.copyWith(isPicking: false);
        return;
      }
      state = state.copyWith(
        isPicking: false,
        pickedImage: images.first,
        pickedImages: images,
        itemNames: [
          for (var i = 0; i < images.length; i++) defaultItemName(images[i], i),
        ],
        batchResults: const [],
        batchIndex: 0,
      );
    } catch (_) {
      state = state.copyWith(
        isPicking: false,
        errorMessage: 'Could not open the photo picker.',
      );
    }
  }

  void setItemName(int index, String name) {
    if (index < 0 || index >= state.itemNames.length) {
      return;
    }
    final names = [...state.itemNames];
    names[index] = name;
    state = state.copyWith(itemNames: names);
  }

  Future<void> _pickSingle(Future<PickedImage?> Function() pick) async {
    state = state.copyWith(isPicking: true, clearError: true);
    try {
      final image = await pick();
      if (image == null) {
        state = state.copyWith(isPicking: false);
        return;
      }
      state = state.copyWith(
        isPicking: false,
        pickedImage: image,
        pickedImages: [image],
        itemNames: [defaultItemName(image, 0)],
        batchResults: const [],
        batchIndex: 0,
      );
    } catch (_) {
      state = state.copyWith(
        isPicking: false,
        errorMessage: 'Could not open the photo picker.',
      );
    }
  }

  Future<Item?> submit({
    required String name,
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    DateTime? acquiredAt,
  }) async {
    final image = state.pickedImage;
    if (image == null) {
      state = state.copyWith(errorMessage: 'Add a photo to continue.');
      return null;
    }

    state = state.copyWith(
      isSubmitting: true,
      phase: AddItemPhase.uploading,
      clearError: true,
    );
    try {
      final item = await _createFromImage(
        image: image,
        name: name,
        category: category,
        subcategory: subcategory,
        colours: colours,
        brand: brand,
        acquiredAt: acquiredAt,
      );
      if (!ref.mounted) {
        return item;
      }
      state = state.copyWith(isSubmitting: false, phase: AddItemPhase.idle);
      return item;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSubmitting: false,
        phase: AddItemPhase.idle,
        errorMessage: queueEntitlementPaywall(
          ref,
          error,
          fallback: PaywallPlacement.itemLimit,
        ),
      );
      return null;
    } catch (_) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSubmitting: false,
        phase: AddItemPhase.idle,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }

  /// Sequential upload + create for every picked photo. Failures do not wipe
  /// items that already saved. Retry skips successes.
  Future<BatchSubmitResult?> submitBatch({
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    DateTime? acquiredAt,
  }) async {
    final images = state.pickedImages;
    if (images.isEmpty) {
      state = state.copyWith(errorMessage: 'Add a photo to continue.');
      return null;
    }

    final names = [
      for (var i = 0; i < images.length; i++) _resolvedName(i, images[i]),
    ];
    for (final name in names) {
      final error = ItemValidators.name(name);
      if (error != null) {
        state = state.copyWith(errorMessage: error);
        return null;
      }
    }

    final previous = [
      for (final result in state.batchResults)
        if (result.succeeded) result,
    ];
    final succeededIndexes = {for (final result in previous) result.index};

    state = state.copyWith(
      isSubmitting: true,
      phase: AddItemPhase.uploading,
      batchResults: previous,
      clearError: true,
    );

    var queuedPaywall = false;
    final results = [...previous];
    for (var i = 0; i < images.length; i++) {
      if (succeededIndexes.contains(i)) {
        continue;
      }
      if (!ref.mounted) {
        return BatchSubmitResult(results: results);
      }
      state = state.copyWith(batchIndex: i, phase: AddItemPhase.uploading);
      try {
        final item = await _createFromImage(
          image: images[i],
          name: names[i],
          category: category,
          subcategory: subcategory,
          colours: colours,
          brand: brand,
          acquiredAt: acquiredAt,
        );
        results.add(
          BatchItemResult(
            index: i,
            image: images[i],
            displayName: names[i],
            item: item,
          ),
        );
        if (ref.mounted) {
          state = state.copyWith(batchResults: [...results]);
        }
      } on ApiException catch (error) {
        final message = queuedPaywall
            ? EntitlementPaywallCopy.userMessage(
                error,
                fallback: PaywallPlacement.itemLimit,
              )
            : queueEntitlementPaywall(
                ref,
                error,
                fallback: PaywallPlacement.itemLimit,
              );
        queuedPaywall = true;
        results.add(
          BatchItemResult(
            index: i,
            image: images[i],
            displayName: names[i],
            errorMessage: message,
          ),
        );
        if (_isCatalogLimit(error)) {
          for (var j = i + 1; j < images.length; j++) {
            if (succeededIndexes.contains(j)) {
              continue;
            }
            results.add(
              BatchItemResult(
                index: j,
                image: images[j],
                displayName: names[j],
                errorMessage: message,
              ),
            );
          }
          break;
        }
      } catch (_) {
        results.add(
          BatchItemResult(
            index: i,
            image: images[i],
            displayName: names[i],
            errorMessage: 'Something went wrong. Please try again.',
          ),
        );
      }
    }

    results.sort((a, b) => a.index.compareTo(b.index));
    final outcome = BatchSubmitResult(results: results);
    if (!ref.mounted) {
      return outcome;
    }
    state = state.copyWith(
      isSubmitting: false,
      phase: AddItemPhase.idle,
      batchResults: results,
      errorMessage: outcome.summary,
    );
    return outcome;
  }

  String _resolvedName(int index, PickedImage image) {
    if (index < state.itemNames.length) {
      final typed = state.itemNames[index].trim();
      if (typed.isNotEmpty) {
        return typed;
      }
    }
    return defaultItemName(image, index);
  }

  bool _isCatalogLimit(ApiException error) {
    return EntitlementErrorCodes.isEntitlementCode(error.code) ||
        EntitlementErrorCodes.isEntitlementStatus(error.statusCode);
  }

  Future<Item> _createFromImage({
    required PickedImage image,
    required String name,
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    DateTime? acquiredAt,
  }) async {
    final ticket = await _uploads.createWardrobeItemUpload(
      contentType: image.contentType,
    );
    await _uploads.uploadFile(
      uploadUrl: ticket.uploadUrl,
      bytes: image.bytes,
      contentType: image.contentType,
    );
    if (ref.mounted) {
      state = state.copyWith(phase: AddItemPhase.creating);
    }
    final item = await _items.createItem(
      wardrobeId: wardrobeId,
      name: name.trim(),
      category: category,
      subcategory: ItemSubcategoryPatch.normalize(subcategory),
      colours: colours,
      brand: brand,
      imageKey: ticket.objectKey,
      acquiredAt: acquiredAt,
    );
    if (!ref.mounted) {
      return item;
    }
    ref
        .read(itemLocalPreviewCacheProvider.notifier)
        .store(item.id, image.bytes);
    ref.read(itemsControllerProvider(wardrobeId).notifier).upsert(item);
    ref
        .read(
          itemDetailControllerProvider(
            ItemScope(wardrobeId: wardrobeId, itemId: item.id),
          ).notifier,
        )
        .replace(item);
    ref.read(inboxControllerProvider.notifier).trackPendingItem(item);
    return item;
  }
}

final addItemControllerProvider =
    NotifierProvider.family<AddItemController, AddItemState, String>(
      AddItemController.new,
    );
