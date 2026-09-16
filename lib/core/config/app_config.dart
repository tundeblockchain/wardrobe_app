/// Compile-time app configuration.
///
/// Values come from `--dart-define` / `--dart-define-from-file`. Defaults are
/// non-secret placeholders so CI and local unit tests do not need a real API.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder App Store / Play product IDs until the operator creates them.
///
/// Override with dart-defines. These are identifiers, not secrets.
class SubscriptionProductIds {
  const SubscriptionProductIds({
    this.basicMonthly = 'wardrobe_basic_monthly',
    this.basicYearly = 'wardrobe_basic_yearly',
    this.premiumMonthly = 'wardrobe_premium_monthly',
    this.premiumYearly = 'wardrobe_premium_yearly',
  });

  factory SubscriptionProductIds.fromEnvironment() {
    return const SubscriptionProductIds(
      basicMonthly: String.fromEnvironment(
        'SUPERWALL_PRODUCT_BASIC_MONTHLY',
        defaultValue: 'wardrobe_basic_monthly',
      ),
      basicYearly: String.fromEnvironment(
        'SUPERWALL_PRODUCT_BASIC_YEARLY',
        defaultValue: 'wardrobe_basic_yearly',
      ),
      premiumMonthly: String.fromEnvironment(
        'SUPERWALL_PRODUCT_PREMIUM_MONTHLY',
        defaultValue: 'wardrobe_premium_monthly',
      ),
      premiumYearly: String.fromEnvironment(
        'SUPERWALL_PRODUCT_PREMIUM_YEARLY',
        defaultValue: 'wardrobe_premium_yearly',
      ),
    );
  }

  final String basicMonthly;
  final String basicYearly;
  final String premiumMonthly;
  final String premiumYearly;
}

/// Runtime configuration for network, Superwall, and environment wiring.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    this.superwallApiKey = '',
    this.superwallIosApiKey = '',
    this.superwallAndroidApiKey = '',
    this.productIds = const SubscriptionProductIds(),
  });

  /// Reads compile-time dart-defines. Never stores secrets.
  factory AppConfig.fromEnvironment() {
    return AppConfig(
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.example.com',
      ),
      superwallApiKey: const String.fromEnvironment('SUPERWALL_API_KEY'),
      superwallIosApiKey: const String.fromEnvironment('SUPERWALL_IOS_API_KEY'),
      superwallAndroidApiKey: const String.fromEnvironment(
        'SUPERWALL_ANDROID_API_KEY',
      ),
      productIds: SubscriptionProductIds.fromEnvironment(),
    );
  }

  /// Backend API origin used by Dio. Override with `--dart-define=API_BASE_URL=`.
  final String apiBaseUrl;

  /// Generic Superwall public API key. Prefer the platform-specific keys.
  final String superwallApiKey;

  /// iOS Superwall public API key from the dashboard.
  final String superwallIosApiKey;

  /// Android Superwall public API key from the dashboard.
  final String superwallAndroidApiKey;

  /// Placeholder store product IDs (operator replaces via dart-defines).
  final SubscriptionProductIds productIds;

  /// Platform Superwall key, falling back to [superwallApiKey].
  String get resolvedSuperwallApiKey {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return superwallIosApiKey.isNotEmpty
            ? superwallIosApiKey
            : superwallApiKey;
      case TargetPlatform.android:
        return superwallAndroidApiKey.isNotEmpty
            ? superwallAndroidApiKey
            : superwallApiKey;
      default:
        return superwallApiKey;
    }
  }

  bool get hasSuperwallApiKey => resolvedSuperwallApiKey.isNotEmpty;
}

/// Default [AppConfig] from dart-defines. Override in tests as needed.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
