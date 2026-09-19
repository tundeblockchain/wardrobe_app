/// Wire `platform` for `PUT /me/devices`.
enum DevicePlatform {
  ios('IOS'),
  android('ANDROID');

  const DevicePlatform(this.wireValue);

  final String wireValue;

  static DevicePlatform? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final platform in DevicePlatform.values) {
      if (platform.wireValue == value) {
        return platform;
      }
    }
    return null;
  }
}

/// `PUT /me/devices` result. Token is write-only and never returned.
class DeviceRegistration {
  const DeviceRegistration({
    required this.deviceId,
    required this.platform,
    required this.updatedAt,
  });

  final String deviceId;
  final DevicePlatform platform;
  final DateTime updatedAt;
}

/// FCM registration token plus the platform the backend expects.
class PushToken {
  const PushToken({required this.token, required this.platform});

  final String token;
  final DevicePlatform platform;
}
