import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';

void main() {
  test('providerLabel maps known Firebase provider ids', () {
    expect(
      const AppUser(uid: '1', providerId: 'password').providerLabel,
      'Email',
    );
    expect(
      const AppUser(uid: '1', providerId: 'google.com').providerLabel,
      'Google',
    );
    expect(
      const AppUser(uid: '1', providerId: 'apple.com').providerLabel,
      'Apple',
    );
    expect(const AppUser(uid: '1').providerLabel, isNull);
    expect(
      const AppUser(uid: '1', providerId: 'twitter.com').providerLabel,
      'twitter.com',
    );
  });
}
