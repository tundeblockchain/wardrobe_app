import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_preferences.dart';

/// App-wide [ThemeMode]. Loads from [ThemePreferences] and writes on change.
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.watch(themePreferencesProvider).read();

  Future<void> setMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }
    state = mode;
    await ref.read(themePreferencesProvider).write(mode);
  }

  Future<void> setDark(bool dark) {
    return setMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

/// Resolved dark/light for a [ThemeMode], including [ThemeMode.system].
bool themeModeIsDark(ThemeMode mode, Brightness platformBrightness) {
  return switch (mode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => platformBrightness == Brightness.dark,
  };
}
