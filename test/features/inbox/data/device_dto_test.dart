import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/inbox/data/device_dtos.dart';
import 'package:wardrobe_app/features/inbox/domain/device_registration.dart';

void main() {
  group('RegisterDeviceRequest (WARDROBE-114)', () {
    test('omits optional deviceId', () {
      expect(
        const RegisterDeviceRequest(
          token: 'fcm-token',
          platform: 'ANDROID',
        ).toJson(),
        {'token': 'fcm-token', 'platform': 'ANDROID'},
      );
    });

    test('includes deviceId when present', () {
      expect(
        const RegisterDeviceRequest(
          token: 'fcm-token',
          platform: 'IOS',
          deviceId: 'dev_abc',
        ).toJson(),
        {'token': 'fcm-token', 'platform': 'IOS', 'deviceId': 'dev_abc'},
      );
    });
  });

  group('DeviceRegistrationResponse', () {
    test('maps deviceId platform and updatedAt; token is absent', () {
      final json = {
        'deviceId': 'dev_abc123xyz0',
        'platform': 'IOS',
        'updatedAt': '2026-09-19T10:00:00.000Z',
      };
      final device = DeviceRegistrationResponse.fromJson(json).toDomain();
      expect(device.deviceId, 'dev_abc123xyz0');
      expect(device.platform, DevicePlatform.ios);
      expect(
        DeviceRegistrationResponse.fromJson(json).toJson().containsKey('token'),
        isFalse,
      );
    });
  });
}
