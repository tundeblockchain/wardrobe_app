/// Subscription tiers owned by Backend WARDROBE-91. Flutter mirrors the wire
/// values `free` | `basic` | `premium`.
enum SubscriptionTier {
  free('free', 'Free'),
  basic('basic', 'Basic'),
  premium('premium', 'Premium');

  const SubscriptionTier(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static SubscriptionTier parse(String? value) {
    if (value == null || value.isEmpty) {
      return SubscriptionTier.free;
    }
    final normalized = value.trim().toLowerCase();
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
