import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../data/dio_device_repository.dart';
import '../data/firebase_push_token_source.dart';
import '../domain/device_registration.dart';
import '../domain/device_repository.dart';
import '../domain/push_token_source.dart';

/// Registers an FCM token when Messaging is available. Soft-fails otherwise.
class DeviceRegistrationController extends Notifier<DeviceRegistration?> {
  @override
  DeviceRegistration? build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return null;
    }
    Future<void>.microtask(registerIfAvailable);
    final source = ref.read(pushTokenSourceProvider);
    final refresh = source.tokenRefresh.listen((_) {
      registerIfAvailable();
    });
    ref.onDispose(refresh.cancel);
    return null;
  }

  DeviceRepository get _repository => ref.read(deviceRepositoryProvider);

  PushTokenSource get _tokens => ref.read(pushTokenSourceProvider);

  Future<void> registerIfAvailable() async {
    try {
      final token = await _tokens.current();
      if (token == null || !ref.mounted) {
        return;
      }
      final registration = await _repository.register(
        token: token.token,
        platform: token.platform,
        deviceId: state?.deviceId,
      );
      if (!ref.mounted) {
        return;
      }
      state = registration;
    } catch (_) {
      // Inbox polling does not depend on device registration.
    }
  }

  Future<void> unregister() async {
    final deviceId = state?.deviceId;
    if (deviceId == null) {
      return;
    }
    try {
      await _repository.unregister(deviceId);
    } catch (_) {
      // Sign-out still proceeds.
    }
    if (ref.mounted) {
      state = null;
    }
  }
}

final pushTokenSourceProvider = Provider<PushTokenSource>((ref) {
  return const FirebasePushTokenSource();
});

final deviceRegistrationControllerProvider =
    NotifierProvider<DeviceRegistrationController, DeviceRegistration?>(
      DeviceRegistrationController.new,
    );
