import 'subscription_tier.dart';

/// Confirmed product matrix (WARDROBE-90). Prices are display placeholders
/// until App Store / Play products exist.
abstract final class SubscriptionCatalog {
  static const freeMaxWardrobes = 1;
  static const freeMaxItems = 5;
  static const freeMaxOutfits = 5;

  static const basicMonthlyPrice = '£5/mo';
  static const basicYearlyPrice = '£50/yr';
  static const premiumMonthlyPrice = '£15/mo';
  static const premiumYearlyPrice = '£150/yr';

  static String priceSummary(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return '£0';
      case SubscriptionTier.basic:
        return '$basicMonthlyPrice or $basicYearlyPrice';
      case SubscriptionTier.premium:
        return '$premiumMonthlyPrice or $premiumYearlyPrice';
    }
  }
}
