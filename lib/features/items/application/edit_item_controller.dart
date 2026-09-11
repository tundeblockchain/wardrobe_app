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
import 'edit_item_state.dart';
import 'item_detail_controller.dart';
import 'item_local_preview_cache.dart';
import 'item_scope.dart';
import 'items_controller.dart';

/// Updates item metadata and optionally replaces the photo.
class EditItemController extends Notifier<EditItemState> {
  EditItemController(this.scope);

  final ItemScope scope;

  @override
  EditItemState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const EditItemState();
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
      state = state.copyWith(isPicking: false, replacementImage: image);
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
    ItemSubcategoryPatch subcategory = const ItemSubcategoryPatch.omit(),
    List<String>? colours,
    String? brand,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      String? imageKey;
      final replacement = state.replacementImage;
      if (replacement != null) {
        final ticket = await _uploads.createWardrobeItemUpload(
          contentType: replacement.contentType,
        );
        await _uploads.uploadFile(
          uploadUrl: ticket.uploadUrl,
          bytes: replacement.bytes,
          contentType: replacement.contentType,
        );
        imageKey = ticket.objectKey;
      }

      final item = await _items.updateItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
        name: name.trim(),
        category: category,
        subcategory: subcategory,
        colours: colours ?? const [],
        brand: brand,
        imageKey: imageKey,
      );
      if (!ref.mounted) {
        return item;
      }
      if (replacement != null) {
        ref
            .read(itemLocalPreviewCacheProvider.notifier)
            .store(item.id, replacement.bytes);
      }
      ref.read(itemsControllerProvider(scope.wardrobeId).notifier).upsert(item);
      ref.read(itemDetailControllerProvider(scope).notifier).replace(item);
      state = state.copyWith(isSaving: false);
      return item;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return null;
    } catch (_) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }
}

final editItemControllerProvider =
    NotifierProvider.family<EditItemController, EditItemState, ItemScope>(
      EditItemController.new,
    );
