/// Provisional Backend entitlement error codes (WARDROBE-91 owns the final
/// list). Flutter maps 402/403 + these codes onto Superwall placements.
abstract final class EntitlementErrorCodes {
  static const wardrobeLimit = 'ENTITLEMENT_WARDROBE_LIMIT';
  static const itemLimit = 'ENTITLEMENT_ITEM_LIMIT';
  static const outfitLimit = 'ENTITLEMENT_OUTFIT_LIMIT';
  static const aiTryOn = 'ENTITLEMENT_AI_TRY_ON';
  static const otherAi = 'ENTITLEMENT_OTHER_AI';
  static const paymentRequired = 'PAYMENT_REQUIRED';
  static const forbidden = 'FORBIDDEN';

  static const all = <String>{
    wardrobeLimit,
    itemLimit,
    outfitLimit,
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
}
