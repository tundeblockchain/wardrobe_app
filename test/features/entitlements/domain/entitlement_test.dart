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
    test('parses uppercase Backend enum and lowercase aliases', () {
      expect(SubscriptionTier.parse('FREE'), SubscriptionTier.free);
      expect(SubscriptionTier.parse('BASIC'), SubscriptionTier.basic);
      expect(SubscriptionTier.parse('PREMIUM'), SubscriptionTier.premium);
      expect(SubscriptionTier.parse('premium'), SubscriptionTier.premium);
      expect(SubscriptionTier.parse(null), SubscriptionTier.free);
      expect(SubscriptionTier.premium.wireValue, EntitlementWire.premium);
    });
  });

  group('Entitlement.forTier', () {
    test('Free caps wardrobes, items, outfits and blocks AI', () {
      final entitlement = Entitlement.free;
      expect(entitlement.tier, SubscriptionTier.free);
      expect(entitlement.canCreateWardrobe(0), isTrue);
      expect(entitlement.canCreateWardrobe(1), isFalse);
      expect(entitlement.canCreateItem(4), isTrue);
      expect(entitlement.canCreateItem(5), isFalse);
      expect(entitlement.canCreateOutfit(5), isFalse);
      expect(entitlement.canUseAiTryOn, isFalse);
      expect(entitlement.canUseOtherAi, isFalse);
      expect(
        entitlement.limits.maxWardrobes,
        SubscriptionCatalog.freeMaxWardrobes,
      );
      expect(entitlement.limits.maxItems, SubscriptionCatalog.freeMaxItems);
      expect(entitlement.limits.maxOutfits, SubscriptionCatalog.freeMaxOutfits);
    });

    test('Basic is unlimited storage without AI', () {
      final entitlement = Entitlement.basic;
      expect(entitlement.canCreateWardrobe(20), isTrue);
      expect(entitlement.canCreateItem(99), isTrue);
      expect(entitlement.canCreateOutfit(99), isTrue);
      expect(entitlement.canUseAiTryOn, isFalse);
      expect(entitlement.canUseOtherAi, isFalse);
    });

    test('Premium unlocks AI', () {
      final entitlement = Entitlement.premium;
      expect(entitlement.canUseAiTryOn, isTrue);
      expect(entitlement.canUseOtherAi, isTrue);
      expect(entitlement.canCreateWardrobe(100), isTrue);
    });
  });

  group('Entitlement.fromJson', () {
    test('parses GET /me Backend snapshot', () {
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
      });
      expect(parsed, Entitlement.free);

      final premium = Entitlement.fromJson({
        'tier': 'PREMIUM',
        'features': {
          'unlimitedCatalog': true,
          'aiTryOn': true,
          'otherAi': true,
        },
        'limits': null,
      });
      expect(premium, Entitlement.premium);
    });

    test('accepts nested entitlement, flags, and aiEnabled/tryOn aliases', () {
      final nested = Entitlement.fromJson({
        'entitlement': {
          'tier': 'PREMIUM',
          'flags': {'aiTryOn': true, 'otherAi': true},
        },
      });
      expect(nested.tier, SubscriptionTier.premium);
      expect(nested.canUseAiTryOn, isTrue);

      final aliases = Entitlement.fromJson({
        'tier': 'PREMIUM',
        'features': {'aiEnabled': true, 'tryOn': true},
      });
      expect(aliases.canUseAiTryOn, isTrue);
      expect(aliases.canUseOtherAi, isTrue);
    });

    test('fills catalog defaults when limits/features are omitted', () {
      final parsed = Entitlement.fromJson({'tier': 'FREE'});
      expect(parsed, Entitlement.free);
    });

    test('toJson emits uppercase tier, features, and limits', () {
      expect(Entitlement.free.toJson(), {
        'tier': 'FREE',
        'features': {
          'unlimitedCatalog': false,
          'aiTryOn': false,
          'otherAi': false,
        },
        'limits': {'wardrobes': 1, 'items': 5, 'outfits': 5},
      });
      expect(Entitlement.premium.toJson()['limits'], isNull);
      expect(Entitlement.premium.toJson()['tier'], 'PREMIUM');
    });
  });

  group('PaywallPlacement', () {
    test('maps Backend 403 codes to Superwall placements', () {
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
          const ApiException(message: 'Paywall', statusCode: 402),
          fallback: PaywallPlacement.otherAi,
        ),
        PaywallPlacement.otherAi,
      );
      expect(
        PaywallPlacement.fromApiException(
          const ApiException(message: 'Not found', statusCode: 404),
        ),
        isNull,
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
