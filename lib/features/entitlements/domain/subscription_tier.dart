import 'entitlement_wire.dart';

/// `FREE` | `BASIC` | `PREMIUM` — locked WARDROBE-91 string enum.
enum SubscriptionTier {
  free(EntitlementWire.free, 'Free'),
  basic(EntitlementWire.basic, 'Basic'),
  premium(EntitlementWire.premium, 'Premium');

  const SubscriptionTier(this.wireValue, this.label);

  final String wireValue;
  final String label;

  /// Unknown / missing → `FREE` (same as Backend `resolveEntitlement`).
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

/// `NONE` | `ACTIVE` | `CANCELED` | `BILLING_ISSUE` | `PAUSED` | `EXPIRED`.
enum EntitlementStatus {
  none(EntitlementWire.statusNone),
  active(EntitlementWire.statusActive),
  canceled(EntitlementWire.statusCanceled),
  billingIssue(EntitlementWire.statusBillingIssue),
  paused(EntitlementWire.statusPaused),
  expired(EntitlementWire.statusExpired);

  const EntitlementStatus(this.wireValue);

  final String wireValue;

  static EntitlementStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return EntitlementStatus.none;
    }
    final normalized = value.trim().toUpperCase();
    for (final status in EntitlementStatus.values) {
      if (status.wireValue == normalized) {
        return status;
      }
    }
    return EntitlementStatus.none;
  }
}

/// `APP_STORE` | `PLAY_STORE` | `STRIPE` | `UNKNOWN`.
enum EntitlementStore {
  appStore(EntitlementWire.storeAppStore),
  playStore(EntitlementWire.storePlayStore),
  stripe(EntitlementWire.storeStripe),
  unknown(EntitlementWire.storeUnknown);

  const EntitlementStore(this.wireValue);

  final String wireValue;

  static EntitlementStore? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.trim().toUpperCase();
    for (final store in EntitlementStore.values) {
      if (store.wireValue == normalized) {
        return store;
      }
    }
    return EntitlementStore.unknown;
  }
}

/// `MONTHLY` | `YEARLY` | `UNKNOWN`.
enum EntitlementPeriod {
  monthly(EntitlementWire.periodMonthly),
  yearly(EntitlementWire.periodYearly),
  unknown(EntitlementWire.periodUnknown);

  const EntitlementPeriod(this.wireValue);

  final String wireValue;

  static EntitlementPeriod? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.trim().toUpperCase();
    for (final period in EntitlementPeriod.values) {
      if (period.wireValue == normalized) {
        return period;
      }
    }
    return EntitlementPeriod.unknown;
  }
}
