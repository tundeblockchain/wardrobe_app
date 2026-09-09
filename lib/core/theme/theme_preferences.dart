import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted [ThemeMode] (WARDROBE-70). Device-scoped, not account data.
abstract class ThemePreferences {
  static const preferenceKey = 'theme_mode';

  ThemeMode read();

  Future<void> write(ThemeMode mode);

  static String encode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  static ThemeMode decode(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }
}

/// SharedPreferences-backed store used in production.
class SharedPreferencesThemeStore implements ThemePreferences {
  SharedPreferencesThemeStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  ThemeMode read() =>
      ThemePreferences.decode(_prefs.getString(ThemePreferences.preferenceKey));

  @override
  Future<void> write(ThemeMode mode) {
    return _prefs.setString(
      ThemePreferences.preferenceKey,
      ThemePreferences.encode(mode),
    );
  }
}

/// In-memory store for tests and the default provider (overridden in [main]).
class InMemoryThemePreferences implements ThemePreferences {
  InMemoryThemePreferences([this.mode = ThemeMode.system]);

  ThemeMode mode;
  int writeCount = 0;

  @override
  ThemeMode read() => mode;

  @override
  Future<void> write(ThemeMode next) async {
    writeCount++;
    mode = next;
  }
}

/// Defaults to an in-memory store so widget tests do not need SharedPreferences.
/// Production [main] overrides this with [SharedPreferencesThemeStore].
final themePreferencesProvider = Provider<ThemePreferences>((ref) {
  return InMemoryThemePreferences();
});
