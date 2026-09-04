import 'picked_image.dart';

/// Camera / gallery access. Implementations wrap a device picker; tests fake it.
abstract interface class ItemImagePicker {
  Future<PickedImage?> pickFromCamera();

  Future<PickedImage?> pickFromGallery();
}
