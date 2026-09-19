import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../domain/device_registration.dart';
import '../domain/push_token_source.dart';

/// Optional FCM token + notification tap payloads.
///
/// Soft-fails when Firebase is not initialized, Messaging is not configured,
/// or the user denies notification permission. Inbox polling does not depend
/// on this source.
class FirebasePushTokenSource implements PushTokenSource {
  const FirebasePushTokenSource();

  bool get _ready {
    if (kIsWeb) {
      return false;
    }
    return Firebase.apps.isNotEmpty;
  }

  DevicePlatform? get _platform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return DevicePlatform.ios;
      case TargetPlatform.android:
        return DevicePlatform.android;
      default:
        return null;
    }
  }

  @override
  Future<PushToken?> current() async {
    try {
      if (!_ready) {
        return null;
      }
      final platform = _platform;
      if (platform == null) {
        return null;
      }
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null;
      }
      final token = await messaging.getToken();
      final trimmed = token?.trim();
      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }
      return PushToken(token: trimmed, platform: platform);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<String> get tokenRefresh {
    try {
      if (!_ready) {
        return const Stream.empty();
      }
      return FirebaseMessaging.instance.onTokenRefresh;
    } catch (_) {
      return const Stream.empty();
    }
  }

  @override
  Stream<Map<String, String>> get openedMessages {
    try {
      if (!_ready) {
        return const Stream.empty();
      }
      return FirebaseMessaging.onMessageOpenedApp.map(_dataOf);
    } catch (_) {
      return const Stream.empty();
    }
  }

  @override
  Stream<Map<String, String>> get foregroundMessages {
    try {
      if (!_ready) {
        return const Stream.empty();
      }
      return FirebaseMessaging.onMessage.map(_dataOf);
    } catch (_) {
      return const Stream.empty();
    }
  }

  @override
  Future<Map<String, String>?> initialMessage() async {
    try {
      if (!_ready) {
        return null;
      }
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message == null) {
        return null;
      }
      final data = _dataOf(message);
      return data.isEmpty ? null : data;
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _dataOf(RemoteMessage message) {
    return {
      for (final entry in message.data.entries)
        if (entry.value.toString().trim().isNotEmpty)
          entry.key: entry.value.toString(),
    };
  }
}
