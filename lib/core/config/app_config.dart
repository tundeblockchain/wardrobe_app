/// Compile-time app configuration.
///
/// Values come from `--dart-define` / `--dart-define-from-file`. Defaults are
/// non-secret placeholders so CI and local unit tests do not need a real API.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Runtime configuration for network and environment wiring.
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  /// Reads compile-time dart-defines. Never stores secrets.
  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.example.com',
      ),
    );
  }

  /// Backend API origin used by Dio. Override with `--dart-define=API_BASE_URL=`.
  final String apiBaseUrl;
}

/// Default [AppConfig] from dart-defines. Override in tests as needed.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
