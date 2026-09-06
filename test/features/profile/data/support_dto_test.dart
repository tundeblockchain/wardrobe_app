import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/profile/data/support_dtos.dart';

void main() {
  group('SupportRequest', () {
    test('serializes subject and message', () {
      expect(
        const SupportRequest(
          subject: 'Hello',
          message: 'Please help with my wardrobe.',
        ).toJson(),
        {'subject': 'Hello', 'message': 'Please help with my wardrobe.'},
      );
    });

    test('includes optional device and appVersion when present', () {
      expect(
        const SupportRequest(
          subject: 'Crash',
          message: 'The add-item screen froze after picking a photo.',
          device: 'Pixel 8 (Android 14)',
          appVersion: '1.0.0+1',
        ).toJson(),
        {
          'subject': 'Crash',
          'message': 'The add-item screen froze after picking a photo.',
          'device': 'Pixel 8 (Android 14)',
          'appVersion': '1.0.0+1',
        },
      );
    });

    test('omits null optional fields', () {
      final json = const SupportRequest(
        subject: 'Hello',
        message: 'Please help with my wardrobe.',
      ).toJson();

      expect(json.containsKey('device'), isFalse);
      expect(json.containsKey('appVersion'), isFalse);
    });

    test('round-trips fromJson', () {
      final json = {
        'subject': 'Crash',
        'message': 'The add-item screen froze after picking a photo.',
        'device': 'iOS 18.0',
        'appVersion': '1.0.0+1',
      };

      expect(SupportRequest.fromJson(json).toJson(), json);
    });
  });
}
