/// Locked Backend 403 `code`s (wardrobe-backend#46). Map to Superwall.
///
/// Unknown `ENTITLEMENT_*` values soft-fail to a generic upgrade CTA
/// ([WARDROBE-117](https://tundetunde000.atlassian.net/browse/WARDROBE-117)).
abstract final class EntitlementErrorCodes {
  static const prefix = 'ENTITLEMENT_';
  static const wardrobeLimit = 'ENTITLEMENT_WARDROBE_LIMIT';
  static const itemLimit = 'ENTITLEMENT_ITEM_LIMIT';
  static const outfitLimit = 'ENTITLEMENT_OUTFIT_LIMIT';
  static const aiRequired = 'ENTITLEMENT_AI_REQUIRED';

  static const all = <String>{
    wardrobeLimit,
    itemLimit,
    outfitLimit,
    aiRequired,
  };

  static bool isEntitlementStatus(int? statusCode) => statusCode == 403;

  static String? normalize(String? code) {
    if (code == null || code.isEmpty) {
      return null;
    }
    return code.trim().toUpperCase();
  }

  static bool isEntitlementCode(String? code) {
    final normalized = normalize(code);
    if (normalized == null) {
      return false;
    }
    return all.contains(normalized) || normalized.startsWith(prefix);
  }

  static bool isKnownCode(String? code) {
    final normalized = normalize(code);
    return normalized != null && all.contains(normalized);
  }

  static bool isAiRequired(String? code) {
    return normalize(code) == aiRequired;
  }
}
