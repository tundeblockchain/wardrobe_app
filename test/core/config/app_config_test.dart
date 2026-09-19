import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/config/app_config.dart';

void main() {
  test(
    'fromEnvironment uses placeholder product IDs and empty Superwall keys',
    () {
      const config = AppConfig(apiBaseUrl: 'https://api.example.com');
      expect(config.hasSuperwallApiKey, isFalse);
      expect(config.productIds.basicMonthly, 'wardrobe_basic_monthly');
      expect(config.productIds.premiumYearly, 'wardrobe_premium_yearly');
      expect(config.shareLandingBaseUrl, isEmpty);
    },
  );

  test('share landing base is stored from the constructor', () {
    const config = AppConfig(
      apiBaseUrl: 'https://api.example.com',
      shareLandingBaseUrl: 'https://share.example.com',
    );
    expect(config.shareLandingBaseUrl, 'https://share.example.com');
  });

  test('resolved Superwall key prefers platform-specific dart-defines', () {
    const config = AppConfig(
      apiBaseUrl: 'https://api.example.com',
      superwallApiKey: 'generic-key',
      superwallIosApiKey: 'ios-key',
      superwallAndroidApiKey: 'android-key',
    );
    expect(config.resolvedSuperwallApiKey, isNotEmpty);
    expect({
      config.superwallApiKey,
      config.superwallIosApiKey,
      config.superwallAndroidApiKey,
    }, contains(config.resolvedSuperwallApiKey));
  });
}
