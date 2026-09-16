import 'entitlement_wire.dart';
import 'subscription_catalog.dart';
import 'subscription_tier.dart';

/// Catalog caps from `GET /me` `limits`. Null object on the parent = unlimited.
class EntitlementLimits {
  const EntitlementLimits({
    required this.wardrobes,
    required this.items,
    required this.outfits,
  });

  static const free = EntitlementLimits(
    wardrobes: SubscriptionCatalog.freeMaxWardrobes,
    items: SubscriptionCatalog.freeMaxItems,
    outfits: SubscriptionCatalog.freeMaxOutfits,
  );

  final int wardrobes;
  final int items;
  final int outfits;

  bool allowsMore(int max, int currentCount) => currentCount < max;

  factory EntitlementLimits.fromJson(Map<String, dynamic> json) {
    return EntitlementLimits(
      wardrobes: _asInt(json[EntitlementWire.wardrobes]) ?? 0,
      items: _asInt(json[EntitlementWire.items]) ?? 0,
      outfits: _asInt(json[EntitlementWire.outfits]) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EntitlementWire.wardrobes: wardrobes,
      EntitlementWire.items: items,
      EntitlementWire.outfits: outfits,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementLimits &&
            wardrobes == other.wardrobes &&
            items == other.items &&
            outfits == other.outfits;
  }

  @override
  int get hashCode => Object.hash(wardrobes, items, outfits);
}

/// `GET /me` `features`: `{ unlimitedCatalog, aiTryOn, otherAi }`.
class EntitlementFeatures {
  const EntitlementFeatures({
    required this.unlimitedCatalog,
    required this.aiTryOn,
    required this.otherAi,
  });

  static const free = EntitlementFeatures(
    unlimitedCatalog: false,
    aiTryOn: false,
    otherAi: false,
  );

  static const basic = EntitlementFeatures(
    unlimitedCatalog: true,
    aiTryOn: false,
    otherAi: false,
  );

  static const premium = EntitlementFeatures(
    unlimitedCatalog: true,
    aiTryOn: true,
    otherAi: true,
  );

  final bool unlimitedCatalog;
  final bool aiTryOn;
  final bool otherAi;

  factory EntitlementFeatures.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EntitlementFeatures.free;
    }
    return EntitlementFeatures(
      unlimitedCatalog: json[EntitlementWire.unlimitedCatalog] == true,
      aiTryOn: json[EntitlementWire.aiTryOn] == true,
      otherAi: json[EntitlementWire.otherAi] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EntitlementWire.unlimitedCatalog: unlimitedCatalog,
      EntitlementWire.aiTryOn: aiTryOn,
      EntitlementWire.otherAi: otherAi,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementFeatures &&
            unlimitedCatalog == other.unlimitedCatalog &&
            aiTryOn == other.aiTryOn &&
            otherAi == other.otherAi;
  }

  @override
  int get hashCode => Object.hash(unlimitedCatalog, aiTryOn, otherAi);
}

/// `GET /me` `usage`: current owned counts.
class EntitlementUsage {
  const EntitlementUsage({
    required this.wardrobes,
    required this.items,
    required this.outfits,
  });

  static const zero = EntitlementUsage(wardrobes: 0, items: 0, outfits: 0);

  final int wardrobes;
  final int items;
  final int outfits;

  factory EntitlementUsage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EntitlementUsage.zero;
    }
    return EntitlementUsage(
      wardrobes: _asInt(json[EntitlementWire.wardrobes]) ?? 0,
      items: _asInt(json[EntitlementWire.items]) ?? 0,
      outfits: _asInt(json[EntitlementWire.outfits]) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EntitlementWire.wardrobes: wardrobes,
      EntitlementWire.items: items,
      EntitlementWire.outfits: outfits,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementUsage &&
            wardrobes == other.wardrobes &&
            items == other.items &&
            outfits == other.outfits;
  }

  @override
  int get hashCode => Object.hash(wardrobes, items, outfits);
}

/// Flutter mirror of `GET /me` (wardrobe-backend#46 `a837463`). Dynamo via
/// Backend is the source of truth — no Firebase custom claims.
class Entitlement {
  const Entitlement({
    this.userId,
    required this.tier,
    required this.status,
    required this.features,
    this.limits,
    this.usage = EntitlementUsage.zero,
    this.productId,
    this.store,
    this.period,
    this.expiresAt,
    this.updatedAt,
  });

  final String? userId;
  final SubscriptionTier tier;
  final EntitlementStatus status;
  final EntitlementFeatures features;

  /// Free catalog caps. `null` = unlimited (Basic / Premium).
  final EntitlementLimits? limits;
  final EntitlementUsage usage;
  final String? productId;
  final EntitlementStore? store;
  final EntitlementPeriod? period;
  final DateTime? expiresAt;
  final DateTime? updatedAt;

  factory Entitlement.forTier(SubscriptionTier tier, {String? userId}) {
    switch (tier) {
      case SubscriptionTier.free:
        return Entitlement(
          userId: userId,
          tier: SubscriptionTier.free,
          status: EntitlementStatus.none,
          features: EntitlementFeatures.free,
          limits: EntitlementLimits.free,
        );
      case SubscriptionTier.basic:
        return Entitlement(
          userId: userId,
          tier: SubscriptionTier.basic,
          status: EntitlementStatus.active,
          features: EntitlementFeatures.basic,
        );
      case SubscriptionTier.premium:
        return Entitlement(
          userId: userId,
          tier: SubscriptionTier.premium,
          status: EntitlementStatus.active,
          features: EntitlementFeatures.premium,
        );
    }
  }

  static final free = Entitlement.forTier(SubscriptionTier.free);
  static final basic = Entitlement.forTier(SubscriptionTier.basic);
  static final premium = Entitlement.forTier(SubscriptionTier.premium);

  factory Entitlement.fromJson(Map<String, dynamic> json) {
    final tier = SubscriptionTier.parse(json[EntitlementWire.tier] as String?);
    final limitsRaw = json[EntitlementWire.limits];
    return Entitlement(
      userId: json[EntitlementWire.userId] as String?,
      tier: tier,
      status: EntitlementStatus.parse(json[EntitlementWire.status] as String?),
      features: EntitlementFeatures.fromJson(
        _asMap(json[EntitlementWire.features]),
      ),
      limits: limitsRaw is Map
          ? EntitlementLimits.fromJson(Map<String, dynamic>.from(limitsRaw))
          : (tier == SubscriptionTier.free ? EntitlementLimits.free : null),
      usage: EntitlementUsage.fromJson(_asMap(json[EntitlementWire.usage])),
      productId: json[EntitlementWire.productId] as String?,
      store: EntitlementStore.tryParse(json[EntitlementWire.store] as String?),
      period: EntitlementPeriod.tryParse(
        json[EntitlementWire.period] as String?,
      ),
      expiresAt: _asDate(json[EntitlementWire.expiresAt]),
      updatedAt: _asDate(json[EntitlementWire.updatedAt]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) EntitlementWire.userId: userId,
      EntitlementWire.tier: tier.wireValue,
      EntitlementWire.status: status.wireValue,
      EntitlementWire.features: features.toJson(),
      EntitlementWire.limits: limits?.toJson(),
      EntitlementWire.usage: usage.toJson(),
      if (productId != null) EntitlementWire.productId: productId,
      if (store != null) EntitlementWire.store: store!.wireValue,
      if (period != null) EntitlementWire.period: period!.wireValue,
      if (expiresAt != null)
        EntitlementWire.expiresAt: expiresAt!.toUtc().toIso8601String(),
      if (updatedAt != null)
        EntitlementWire.updatedAt: updatedAt!.toUtc().toIso8601String(),
    };
  }

  bool canCreateWardrobe(int currentCount) {
    final max = limits?.wardrobes;
    if (max == null) {
      return true;
    }
    return currentCount < max;
  }

  bool canCreateItem(int currentCount) {
    final max = limits?.items;
    if (max == null) {
      return true;
    }
    return currentCount < max;
  }

  bool canCreateOutfit(int currentCount) {
    final max = limits?.outfits;
    if (max == null) {
      return true;
    }
    return currentCount < max;
  }

  bool get canUseAiTryOn => features.aiTryOn;

  bool get canUseOtherAi => features.otherAi;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Entitlement &&
            userId == other.userId &&
            tier == other.tier &&
            status == other.status &&
            features == other.features &&
            limits == other.limits &&
            usage == other.usage &&
            productId == other.productId &&
            store == other.store &&
            period == other.period &&
            expiresAt == other.expiresAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    userId,
    tier,
    status,
    features,
    limits,
    usage,
    productId,
    store,
    period,
    expiresAt,
    updatedAt,
  );
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

int? _asInt(Object? value) {
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

DateTime? _asDate(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
