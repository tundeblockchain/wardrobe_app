import 'subscription_catalog.dart';
import 'subscription_tier.dart';

/// Count caps from Backend. `null` means unlimited.
class EntitlementLimits {
  const EntitlementLimits({this.maxWardrobes, this.maxItems, this.maxOutfits});

  final int? maxWardrobes;
  final int? maxItems;
  final int? maxOutfits;

  bool allowsMore(int? max, int currentCount) {
    if (max == null) {
      return true;
    }
    return currentCount < max;
  }

  bool get hasWardrobeCap => maxWardrobes != null;
  bool get hasItemCap => maxItems != null;
  bool get hasOutfitCap => maxOutfits != null;

  factory EntitlementLimits.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EntitlementLimits();
    }
    return EntitlementLimits(
      maxWardrobes: _asNullableInt(json['maxWardrobes']),
      maxItems: _asNullableInt(json['maxItems']),
      maxOutfits: _asNullableInt(json['maxOutfits']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxWardrobes': maxWardrobes,
      'maxItems': maxItems,
      'maxOutfits': maxOutfits,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementLimits &&
            maxWardrobes == other.maxWardrobes &&
            maxItems == other.maxItems &&
            maxOutfits == other.maxOutfits;
  }

  @override
  int get hashCode => Object.hash(maxWardrobes, maxItems, maxOutfits);
}

/// Feature flags from Backend. `aiTryOn` is virtual try-on; `otherAi` covers
/// classify / recommendations / similar AI routes.
class EntitlementFlags {
  const EntitlementFlags({required this.aiTryOn, required this.otherAi});

  final bool aiTryOn;
  final bool otherAi;

  factory EntitlementFlags.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EntitlementFlags(aiTryOn: false, otherAi: false);
    }
    return EntitlementFlags(
      aiTryOn: json['aiTryOn'] == true,
      otherAi: json['otherAi'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'aiTryOn': aiTryOn, 'otherAi': otherAi};
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementFlags &&
            aiTryOn == other.aiTryOn &&
            otherAi == other.otherAi;
  }

  @override
  int get hashCode => Object.hash(aiTryOn, otherAi);
}

/// Soft-gate snapshot. Backend WARDROBE-91 owns the wire contract; this shape
/// is the Flutter mirror (`GET /me/entitlements`).
class Entitlement {
  const Entitlement({
    required this.tier,
    required this.limits,
    required this.flags,
  });

  final SubscriptionTier tier;
  final EntitlementLimits limits;
  final EntitlementFlags flags;

  /// Catalog defaults for a tier when Backend omits limits/flags.
  factory Entitlement.forTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return const Entitlement(
          tier: SubscriptionTier.free,
          limits: EntitlementLimits(
            maxWardrobes: SubscriptionCatalog.freeMaxWardrobes,
            maxItems: SubscriptionCatalog.freeMaxItems,
            maxOutfits: SubscriptionCatalog.freeMaxOutfits,
          ),
          flags: EntitlementFlags(aiTryOn: false, otherAi: false),
        );
      case SubscriptionTier.basic:
        return const Entitlement(
          tier: SubscriptionTier.basic,
          limits: EntitlementLimits(),
          flags: EntitlementFlags(aiTryOn: false, otherAi: false),
        );
      case SubscriptionTier.premium:
        return const Entitlement(
          tier: SubscriptionTier.premium,
          limits: EntitlementLimits(),
          flags: EntitlementFlags(aiTryOn: true, otherAi: true),
        );
    }
  }

  static final free = Entitlement.forTier(SubscriptionTier.free);
  static final basic = Entitlement.forTier(SubscriptionTier.basic);
  static final premium = Entitlement.forTier(SubscriptionTier.premium);

  factory Entitlement.fromJson(Map<String, dynamic> json) {
    final nested = json['entitlement'];
    final map = nested is Map ? Map<String, dynamic>.from(nested) : json;
    final tier = SubscriptionTier.parse(map['tier'] as String?);
    final catalog = Entitlement.forTier(tier);
    final limitsJson = map['limits'];
    final flagsJson = map['flags'];
    return Entitlement(
      tier: tier,
      limits: limitsJson is Map
          ? EntitlementLimits.fromJson(Map<String, dynamic>.from(limitsJson))
          : catalog.limits,
      flags: flagsJson is Map
          ? EntitlementFlags.fromJson(Map<String, dynamic>.from(flagsJson))
          : catalog.flags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.wireValue,
      'limits': limits.toJson(),
      'flags': flags.toJson(),
    };
  }

  bool canCreateWardrobe(int currentCount) =>
      limits.allowsMore(limits.maxWardrobes, currentCount);

  bool canCreateItem(int currentCount) =>
      limits.allowsMore(limits.maxItems, currentCount);

  bool canCreateOutfit(int currentCount) =>
      limits.allowsMore(limits.maxOutfits, currentCount);

  bool get canUseAiTryOn => flags.aiTryOn;

  bool get canUseOtherAi => flags.otherAi;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Entitlement &&
            tier == other.tier &&
            limits == other.limits &&
            flags == other.flags;
  }

  @override
  int get hashCode => Object.hash(tier, limits, flags);
}

int? _asNullableInt(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
