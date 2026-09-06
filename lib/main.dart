import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'features/items/data/image_picker_item_image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  enableAndroidPhotoPicker();
  await initializeFirebaseIfConfigured();
  runApp(const ProviderScope(child: WardrobeApp()));
}
