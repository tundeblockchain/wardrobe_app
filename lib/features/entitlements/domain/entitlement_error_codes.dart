/// Backend entitlement error codes (WARDROBE-91 README). Flutter maps 403 +
/// these `code`s onto Superwall placements.
abstract final class EntitlementErrorCodes {
  static const wardrobeLimit = 'ENTITLEMENT_WARDROBE_LIMIT';
  static const itemLimit = 'ENTITLEMENT_ITEM_LIMIT';
  static const outfitLimit = 'ENTITLEMENT_OUTFIT_LIMIT';

  /// Stable AI denial from Backend (try-on, recommendations, classify).
  static const aiRequired = 'ENTITLEMENT_AI_REQUIRED';

  /// Aliases if Backend splits try-on vs other AI later.
  static const aiTryOn = 'ENTITLEMENT_AI_TRY_ON';
  static const otherAi = 'ENTITLEMENT_OTHER_AI';
  static const paymentRequired = 'PAYMENT_REQUIRED';
  static const forbidden = 'FORBIDDEN';

  static const all = <String>{
    wardrobeLimit,
    itemLimit,
    outfitLimit,
    aiRequired,
    aiTryOn,
    otherAi,
    paymentRequired,
    forbidden,
  };

  static bool isEntitlementStatus(int? statusCode) {
    return statusCode == 402 || statusCode == 403;
  }

  static bool isEntitlementCode(String? code) {
    if (code == null || code.isEmpty) {
      return false;
    }
    return all.contains(code.trim().toUpperCase());
  }

  static bool isAiRequired(String? code) {
    if (code == null || code.isEmpty) {
      return false;
    }
    final normalized = code.trim().toUpperCase();
    return normalized == aiRequired ||
        normalized == aiTryOn ||
        normalized == otherAi;
  }
}
