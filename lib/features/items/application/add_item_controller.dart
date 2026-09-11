import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_item_repository.dart';
import '../data/dio_upload_repository.dart';
import '../data/image_picker_item_image_picker.dart';
import '../domain/item.dart';
import '../domain/item_image_picker.dart';
import '../domain/item_repository.dart';
import '../domain/item_subcategory_patch.dart';
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

  Future<void> pickFromCamera() => _pick(_picker.pickFromCamera);

  Future<void> pickFromGallery() => _pick(_picker.pickFromGallery);

  Future<void> _pick(Future<PickedImage?> Function() pick) async {
    state = state.copyWith(isPicking: true, clearError: true);
    try {
      final image = await pick();
      state = state.copyWith(isPicking: false, pickedImage: image);
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
      final ticket = await _uploads.createWardrobeItemUpload(
        contentType: image.contentType,
      );
      await _uploads.uploadFile(
        uploadUrl: ticket.uploadUrl,
        bytes: image.bytes,
        contentType: image.contentType,
      );
      state = state.copyWith(phase: AddItemPhase.creating);
      final item = await _items.createItem(
        wardrobeId: wardrobeId,
        name: name.trim(),
        category: category,
        subcategory: ItemSubcategoryPatch.normalize(subcategory),
        colours: colours,
        brand: brand,
        imageKey: ticket.objectKey,
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
      state = state.copyWith(isSubmitting: false, phase: AddItemPhase.idle);
      return item;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSubmitting: false,
        phase: AddItemPhase.idle,
        errorMessage: error.message,
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
}

final addItemControllerProvider =
    NotifierProvider.family<AddItemController, AddItemState, String>(
      AddItemController.new,
    );
