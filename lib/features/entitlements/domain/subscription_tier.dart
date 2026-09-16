import 'entitlement_wire.dart';

/// Subscription tiers owned by Backend WARDROBE-91. Wire values are the
/// uppercase string enum `FREE` | `BASIC` | `PREMIUM`.
enum SubscriptionTier {
  free(EntitlementWire.free, 'Free'),
  basic(EntitlementWire.basic, 'Basic'),
  premium(EntitlementWire.premium, 'Premium');

  const SubscriptionTier(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static SubscriptionTier parse(String? value) {
    if (value == null || value.isEmpty) {
      return SubscriptionTier.free;
    }
    final normalized = value.trim().toUpperCase();
    for (final tier in SubscriptionTier.values) {
      if (tier.wireValue == normalized) {
        return tier;
      }
    }
    return SubscriptionTier.free;
  }

  bool get isPaid => this != SubscriptionTier.free;

  bool get includesAi => this == SubscriptionTier.premium;
}
