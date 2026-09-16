/// Locked Backend 403 `code`s (wardrobe-backend#46). Map to Superwall.
abstract final class EntitlementErrorCodes {
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

  static bool isEntitlementCode(String? code) {
    if (code == null || code.isEmpty) {
      return false;
    }
    return all.contains(code.trim().toUpperCase());
  }

  static bool isAiRequired(String? code) {
    return code != null && code.trim().toUpperCase() == aiRequired;
  }
}
