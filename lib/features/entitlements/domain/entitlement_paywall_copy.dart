import '../../../core/network/api_exception.dart';
import 'paywall_placement.dart';
import 'subscription_catalog.dart';
import 'subscription_tier.dart';

/// User-facing Free→Basic/Premium copy for 403 `ENTITLEMENT_*` errors.
///
/// Superwall still owns purchase UI when configured. This mapper keeps the
/// themed fallback sheet and form errors aligned with the same CTAs.
class EntitlementPaywallCopy {
  const EntitlementPaywallCopy({
    required this.placement,
    required this.headline,
    required this.message,
    required this.upgradeCta,
    required this.formMessage,
  });

  final PaywallPlacement placement;
  final String headline;
  final String message;
  final String upgradeCta;
  final String formMessage;

  static const seePlansCta = 'See plans';
  static const hidePlansCta = 'Hide plans';
  static const restoreCta = 'Restore purchases';
  static const dismissCta = 'Not now';
  static const restoreTitle = restoreCta;
  static const restoreSubtitle =
      'Already subscribed? Restore after reinstall or a new sign-in.';
  static const restoreHint = restoreSubtitle;
  static const restoreSuccess = 'Purchases restored.';
  static const restoreFailed = 'Could not restore purchases.';
  static const restoreUnavailable = 'Restore is unavailable in this build.';
  static const upgradeBasicCta = 'Upgrade to Basic';
  static const upgradePremiumCta = 'Upgrade to Premium';

  SubscriptionTier get targetTier => placement.targetTier;

  factory EntitlementPaywallCopy.forPlacement(PaywallPlacement placement) {
    return EntitlementPaywallCopy(
      placement: placement,
      headline: placement.headline,
      message: placement.message,
      upgradeCta: placement.isPremiumTarget
          ? upgradePremiumCta
          : upgradeBasicCta,
      formMessage: placement.message,
    );
  }

  /// Soft-fails unknown `ENTITLEMENT_*` codes to a generic upgrade CTA.
  static EntitlementPaywallCopy? fromApiException(
    ApiException error, {
    PaywallPlacement? fallback,
  }) {
    final placement = PaywallPlacement.fromApiException(
      error,
      fallback: fallback,
    );
    if (placement == null) {
      return null;
    }
    return EntitlementPaywallCopy.forPlacement(placement);
  }

  /// Form / snackbar text. Known entitlement denials use paywall copy;
  /// anything else keeps the API message.
  static String userMessage(ApiException error, {PaywallPlacement? fallback}) {
    return fromApiException(error, fallback: fallback)?.formMessage ??
        error.message;
  }

  /// Placement params for Superwall campaigns (no secrets).
  Map<String, Object> toSuperwallParams({
    required String basicMonthly,
    required String basicYearly,
    required String premiumMonthly,
    required String premiumYearly,
  }) {
    return {
      'target_tier': targetTier.wireValue,
      'reason': placement.id,
      'error_code': placement.errorCode,
      'headline': headline,
      'message': message,
      'upgrade_cta': upgradeCta,
      'see_plans_cta': seePlansCta,
      'restore_cta': restoreCta,
      'product_basic_monthly': basicMonthly,
      'product_basic_yearly': basicYearly,
      'product_premium_monthly': premiumMonthly,
      'product_premium_yearly': premiumYearly,
    };
  }

  static String planSummary(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return '1 wardrobe, ${SubscriptionCatalog.freeMaxItems} items, '
            '${SubscriptionCatalog.freeMaxOutfits} outfits';
      case SubscriptionTier.basic:
        return 'Unlimited wardrobes, items, and outfits';
      case SubscriptionTier.premium:
        return 'Unlimited catalog plus AI try-on and styling';
    }
  }
}
