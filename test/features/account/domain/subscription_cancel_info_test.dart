import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/account/domain/subscription_cancel_info.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

void main() {
  group('SubscriptionCancelStatus.parse', () {
    test('maps locked WARDROBE-103 values only', () {
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
        SubscriptionCancelStatus.unknown,
      );
      expect(
        SubscriptionCancelStatus.parse('SKIPPED'),
        SubscriptionCancelStatus.unknown,
      );
      expect(
        SubscriptionCancelStatus.parse('FAILED'),
        SubscriptionCancelStatus.unknown,
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

  group('SubscriptionCancelMode.tryParse', () {
    test('maps IMMEDIATE and PERIOD_END and soft-omits the rest', () {
      expect(
        SubscriptionCancelMode.tryParse('IMMEDIATE'),
        SubscriptionCancelMode.immediate,
      );
      expect(
        SubscriptionCancelMode.tryParse('period_end'),
        SubscriptionCancelMode.periodEnd,
      );
      expect(SubscriptionCancelMode.tryParse(null), isNull);
      expect(SubscriptionCancelMode.tryParse('NOW'), isNull);
    });
  });

  group('SubscriptionCancelInfo.fromDeleteJson', () {
    test('soft-omits when subscription is absent', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'keepAccount': false,
        'deleted': true,
        'entitlementRevoked': true,
      });
      expect(info, SubscriptionCancelInfo.absent);
      expect(info.isFailed, isFalse);
      expect(info.retryInStore, isFalse);
    });

    test('parses locked WARDROBE-103 subscription object', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscription': {
          'status': 'CANCEL_FAILED',
          'cancelMode': 'IMMEDIATE',
          'store': 'APP_STORE',
          'expiresAt': '2026-10-01T00:00:00.000Z',
          'retryInStore': true,
        },
      });
      expect(info.status, SubscriptionCancelStatus.cancelFailed);
      expect(info.cancelMode, SubscriptionCancelMode.immediate);
      expect(info.store, EntitlementStore.appStore);
      expect(info.expiresAt, DateTime.utc(2026, 10));
      expect(info.retryInStore, isTrue);
      expect(info.isFailed, isTrue);
      expect(info.shouldManageInStore, isTrue);
    });

    test('soft-omits unset optionals on NONE', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscription': {'status': 'NONE'},
      });
      expect(info.status, SubscriptionCancelStatus.none);
      expect(info.cancelMode, isNull);
      expect(info.store, isNull);
      expect(info.expiresAt, isNull);
      expect(info.retryInStore, isFalse);
      expect(info.isResolvedSuccess, isTrue);
    });

    test('parses CANCELED without retryInStore', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscription': {
          'status': 'CANCELED',
          'cancelMode': 'IMMEDIATE',
          'store': 'PLAY_STORE',
        },
      });
      expect(info.status, SubscriptionCancelStatus.canceled);
      expect(info.store, EntitlementStore.playStore);
      expect(info.retryInStore, isFalse);
      expect(info.isResolvedSuccess, isTrue);
    });

    test('parses CANCEL_AT_PERIOD_END', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscription': {
          'status': 'CANCEL_AT_PERIOD_END',
          'cancelMode': 'PERIOD_END',
          'expiresAt': '2026-10-01T00:00:00.000Z',
        },
      });
      expect(info.status, SubscriptionCancelStatus.cancelAtPeriodEnd);
      expect(info.cancelMode, SubscriptionCancelMode.periodEnd);
      expect(info.isPeriodEnd, isTrue);
      expect(info.retryInStore, isFalse);
    });

    test('ignores invented sketch keys on the nested object', () {
      final info = SubscriptionCancelInfo.fromDeleteJson(const {
        'subscriptionCancel': {'status': 'FAILED'},
        'subscriptionCancelFailed': true,
        'subscription': {'status': 'CANCELED'},
      });
      expect(info.status, SubscriptionCancelStatus.canceled);
      expect(info.isFailed, isFalse);
    });
  });
}
