import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/item_image_picker.dart';
import '../domain/picked_image.dart';

/// [ItemImagePicker] backed by `image_picker`.
class ImagePickerItemImagePicker implements ItemImagePicker {
  ImagePickerItemImagePicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<PickedImage?> pickFromCamera() => _pick(ImageSource.camera);

  @override
  Future<PickedImage?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<PickedImage?> _pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (file == null) {
      return null;
    }
    return PickedImage(
      bytes: await file.readAsBytes(),
      contentType: inferImageContentType(
        mimeType: file.mimeType,
        fileName: file.name,
        path: file.path,
      ),
      fileName: file.name,
    );
  }
}

/// Resolves a backend-supported content type from picker metadata.
String inferImageContentType({
  String? mimeType,
  String? fileName,
  String? path,
}) {
  final mime = mimeType?.toLowerCase();
  if (mime != null && mime.startsWith('image/')) {
    if (mime == 'image/jpg') {
      return 'image/jpeg';
    }
    return mime;
  }
  final name = (fileName ?? path ?? '').toLowerCase();
  if (name.endsWith('.png')) {
    return 'image/png';
  }
  if (name.endsWith('.webp')) {
    return 'image/webp';
  }
  if (name.endsWith('.heic') || name.endsWith('.heif')) {
    return 'image/heic';
  }
  return 'image/jpeg';
}

/// Default device picker. Override in tests so unit tests never touch a device.
final itemImagePickerProvider = Provider<ItemImagePicker>((ref) {
  return ImagePickerItemImagePicker();
});
