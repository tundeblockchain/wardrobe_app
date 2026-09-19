/// Locked WARDROBE-120 HTTP contract (wardrobe-backend#52 SHA `7d24d0e`).
///
/// Not entitlement-gated. Body / query / path `userId` is ignored. Outfit
/// GET / list stay unchanged (no `wornOn` field on the outfit).
abstract final class WornOnContract {
  /// Production uses Dio against the locked contract. Tests override the
  /// repository. GET list/calendar treats an undeployed route as empty.
  static const liveEnabled = true;

  static const fromQuery = 'from';
  static const toQuery = 'to';

  static String outfitPath({
    required String wardrobeId,
    required String outfitId,
  }) => '/wardrobes/$wardrobeId/outfits/$outfitId/worn-on';

  static String outfitDatePath({
    required String wardrobeId,
    required String outfitId,
    required String date,
  }) => '${outfitPath(wardrobeId: wardrobeId, outfitId: outfitId)}/$date';

  static String wardrobePath(String wardrobeId) =>
      '/wardrobes/$wardrobeId/worn-on';

  /// Inclusive `from` / `to`. Soft-omits unset bounds; never sends JSON null.
  static Map<String, dynamic> calendarQuery({String? from, String? to}) {
    return {
      if (from != null && from.isNotEmpty) fromQuery: from,
      if (to != null && to.isNotEmpty) toQuery: to,
    };
  }
}
