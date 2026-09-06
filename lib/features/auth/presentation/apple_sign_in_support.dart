import 'package:flutter/foundation.dart';

/// Sign in with Apple is offered on iOS only.
///
/// Hidden on Android (and every other host). Widget tests can pass [platform]
/// or set [debugDefaultTargetPlatformOverride].
bool isAppleSignInSupported({TargetPlatform? platform}) {
  if (kIsWeb) {
    return false;
  }
  return (platform ?? defaultTargetPlatform) == TargetPlatform.iOS;
}
