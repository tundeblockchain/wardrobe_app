import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/theme/theme_preferences.dart';
import 'features/entitlements/data/superwall_sdk_binding.dart';
import 'features/items/data/image_picker_item_image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  enableAndroidPhotoPicker();
  await initializeFirebaseIfConfigured();
  if (AppConfig.fromEnvironment().hasSuperwallApiKey) {
    bindProductionSuperwallSdk();
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        themePreferencesProvider.overrideWithValue(
          SharedPreferencesThemeStore(prefs),
        ),
      ],
      child: const WardrobeApp(),
    ),
  );
}
