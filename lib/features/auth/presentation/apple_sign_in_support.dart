import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sign in with Apple is offered on iOS only.
///
/// Hidden on Android (and every other host). Widget tests can pass [platform]
/// or override [appleSignInSupportedProvider].
bool isAppleSignInSupported({TargetPlatform? platform}) {
  if (kIsWeb) {
    return false;
  }
  return (platform ?? defaultTargetPlatform) == TargetPlatform.iOS;
}

/// UI visibility for the Apple button. Defaults to [isAppleSignInSupported].
final appleSignInSupportedProvider = Provider<bool>((ref) {
  return isAppleSignInSupported();
});
