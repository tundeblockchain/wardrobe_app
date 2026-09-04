/// Firebase initialization without committing secrets.
///
/// Options are supplied via `--dart-define` (or a local gitignored
/// `lib/firebase_options.dart` that you copy values from). If required
/// values are missing, initialization is skipped so CI/analyze/test stay green.
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// Builds [FirebaseOptions] from compile-time dart-defines.
///
/// Returns `null` when the required placeholders are unset so callers can
/// skip [Firebase.initializeApp] instead of shipping dummy keys.
FirebaseOptions? firebaseOptionsFromEnvironment() {
  const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  const appId = String.fromEnvironment('FIREBASE_APP_ID');
  const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');

  if (apiKey.isEmpty ||
      appId.isEmpty ||
      messagingSenderId.isEmpty ||
      projectId.isEmpty) {
    return null;
  }

  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    storageBucket: storageBucket.isEmpty ? null : storageBucket,
    authDomain: authDomain.isEmpty ? null : authDomain,
  );
}

/// Initializes Firebase when dart-defines are present.
///
/// Returns `true` when an app was created. Safe to call multiple times.
Future<bool> initializeFirebaseIfConfigured() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isNotEmpty) {
    return true;
  }

  final options = firebaseOptionsFromEnvironment();
  if (options == null) {
    return false;
  }

  await Firebase.initializeApp(options: options);
  return true;
}
