import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/profile/data/support_dtos.dart';

void main() {
  group('SupportRequest (WARDROBE-38)', () {
    test('serializes subject and body', () {
      expect(
        const SupportRequest(
          subject: 'Hello',
          body: 'Please help with my wardrobe.',
        ).toJson(),
        {'subject': 'Hello', 'body': 'Please help with my wardrobe.'},
      );
    });

    test('includes optional replyTo and meta when present', () {
      expect(
        const SupportRequest(
          subject: 'Crash',
          body: 'The add-item screen froze after picking a photo.',
          replyTo: 'user@example.com',
          meta: {
            'appVersion': '1.0.0',
            'platform': 'ios',
            'deviceModel': 'iPhone 15',
            'osVersion': '18.1',
          },
        ).toJson(),
        {
          'subject': 'Crash',
          'body': 'The add-item screen froze after picking a photo.',
          'replyTo': 'user@example.com',
          'meta': {
            'appVersion': '1.0.0',
            'platform': 'ios',
            'deviceModel': 'iPhone 15',
            'osVersion': '18.1',
          },
        },
      );
    });

    test('omits null optional fields', () {
      final json = const SupportRequest(
        subject: 'Hello',
        body: 'Please help with my wardrobe.',
      ).toJson();

      expect(json.containsKey('replyTo'), isFalse);
      expect(json.containsKey('meta'), isFalse);
      expect(json.containsKey('message'), isFalse);
    });

    test('round-trips fromJson', () {
      final json = {
        'subject': 'Crash',
        'body': 'The add-item screen froze after picking a photo.',
        'replyTo': 'user@example.com',
        'meta': {'appVersion': '1.0.0+1', 'platform': 'android'},
      };

      expect(SupportRequest.fromJson(json).toJson(), json);
    });
  });
}
