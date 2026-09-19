import '../../../core/network/api_exception.dart';
import 'entitlement_error_codes.dart';
import 'subscription_catalog.dart';
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
  /// Unknown `ENTITLEMENT_*` codes soft-fail to [fallback] or [upgradeBasic].
  static PaywallPlacement? fromApiException(
    ApiException error, {
    PaywallPlacement? fallback,
  }) {
    final code = EntitlementErrorCodes.normalize(error.code);
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
    if (EntitlementErrorCodes.isEntitlementCode(code)) {
      return fallback ?? PaywallPlacement.upgradeBasic;
    }
    if (EntitlementErrorCodes.isEntitlementStatus(error.statusCode)) {
      return fallback;
    }
    return null;
  }

  String get headline {
    switch (this) {
      case PaywallPlacement.wardrobeLimit:
        return "You've reached the Free wardrobe limit";
      case PaywallPlacement.itemLimit:
        return "You've reached the Free item limit";
      case PaywallPlacement.outfitLimit:
        return "You've reached the Free outfit limit";
      case PaywallPlacement.aiTryOn:
        return 'AI try-on is a Premium feature';
      case PaywallPlacement.otherAi:
        return 'AI styling is a Premium feature';
      case PaywallPlacement.upgradeBasic:
        return 'Upgrade to Basic';
      case PaywallPlacement.upgradePremium:
        return 'Upgrade to Premium';
    }
  }

  String get message {
    final basicPrice = SubscriptionCatalog.priceSummary(SubscriptionTier.basic);
    final premiumPrice = SubscriptionCatalog.priceSummary(
      SubscriptionTier.premium,
    );
    switch (this) {
      case PaywallPlacement.wardrobeLimit:
        return 'Free includes ${SubscriptionCatalog.freeMaxWardrobes} '
            'wardrobe. Upgrade to Basic ($basicPrice) for unlimited '
            'wardrobes, items, and outfits.';
      case PaywallPlacement.itemLimit:
        return 'Free includes ${SubscriptionCatalog.freeMaxItems} items. '
            'Upgrade to Basic ($basicPrice) for unlimited items, wardrobes, '
            'and outfits.';
      case PaywallPlacement.outfitLimit:
        return 'Free includes ${SubscriptionCatalog.freeMaxOutfits} outfits. '
            'Upgrade to Basic ($basicPrice) for unlimited outfits, items, '
            'and wardrobes.';
      case PaywallPlacement.aiTryOn:
        return 'Virtual try-on is included with Premium ($premiumPrice). '
            'Upgrade to try outfits on your photos.';
      case PaywallPlacement.otherAi:
        return 'Outfit suggestions and other AI tools are included with '
            'Premium ($premiumPrice).';
      case PaywallPlacement.upgradeBasic:
        return 'Basic unlocks unlimited wardrobes, items, and outfits for '
            '$basicPrice.';
      case PaywallPlacement.upgradePremium:
        return 'Premium adds AI try-on plus suggestions and other AI tools '
            'for $premiumPrice.';
    }
  }
}
