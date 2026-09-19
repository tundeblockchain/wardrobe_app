import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_error_codes.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_paywall_copy.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

void main() {
  group('EntitlementErrorCodes', () {
    test('treats unknown ENTITLEMENT_* prefixes as entitlement codes', () {
      expect(
        EntitlementErrorCodes.isEntitlementCode('ENTITLEMENT_SOMETHING_NEW'),
        isTrue,
      );
      expect(
        EntitlementErrorCodes.isKnownCode('ENTITLEMENT_SOMETHING_NEW'),
        isFalse,
      );
      expect(EntitlementErrorCodes.isEntitlementCode('FORBIDDEN'), isFalse);
      expect(
        EntitlementErrorCodes.isKnownCode(EntitlementErrorCodes.itemLimit),
        isTrue,
      );
    });
  });

  group('EntitlementPaywallCopy', () {
    test('maps catalog limits to Basic upgrade CTAs', () {
      final copy = EntitlementPaywallCopy.forPlacement(
        PaywallPlacement.wardrobeLimit,
      );
      expect(copy.upgradeCta, EntitlementPaywallCopy.upgradeBasicCta);
      expect(copy.targetTier, SubscriptionTier.basic);
      expect(copy.formMessage, contains('Upgrade to Basic'));
      expect(
        copy.toSuperwallParams(
          basicMonthly: 'basic_m',
          basicYearly: 'basic_y',
          premiumMonthly: 'prem_m',
          premiumYearly: 'prem_y',
        ),
        containsPair('upgrade_cta', EntitlementPaywallCopy.upgradeBasicCta),
      );
    });

    test('maps AI denials to Premium upgrade CTAs', () {
      final copy = EntitlementPaywallCopy.forPlacement(
        PaywallPlacement.aiTryOn,
      );
      expect(copy.upgradeCta, EntitlementPaywallCopy.upgradePremiumCta);
      expect(copy.headline, contains('Premium'));
      expect(
        copy.toSuperwallParams(
          basicMonthly: 'a',
          basicYearly: 'b',
          premiumMonthly: 'c',
          premiumYearly: 'd',
        ),
        containsPair('see_plans_cta', EntitlementPaywallCopy.seePlansCta),
      );
    });

    test('soft-fails unknown entitlement codes to generic upgrade copy', () {
      final copy = EntitlementPaywallCopy.fromApiException(
        const ApiException(
          message: 'secret internals',
          code: 'ENTITLEMENT_UNRELEASED',
          statusCode: 403,
        ),
      );
      expect(copy, isNotNull);
      expect(copy!.placement, PaywallPlacement.upgradeBasic);
      expect(copy.upgradeCta, EntitlementPaywallCopy.upgradeBasicCta);
      expect(
        EntitlementPaywallCopy.userMessage(
          const ApiException(
            message: 'secret internals',
            code: 'ENTITLEMENT_UNRELEASED',
            statusCode: 403,
          ),
        ),
        isNot(contains('secret internals')),
      );
    });

    test('non-entitlement errors keep the API message', () {
      const error = ApiException(
        message: 'Unable to reach the server. Check your connection.',
        code: 'NETWORK_ERROR',
      );
      expect(EntitlementPaywallCopy.fromApiException(error), isNull);
      expect(EntitlementPaywallCopy.userMessage(error), error.message);
    });
  });
}
