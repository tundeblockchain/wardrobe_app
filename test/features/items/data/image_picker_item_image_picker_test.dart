import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';

class _MockImagePicker extends Mock implements ImagePicker {}

void main() {
  setUpAll(() {
    registerFallbackValue(ImageSource.gallery);
  });

  test('constructing the device picker enables Android Photo Picker', () {
    final android = ImagePickerAndroid();
    ImagePickerPlatformHolder.install(android);
    addTearDown(ImagePickerPlatformHolder.restore);

    expect(android.useAndroidPhotoPicker, isFalse);
    ImagePickerItemImagePicker(picker: _MockImagePicker());
    expect(android.useAndroidPhotoPicker, isTrue);
  });

  test('pickFromGallery maps the selected file for upload', () async {
    final mock = _MockImagePicker();
    when(
      () => mock.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      ),
    ).thenAnswer(
      (_) async => XFile.fromData(
        Uint8List.fromList(const [0xFF, 0xD8, 0xFF]),
        mimeType: 'image/jpeg',
        name: 'shirt.jpg',
      ),
    );

    final picked = await ImagePickerItemImagePicker(picker: mock)
        .pickFromGallery();

    expect(picked, isNotNull);
    expect(picked!.contentType, 'image/jpeg');
    expect(picked.bytes, Uint8List.fromList(const [0xFF, 0xD8, 0xFF]));
    verify(
      () => mock.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      ),
    ).called(1);
  });

  test('pickFromCamera still uses the camera source', () async {
    final mock = _MockImagePicker();
    when(
      () => mock.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      ),
    ).thenAnswer(
      (_) async => XFile.fromData(
        Uint8List.fromList(const [1, 2, 3]),
        mimeType: 'image/png',
        name: 'capture.png',
      ),
    );

    final picked = await ImagePickerItemImagePicker(picker: mock)
        .pickFromCamera();

    expect(picked?.contentType, 'image/png');
    verify(
      () => mock.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      ),
    ).called(1);
  });
}

/// Swaps [ImagePickerPlatform.instance] for tests that assert the Android flag.
class ImagePickerPlatformHolder {
  static ImagePickerPlatform? _previous;

  static void install(ImagePickerAndroid next) {
    _previous = ImagePickerPlatform.instance;
    ImagePickerPlatform.instance = next;
  }

  static void restore() {
    final previous = _previous;
    if (previous != null) {
      ImagePickerPlatform.instance = previous;
    }
  }
}
