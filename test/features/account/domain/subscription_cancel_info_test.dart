import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/account/domain/account_delete_wire.dart';
import 'package:wardrobe_app/features/account/domain/subscription_cancel_info.dart';

void main() {
  group('SubscriptionCancelStatus.parse', () {
    test('maps locked WARDROBE-103 values and sketch aliases', () {
      expect(
        SubscriptionCancelStatus.parse('NONE'),
        SubscriptionCancelStatus.none,
      );
      expect(
        SubscriptionCancelStatus.parse('canceled'),
        SubscriptionCancelStatus.canceled,
      );
      expect(
        SubscriptionCancelStatus.parse('CANCEL_AT_PERIOD_END'),
        SubscriptionCancelStatus.cancelAtPeriodEnd,
      );
      expect(
        SubscriptionCancelStatus.parse('CANCEL_FAILED'),
        SubscriptionCancelStatus.cancelFailed,
      );
      expect(
        SubscriptionCancelStatus.parse('SUCCEEDED'),
        SubscriptionCancelStatus.succeeded,
      );
      expect(
        SubscriptionCancelStatus.parse('SKIPPED'),
        SubscriptionCancelStatus.skipped,
      );
      expect(
        SubscriptionCancelStatus.parse('FAILED'),
        SubscriptionCancelStatus.failed,
      );
      expect(
        SubscriptionCancelStatus.parse(null),
        SubscriptionCancelStatus.unknown,
      );
      expect(
        SubscriptionCancelStatus.parse('mystery'),
        SubscriptionCancelStatus.unknown,
      );
    });
  });

  group('SubscriptionCancelInfo.fromDeleteJson', () {
    test('soft-omits when no subscription fields are present', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'keepAccount': false,
      });
      expect(info, SubscriptionCancelInfo.absent);
      expect(info.isFailed, isFalse);
    });

    test('parses WARDROBE-103 subscription object', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscription': {
          'status': 'CANCEL_FAILED',
          'cancelMode': 'IMMEDIATE',
          'store': 'APP_STORE',
          'expiresAt': '2026-10-01T00:00:00.000Z',
          'retryInStore': true,
          'code': 'SUBSCRIPTION_CANCEL_FAILED',
          'message': 'Store cancel timed out.',
        },
      });
      expect(info.status, SubscriptionCancelStatus.cancelFailed);
      expect(info.cancelMode, 'IMMEDIATE');
      expect(info.store, 'APP_STORE');
      expect(info.expiresAt, DateTime.utc(2026, 10));
      expect(info.retryInStore, isTrue);
      expect(info.code, AccountDeleteWire.subscriptionCancelFailedCode);
      expect(info.message, 'Store cancel timed out.');
      expect(info.isFailed, isTrue);
      expect(info.shouldManageInStore, isTrue);
    });

    test('maps subscriptionCancelFailed flag without nested object', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscriptionCancelFailed': true,
        'code': 'SUBSCRIPTION_CANCEL_FAILED',
        'message': 'Could not cancel.',
      });
      expect(info.status, SubscriptionCancelStatus.cancelFailed);
      expect(info.isFailed, isTrue);
      expect(info.message, 'Could not cancel.');
    });

    test('accepts sketch subscriptionCancel nested object', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscriptionCancel': {'status': 'SUCCEEDED'},
      });
      expect(info.status, SubscriptionCancelStatus.succeeded);
      expect(info.isFailed, isFalse);
    });

    test('prefers subscription over subscriptionCancel', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscriptionCancel': {'status': 'FAILED'},
        'subscription': {'status': 'CANCELED'},
      });
      expect(info.status, SubscriptionCancelStatus.canceled);
      expect(info.isFailed, isFalse);
    });
  });
}
