import '../../../core/network/api_exception.dart';
import 'entitlement_error_codes.dart';
import 'subscription_tier.dart';

/// Superwall placement IDs. Dashboard campaigns should match these hooks;
/// product IDs stay operator-owned.
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
  aiTryOn('ai_try_on', SubscriptionTier.premium, EntitlementErrorCodes.aiTryOn),
  otherAi('other_ai', SubscriptionTier.premium, EntitlementErrorCodes.otherAi),
  upgradeBasic(
    'upgrade_basic',
    SubscriptionTier.basic,
    EntitlementErrorCodes.paymentRequired,
  ),
  upgradePremium(
    'upgrade_premium',
    SubscriptionTier.premium,
    EntitlementErrorCodes.paymentRequired,
  );

  const PaywallPlacement(this.id, this.targetTier, this.errorCode);

  /// Superwall dashboard placement name.
  final String id;

  /// Tier the paywall should sell toward.
  final SubscriptionTier targetTier;

  /// Provisional Backend error code this placement maps from.
  final String errorCode;

  static PaywallPlacement? fromErrorCode(String? code) {
    if (code == null || code.isEmpty) {
      return null;
    }
    final normalized = code.trim().toUpperCase();
    for (final placement in PaywallPlacement.values) {
      if (placement.errorCode == normalized) {
        return placement;
      }
    }
    return null;
  }

  /// Maps Backend 402/403 entitlement failures to a Superwall placement.
  static PaywallPlacement? fromApiException(
    ApiException error, {
    PaywallPlacement? fallback,
  }) {
    final fromCode = fromErrorCode(error.code);
    if (fromCode != null) {
      return fromCode;
    }
    if (!EntitlementErrorCodes.isEntitlementStatus(error.statusCode)) {
      return null;
    }
    return fallback;
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
