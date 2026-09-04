import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/dio_item_repository.dart';
import '../data/dio_upload_repository.dart';
import '../data/image_picker_item_image_picker.dart';
import '../domain/item.dart';
import '../domain/item_image_picker.dart';
import '../domain/item_repository.dart';
import '../domain/picked_image.dart';
import '../domain/upload_repository.dart';
import 'add_item_state.dart';
import 'items_controller.dart';

/// Pick photo → pre-signed upload → create item, then refresh the list cache.
class AddItemController extends Notifier<AddItemState> {
  AddItemController(this.wardrobeId);

  final String wardrobeId;

  @override
  AddItemState build() => const AddItemState();

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
        subcategory: subcategory,
        colours: colours,
        brand: brand,
        imageKey: ticket.objectKey,
      );
      ref.read(itemsControllerProvider(wardrobeId).notifier).upsert(item);
      state = state.copyWith(isSubmitting: false, phase: AddItemPhase.idle);
      return item;
    } on ApiException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        phase: AddItemPhase.idle,
        errorMessage: error.message,
      );
      return null;
    } catch (_) {
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
