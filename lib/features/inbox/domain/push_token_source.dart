import 'device_registration.dart';

/// Optional FCM token. Soft-fails when Messaging is not configured.
abstract interface class PushTokenSource {
  Future<PushToken?> current();

  Stream<String> get tokenRefresh;

  Stream<Map<String, String>> get openedMessages;

  Stream<Map<String, String>> get foregroundMessages;

  Future<Map<String, String>?> initialMessage();
}

/// Default when Firebase Messaging is missing or throws.
class UnavailablePushTokenSource implements PushTokenSource {
  const UnavailablePushTokenSource();

  @override
  Future<PushToken?> current() async => null;

  @override
  Stream<String> get tokenRefresh => const Stream.empty();

  @override
  Stream<Map<String, String>> get openedMessages => const Stream.empty();

  @override
  Stream<Map<String, String>> get foregroundMessages => const Stream.empty();

  @override
  Future<Map<String, String>?> initialMessage() async => null;
}
