import 'dart:typed_data';

import 'package:wardrobe_app/features/items/domain/item_image_picker.dart';
import 'package:wardrobe_app/features/items/domain/picked_image.dart';

/// Scripted [ItemImagePicker] so unit tests never touch a device.
class FakeItemImagePicker implements ItemImagePicker {
  FakeItemImagePicker({this.image, this.images});

  PickedImage? image;
  List<PickedImage>? images;
  Object? nextError;
  int cameraCalls = 0;
  int galleryCalls = 0;
  int multiGalleryCalls = 0;

  /// 1×1 PNG so widget tests can render [Image.memory] without a codec error.
  static const tinyPng = <int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ];

  static PickedImage sample({
    String contentType = 'image/jpeg',
    List<int> bytes = tinyPng,
    String fileName = 'photo.jpg',
  }) {
    return PickedImage(
      bytes: Uint8List.fromList(bytes),
      contentType: contentType,
      fileName: fileName,
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

  @override
  Future<List<PickedImage>> pickMultipleFromGallery() async {
    galleryCalls++;
    multiGalleryCalls++;
    _maybeThrow();
    if (images != null) {
      return images!;
    }
    if (image != null) {
      return [image!];
    }
    return const [];
  }

  void _maybeThrow() {
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }
}
