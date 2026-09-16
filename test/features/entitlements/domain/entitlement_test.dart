import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_action.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_error_codes.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_wire.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_catalog.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

void main() {
  group('SubscriptionTier', () {
    test('parses locked FREE | BASIC | PREMIUM', () {
      expect(SubscriptionTier.parse('FREE'), SubscriptionTier.free);
      expect(SubscriptionTier.parse('BASIC'), SubscriptionTier.basic);
      expect(SubscriptionTier.parse('PREMIUM'), SubscriptionTier.premium);
      expect(SubscriptionTier.parse('unknown'), SubscriptionTier.free);
      expect(SubscriptionTier.parse(null), SubscriptionTier.free);
      expect(SubscriptionTier.premium.wireValue, EntitlementWire.premium);
    });
  });

  group('Entitlement.forTier', () {
    test('Free caps wardrobes, items, outfits and blocks AI', () {
      final entitlement = Entitlement.free;
      expect(entitlement.tier, SubscriptionTier.free);
      expect(entitlement.status, EntitlementStatus.none);
      expect(entitlement.canCreateWardrobe(0), isTrue);
      expect(entitlement.canCreateWardrobe(1), isFalse);
      expect(entitlement.canCreateItem(4), isTrue);
      expect(entitlement.canCreateItem(5), isFalse);
      expect(entitlement.canCreateOutfit(5), isFalse);
      expect(entitlement.canUseAiTryOn, isFalse);
      expect(entitlement.canUseOtherAi, isFalse);
      expect(entitlement.features.unlimitedCatalog, isFalse);
      expect(
        entitlement.limits?.wardrobes,
        SubscriptionCatalog.freeMaxWardrobes,
      );
      expect(entitlement.limits?.items, SubscriptionCatalog.freeMaxItems);
      expect(entitlement.limits?.outfits, SubscriptionCatalog.freeMaxOutfits);
    });

    test('Basic is unlimited storage without AI', () {
      final entitlement = Entitlement.basic;
      expect(entitlement.limits, isNull);
      expect(entitlement.features.unlimitedCatalog, isTrue);
      expect(entitlement.canCreateWardrobe(20), isTrue);
      expect(entitlement.canCreateItem(99), isTrue);
      expect(entitlement.canCreateOutfit(99), isTrue);
      expect(entitlement.canUseAiTryOn, isFalse);
      expect(entitlement.canUseOtherAi, isFalse);
    });

    test('Premium unlocks AI', () {
      final entitlement = Entitlement.premium;
      expect(entitlement.limits, isNull);
      expect(entitlement.canUseAiTryOn, isTrue);
      expect(entitlement.canUseOtherAi, isTrue);
      expect(entitlement.canCreateWardrobe(100), isTrue);
    });
  });

  group('Entitlement.fromJson', () {
    test('parses locked GET /me DTO', () {
      final parsed = Entitlement.fromJson({
        'userId': 'firebase-uid',
        'tier': 'FREE',
        'status': 'NONE',
        'features': {
          'unlimitedCatalog': false,
          'aiTryOn': false,
          'otherAi': false,
        },
        'limits': {'wardrobes': 1, 'items': 5, 'outfits': 5},
        'usage': {'wardrobes': 0, 'items': 0, 'outfits': 0},
        'updatedAt': '2026-09-16T12:00:00.000Z',
      });
      expect(parsed.userId, 'firebase-uid');
      expect(parsed.tier, SubscriptionTier.free);
      expect(parsed.status, EntitlementStatus.none);
      expect(parsed.features, EntitlementFeatures.free);
      expect(parsed.limits, EntitlementLimits.free);
      expect(parsed.usage, EntitlementUsage.zero);
      expect(parsed.updatedAt, DateTime.utc(2026, 9, 16, 12));

      final premium = Entitlement.fromJson({
        'userId': 'uid-1',
        'tier': 'PREMIUM',
        'status': 'ACTIVE',
        'features': {
          'unlimitedCatalog': true,
          'aiTryOn': true,
          'otherAi': true,
        },
        'limits': null,
        'usage': {'wardrobes': 2, 'items': 10, 'outfits': 3},
        'productId': 'wardrobe_premium_monthly',
        'store': 'APP_STORE',
        'period': 'MONTHLY',
        'expiresAt': '2026-10-16T12:00:00.000Z',
        'updatedAt': '2026-09-16T12:00:00.000Z',
      });
      expect(premium.tier, SubscriptionTier.premium);
      expect(premium.status, EntitlementStatus.active);
      expect(premium.limits, isNull);
      expect(premium.canUseAiTryOn, isTrue);
      expect(premium.store, EntitlementStore.appStore);
      expect(premium.period, EntitlementPeriod.monthly);
      expect(premium.usage.items, 10);
    });

    test('ignores Dynamo PK/SK/lastEventId if present', () {
      final parsed = Entitlement.fromJson({
        'userId': 'firebase-uid',
        'tier': 'BASIC',
        'status': 'ACTIVE',
        'features': {
          'unlimitedCatalog': true,
          'aiTryOn': false,
          'otherAi': false,
        },
        'limits': null,
        'usage': {'wardrobes': 1, 'items': 1, 'outfits': 0},
        'PK': 'USER#firebase-uid',
        'SK': 'ENTITLEMENT',
        'lastEventId': 'evt_should_not_leak',
      });
      expect(parsed.tier, SubscriptionTier.basic);
      expect(parsed.toJson().containsKey('PK'), isFalse);
      expect(parsed.toJson().containsKey('SK'), isFalse);
      expect(parsed.toJson().containsKey('lastEventId'), isFalse);
    });

    test('CANCELED Premium still has AI until GET /me reports FREE', () {
      final parsed = Entitlement.fromJson({
        'userId': 'uid-1',
        'tier': 'PREMIUM',
        'status': 'CANCELED',
        'features': {
          'unlimitedCatalog': true,
          'aiTryOn': true,
          'otherAi': true,
        },
        'limits': null,
        'usage': {'wardrobes': 1, 'items': 1, 'outfits': 0},
        'expiresAt': '2026-10-16T12:00:00.000Z',
      });
      expect(parsed.status, EntitlementStatus.canceled);
      expect(parsed.canUseAiTryOn, isTrue);
      expect(parsed.canUseOtherAi, isTrue);
      expect(parsed.limits, isNull);
    });

    test('unknown tier becomes FREE; omitted limits use catalog for Free', () {
      final parsed = Entitlement.fromJson({'tier': 'GOLD'});
      expect(parsed.tier, SubscriptionTier.free);
      expect(parsed.limits, EntitlementLimits.free);
    });

    test('toJson emits GET /me keys', () {
      final json = Entitlement.free.toJson();
      expect(json['tier'], 'FREE');
      expect(json['status'], 'NONE');
      expect(json['features'], {
        'unlimitedCatalog': false,
        'aiTryOn': false,
        'otherAi': false,
      });
      expect(json['limits'], {'wardrobes': 1, 'items': 5, 'outfits': 5});
      expect(Entitlement.premium.toJson()['limits'], isNull);
      expect(Entitlement.premium.toJson()['tier'], 'PREMIUM');
    });
  });

  group('PaywallPlacement', () {
    test('maps locked Backend 403 codes to Superwall', () {
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(
            message: 'Wardrobe limit',
            code: EntitlementErrorCodes.wardrobeLimit,
            statusCode: 403,
          ),
        ),
        PaywallPlacement.wardrobeLimit,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(
            message: 'Item limit',
            code: EntitlementErrorCodes.itemLimit,
            statusCode: 403,
          ),
        ),
        PaywallPlacement.itemLimit,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(
            message: 'Outfit limit',
            code: EntitlementErrorCodes.outfitLimit,
            statusCode: 403,
          ),
        ),
        PaywallPlacement.outfitLimit,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(
            message: 'Try-on requires Premium',
            code: EntitlementErrorCodes.aiRequired,
            statusCode: 403,
          ),
          fallback: PaywallPlacement.aiTryOn,
        ),
        PaywallPlacement.aiTryOn,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(
            message: 'AI required',
            code: EntitlementErrorCodes.aiRequired,
            statusCode: 403,
          ),
        ),
        PaywallPlacement.otherAi,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(message: 'Not found', statusCode: 404),
        ),
        isNull,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(message: 'Forbidden', statusCode: 403),
          fallback: PaywallPlacement.upgradePremium,
        ),
        PaywallPlacement.upgradePremium,
      );
    });
  });

  group('EntitlementAction', () {
    test('Free hits wardrobe limit toward Basic', () {
      expect(
        EntitlementAction.createWardrobe.isAllowed(
          Entitlement.free,
          currentCount: 1,
        ),
        isFalse,
      );
      expect(
        EntitlementAction.createWardrobe.placement,
        PaywallPlacement.wardrobeLimit,
      );
    });

    test('Basic hits AI toward Premium', () {
      expect(EntitlementAction.aiTryOn.isAllowed(Entitlement.basic), isFalse);
      expect(EntitlementAction.otherAi.isAllowed(Entitlement.basic), isFalse);
      expect(EntitlementAction.aiTryOn.placement, PaywallPlacement.aiTryOn);
    });
  });
}
