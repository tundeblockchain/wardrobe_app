import 'dart:typed_data';

import 'package:wardrobe_app/features/items/domain/item_image_picker.dart';
import 'package:wardrobe_app/features/items/domain/picked_image.dart';

/// Scripted [ItemImagePicker] so unit tests never touch a device.
class FakeItemImagePicker implements ItemImagePicker {
  FakeItemImagePicker({this.image});

  PickedImage? image;
  Object? nextError;
  int cameraCalls = 0;
  int galleryCalls = 0;

  static PickedImage sample({
    String contentType = 'image/jpeg',
    List<int> bytes = const [1, 2, 3],
  }) {
    return PickedImage(
      bytes: Uint8List.fromList(bytes),
      contentType: contentType,
      fileName: 'photo.jpg',
    );
  }

  @override
  Future<PickedImage?> pickFromCamera() async {
    cameraCalls++;
    _maybeThrow();
    return image;
  }

  @override
  Future<PickedImage?> pickFromGallery() async {
    galleryCalls++;
    _maybeThrow();
    return image;
  }

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }
}
