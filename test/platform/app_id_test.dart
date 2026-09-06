import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String kCanonicalAppId = 'com.tundetunde.wardrobe';

void main() {
  test('Android applicationId and namespace are the canonical app id', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('namespace = "$kCanonicalAppId"'));
    expect(gradle, contains('applicationId = "$kCanonicalAppId"'));
    expect(gradle, isNot(contains('com.example.wardrobe_app')));
  });

  test('Android MainActivity package matches the canonical app id', () {
    final mainActivity = File(
      'android/app/src/main/kotlin/com/tundetunde/wardrobe/MainActivity.kt',
    ).readAsStringSync();
    expect(mainActivity, contains('package $kCanonicalAppId'));
    expect(
      File(
        'android/app/src/main/kotlin/com/example/wardrobe_app/MainActivity.kt',
      ).existsSync(),
      isFalse,
    );
  });

  test('iOS Runner PRODUCT_BUNDLE_IDENTIFIER is the canonical app id', () {
    final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    expect(
      RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = com\.tundetunde\.wardrobe;')
          .allMatches(pbx)
          .length,
      3,
    );
    expect(pbx, contains('PRODUCT_BUNDLE_IDENTIFIER = $kCanonicalAppId;'));
    expect(pbx, isNot(contains('com.example.wardrobeApp')));
  });

  test('iOS Info.plist uses PRODUCT_BUNDLE_IDENTIFIER', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains('<key>CFBundleIdentifier</key>'));
    expect(plist, contains('<string>\$(PRODUCT_BUNDLE_IDENTIFIER)</string>'));
  });
}
