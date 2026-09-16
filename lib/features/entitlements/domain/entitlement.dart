import 'entitlement_wire.dart';
import 'subscription_catalog.dart';
import 'subscription_tier.dart';

/// Count caps from Backend. `null` means unlimited (`limits: null` on paid).
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

  bool get isUnlimited => !hasWardrobeCap && !hasItemCap && !hasOutfitCap;

  factory EntitlementLimits.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EntitlementLimits();
    }
    return EntitlementLimits(
      maxWardrobes: _asNullableInt(
        json[EntitlementWire.wardrobes] ?? json[EntitlementWire.maxWardrobes],
      ),
      maxItems: _asNullableInt(
        json[EntitlementWire.items] ?? json[EntitlementWire.maxItems],
      ),
      maxOutfits: _asNullableInt(
        json[EntitlementWire.outfits] ?? json[EntitlementWire.maxOutfits],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EntitlementWire.wardrobes: maxWardrobes,
      EntitlementWire.items: maxItems,
      EntitlementWire.outfits: maxOutfits,
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

/// Feature flags from Backend `features` (aliases: `flags`, `aiEnabled`, `tryOn`).
class EntitlementFlags {
  const EntitlementFlags({required this.aiTryOn, required this.otherAi});

  final bool aiTryOn;
  final bool otherAi;

  factory EntitlementFlags.fromJson(
    Map<String, dynamic>? json, {
    EntitlementFlags fallback = const EntitlementFlags(
      aiTryOn: false,
      otherAi: false,
    ),
  }) {
    if (json == null) {
      return fallback;
    }
    final aiEnabled = _asBool(json[EntitlementWire.aiEnabled]);
    return EntitlementFlags(
      aiTryOn:
          _asBool(json[EntitlementWire.aiTryOn]) ??
          _asBool(json[EntitlementWire.tryOn]) ??
          aiEnabled ??
          fallback.aiTryOn,
      otherAi:
          _asBool(json[EntitlementWire.otherAi]) ??
          aiEnabled ??
          fallback.otherAi,
    );
  }

  Map<String, dynamic> toJson({required bool unlimitedCatalog}) {
    return {
      EntitlementWire.unlimitedCatalog: unlimitedCatalog,
      EntitlementWire.aiTryOn: aiTryOn,
      EntitlementWire.otherAi: otherAi,
    };
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

/// Soft-gate snapshot. Backend WARDROBE-91 owns the wire contract; this is the
/// Flutter mirror of `GET /me` (`GET /me/entitlement` as fallback).
class Entitlement {
  const Entitlement({
    required this.tier,
    required this.limits,
    required this.flags,
  });

  final SubscriptionTier tier;
  final EntitlementLimits limits;
  final EntitlementFlags flags;

  /// Catalog defaults for a tier when Backend omits limits/features.
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
    final nested = json[EntitlementWire.entitlement];
    final map = nested is Map ? Map<String, dynamic>.from(nested) : json;
    final tier = SubscriptionTier.parse(map[EntitlementWire.tier] as String?);
    final catalog = Entitlement.forTier(tier);
    final featuresJson = _asMap(
      map[EntitlementWire.features] ?? map[EntitlementWire.flags],
    );
    final limitsRaw = map[EntitlementWire.limits];
    final unlimitedCatalog =
        _asBool(featuresJson?[EntitlementWire.unlimitedCatalog]) ?? tier.isPaid;

    final EntitlementLimits limits;
    if (limitsRaw == null) {
      limits = unlimitedCatalog ? const EntitlementLimits() : catalog.limits;
    } else if (limitsRaw is Map) {
      limits = EntitlementLimits.fromJson(Map<String, dynamic>.from(limitsRaw));
    } else {
      limits = catalog.limits;
    }

    return Entitlement(
      tier: tier,
      limits: limits,
      flags: EntitlementFlags.fromJson(featuresJson, fallback: catalog.flags),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EntitlementWire.tier: tier.wireValue,
      EntitlementWire.features: flags.toJson(
        unlimitedCatalog: limits.isUnlimited,
      ),
      EntitlementWire.limits: limits.isUnlimited ? null : limits.toJson(),
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

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

bool? _asBool(Object? value) {
  if (value is bool) {
    return value;
  }
  return null;
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
