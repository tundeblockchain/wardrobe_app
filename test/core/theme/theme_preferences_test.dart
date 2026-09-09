import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_app/core/theme/theme_preferences.dart';

void main() {
  group('ThemePreferences codec', () {
    test('encodes ThemeMode values', () {
      expect(ThemePreferences.encode(ThemeMode.light), 'light');
      expect(ThemePreferences.encode(ThemeMode.dark), 'dark');
      expect(ThemePreferences.encode(ThemeMode.system), 'system');
    });

    test('decodes known values and defaults missing/unknown to system', () {
      expect(ThemePreferences.decode('light'), ThemeMode.light);
      expect(ThemePreferences.decode('dark'), ThemeMode.dark);
      expect(ThemePreferences.decode('system'), ThemeMode.system);
      expect(ThemePreferences.decode(null), ThemeMode.system);
      expect(ThemePreferences.decode(''), ThemeMode.system);
      expect(ThemePreferences.decode('midnight'), ThemeMode.system);
    });
  });

  group('SharedPreferencesThemeStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('defaults to system when no key is stored', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharedPreferencesThemeStore(prefs);
      expect(store.read(), ThemeMode.system);
    });

    test('persists light and dark across a new store instance', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharedPreferencesThemeStore(prefs);

      await store.write(ThemeMode.dark);
      expect(store.read(), ThemeMode.dark);
      expect(prefs.getString(ThemePreferences.preferenceKey), 'dark');

      final restarted = SharedPreferencesThemeStore(
        await SharedPreferences.getInstance(),
      );
      expect(restarted.read(), ThemeMode.dark);

      await restarted.write(ThemeMode.light);
      expect(
        SharedPreferencesThemeStore(await SharedPreferences.getInstance())
            .read(),
        ThemeMode.light,
      );
    });
  });

  test('InMemoryThemePreferences writes stay in memory', () async {
    final store = InMemoryThemePreferences();
    expect(store.read(), ThemeMode.system);
    await store.write(ThemeMode.dark);
    expect(store.read(), ThemeMode.dark);
    expect(store.writeCount, 1);
  });
}
