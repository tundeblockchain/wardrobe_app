import '../../../core/network/api_exception.dart';
import 'entitlement_error_codes.dart';
import 'subscription_tier.dart';

/// Superwall placement IDs. Dashboard campaigns should match these hooks.
enum PaywallPlacement {
  wardrobeLimit(
    'wardrobe_limit',
    SubscriptionTier.basic,
    EntitlementErrorCodes.wardrobeLimit,
  ),
  itemLimit(
    'item_limit',
    SubscriptionTier.basic,
    EntitlementErrorCodes.itemLimit,
  ),
  outfitLimit(
    'outfit_limit',
    SubscriptionTier.basic,
    EntitlementErrorCodes.outfitLimit,
  ),
  aiTryOn(
    'ai_try_on',
    SubscriptionTier.premium,
    EntitlementErrorCodes.aiRequired,
  ),
  otherAi(
    'other_ai',
    SubscriptionTier.premium,
    EntitlementErrorCodes.aiRequired,
  ),
  upgradeBasic(
    'upgrade_basic',
    SubscriptionTier.basic,
    EntitlementErrorCodes.wardrobeLimit,
  ),
  upgradePremium(
    'upgrade_premium',
    SubscriptionTier.premium,
    EntitlementErrorCodes.aiRequired,
  );

  const PaywallPlacement(this.id, this.targetTier, this.errorCode);

  final String id;
  final SubscriptionTier targetTier;
  final String errorCode;

  bool get isPremiumTarget => targetTier == SubscriptionTier.premium;

  /// Maps Backend 403 `{ code, message }` onto Superwall.
  ///
  /// Catalog limits → Basic. `ENTITLEMENT_AI_REQUIRED` → Premium (try-on /
  /// recommendations / item-processing via [fallback] when it is Premium).
  static PaywallPlacement? fromApiException(
    ApiException error, {
    PaywallPlacement? fallback,
  }) {
    final code = error.code?.trim().toUpperCase();
    if (code == EntitlementErrorCodes.wardrobeLimit) {
      return PaywallPlacement.wardrobeLimit;
    }
    if (code == EntitlementErrorCodes.itemLimit) {
      return PaywallPlacement.itemLimit;
    }
    if (code == EntitlementErrorCodes.outfitLimit) {
      return PaywallPlacement.outfitLimit;
    }
    if (code == EntitlementErrorCodes.aiRequired) {
      if (fallback != null && fallback.isPremiumTarget) {
        return fallback;
      }
      return PaywallPlacement.otherAi;
    }
    if (EntitlementErrorCodes.isEntitlementStatus(error.statusCode)) {
      return fallback;
    }
    return null;
  }

  String get headline {
    switch (this) {
      case PaywallPlacement.wardrobeLimit:
        return 'Unlock more wardrobes';
      case PaywallPlacement.itemLimit:
        return 'Unlock more items';
      case PaywallPlacement.outfitLimit:
        return 'Unlock more outfits';
      case PaywallPlacement.aiTryOn:
        return 'Unlock AI try-on';
      case PaywallPlacement.otherAi:
        return 'Unlock AI styling';
      case PaywallPlacement.upgradeBasic:
        return 'Upgrade to Basic';
      case PaywallPlacement.upgradePremium:
        return 'Upgrade to Premium';
    }
  }

  String get message {
    switch (this) {
      case PaywallPlacement.wardrobeLimit:
        return 'Free includes 1 wardrobe. Basic unlocks unlimited wardrobes, '
            'items, and outfits.';
      case PaywallPlacement.itemLimit:
        return 'Free includes 5 items. Basic unlocks unlimited items, '
            'wardrobes, and outfits.';
      case PaywallPlacement.outfitLimit:
        return 'Free includes 5 outfits. Basic unlocks unlimited outfits, '
            'items, and wardrobes.';
      case PaywallPlacement.aiTryOn:
        return 'Virtual try-on is included with Premium.';
      case PaywallPlacement.otherAi:
        return 'Outfit suggestions and other AI tools are included with '
            'Premium.';
      case PaywallPlacement.upgradeBasic:
        return 'Basic unlocks unlimited wardrobes, items, and outfits.';
      case PaywallPlacement.upgradePremium:
        return 'Premium adds AI try-on plus suggestions and other AI tools.';
    }
  }
}
