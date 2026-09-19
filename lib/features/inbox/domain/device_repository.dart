import 'device_registration.dart';

/// Optional FCM device registration (WARDROBE-114). Inbox works without it.
abstract interface class DeviceRepository {
  Future<DeviceRegistration> register({
    required String token,
    required DevicePlatform platform,
    String? deviceId,
  });

  Future<void> unregister(String deviceId);
}
