import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/presentation/apple_sign_in_support.dart';

void main() {
  test('isAppleSignInSupported is true only on iOS', () {
    expect(isAppleSignInSupported(platform: TargetPlatform.iOS), isTrue);
    expect(isAppleSignInSupported(platform: TargetPlatform.android), isFalse);
    expect(isAppleSignInSupported(platform: TargetPlatform.linux), isFalse);
    expect(isAppleSignInSupported(platform: TargetPlatform.macOS), isFalse);
  });
}
