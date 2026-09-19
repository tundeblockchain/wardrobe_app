/// Locked WARDROBE-126 HTTP contract (wardrobe-backend#54 SHA `3b24174`).
///
/// Create / revoke are authenticated (Firebase Bearer, owner, all tiers — not
/// entitlement-gated). Flutter never calls the public GET preview.
///
/// [sharePath] is relative only (`/share/{token}`). The absolute URL is
/// `{SHARE_LANDING_BASE_URL}{sharePath}` on the client.
abstract final class ShareContract {
  /// Production uses Dio against the locked contract. Tests override the
  /// repository. Create/revoke treat an undeployed route as a snackbar, not a
  /// fake token.
  static const liveEnabled = true;

  /// Dart-define for the public landing origin. Not a secret.
  static const landingBaseUrlDefine = 'SHARE_LANDING_BASE_URL';

  static const backendPull = 54;
  static const backendSha = '3b24174';

  static String itemPath({
    required String wardrobeId,
    required String itemId,
  }) => '/wardrobes/$wardrobeId/items/$itemId/share';

  static String outfitPath({
    required String wardrobeId,
    required String outfitId,
  }) => '/wardrobes/$wardrobeId/outfits/$outfitId/share';

  static String revokePath(String token) => '/shares/$token';
}
