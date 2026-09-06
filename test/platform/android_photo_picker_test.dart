import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';

void main() {
  late String manifest;

  setUpAll(() {
    manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
  });

  test(
    'Android gallery uses Photo Picker merge overrides, not media grants',
    () {
      expect(
        manifest,
        contains('xmlns:tools="http://schemas.android.com/tools"'),
      );
      expect(
        manifest,
        contains('android:name="android.permission.READ_MEDIA_IMAGES"'),
      );
      expect(
        manifest,
        contains('android:name="android.permission.READ_EXTERNAL_STORAGE"'),
      );

      for (final permission in [
        'android.permission.READ_MEDIA_IMAGES',
        'android.permission.READ_MEDIA_VIDEO',
        'android.permission.READ_MEDIA_VISUAL_USER_SELECTED',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
      ]) {
        expect(
          _isGrantedWithoutRemove(manifest, permission),
          isFalse,
          reason: '$permission must be stripped with tools:node="remove"',
        );
      }
    },
  );

  test('Android camera permission remains for capture', () {
    expect(manifest, contains('android:name="android.permission.CAMERA"'));
    expect(
      _isGrantedWithoutRemove(manifest, 'android.permission.CAMERA'),
      isTrue,
    );
    expect(manifest, contains('android.hardware.camera'));
  });

  test('iOS camera and photo-library usage strings stay in place', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(
      plist,
      contains('Take a photo of a clothing item to add it to your wardrobe.'),
    );
    expect(
      plist,
      contains(
        'Choose a clothing photo from your library to add it to your wardrobe.',
      ),
    );
    expect(plist, contains('<key>NSCameraUsageDescription</key>'));
    expect(plist, contains('<key>NSPhotoLibraryUsageDescription</key>'));
  });

  test('enableAndroidPhotoPicker opts the Android implementation in', () {
    final android = ImagePickerAndroid();
    expect(android.useAndroidPhotoPicker, isFalse);

    enableAndroidPhotoPicker(android);

    expect(android.useAndroidPhotoPicker, isTrue);
  });

  test(
    'enableAndroidPhotoPicker is a no-op for non-Android implementations',
    () {
      final previous = ImagePickerPlatform.instance;
      addTearDown(() => ImagePickerPlatform.instance = previous);

      enableAndroidPhotoPicker(previous);
    },
  );
}

bool _isGrantedWithoutRemove(String manifest, String permission) {
  final match = RegExp(
    r'<uses-permission\b[^>]*android:name="' +
        RegExp.escape(permission) +
        r'"[^>]*/?>',
    multiLine: true,
  ).firstMatch(manifest);
  if (match == null) {
    return false;
  }
  return !match.group(0)!.contains('tools:node="remove"');
}
