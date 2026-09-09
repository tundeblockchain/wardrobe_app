import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/core/session/user_session_reset.dart';
import 'package:wardrobe_app/core/theme/theme_controller.dart';
import 'package:wardrobe_app/core/theme/theme_preferences.dart';

void main() {
  test('themeModeIsDark resolves system against platform brightness', () {
    expect(themeModeIsDark(ThemeMode.dark, Brightness.light), isTrue);
    expect(themeModeIsDark(ThemeMode.light, Brightness.dark), isFalse);
    expect(themeModeIsDark(ThemeMode.system, Brightness.dark), isTrue);
    expect(themeModeIsDark(ThemeMode.system, Brightness.light), isFalse);
  });

  test('controller loads stored mode and persists setDark', () async {
    final store = InMemoryThemePreferences(ThemeMode.light);
    final container = ProviderContainer.test(
      overrides: [themePreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    expect(container.read(themeControllerProvider), ThemeMode.light);

    await container.read(themeControllerProvider.notifier).setDark(true);
    expect(container.read(themeControllerProvider), ThemeMode.dark);
    expect(store.read(), ThemeMode.dark);
    expect(store.writeCount, 1);

    final restarted = ProviderContainer.test(
      overrides: [themePreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(restarted.dispose);
    expect(restarted.read(themeControllerProvider), ThemeMode.dark);
  });

  test('setMode is a no-op when the value is unchanged', () async {
    final store = InMemoryThemePreferences(ThemeMode.dark);
    final container = ProviderContainer.test(
      overrides: [themePreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container
        .read(themeControllerProvider.notifier)
        .setMode(ThemeMode.dark);
    expect(store.writeCount, 0);
  });

  test('session reset does not clear the device theme preference', () async {
    final store = InMemoryThemePreferences(ThemeMode.dark);
    final session = InMemorySessionLocalStore(
      preferences: {'lastWardrobe': 'wd_1'},
    );
    final container = ProviderContainer.test(
      overrides: [
        themePreferencesProvider.overrideWithValue(store),
        sessionLocalStoreProvider.overrideWithValue(session),
        sessionImageCacheProvider.overrideWithValue(
          RecordingSessionImageCache(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(userSessionResetProvider).clear();

    expect(store.read(), ThemeMode.dark);
    expect(session.preferences, isEmpty);
  });
}
