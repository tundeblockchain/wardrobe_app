/// Backend WARDROBE-91 JSON keys and paths. Flutter mirrors this contract.
///
/// Field names live here so a Backend rename is a one-file change. Aliases
/// cover the proposed MVP (`aiEnabled` / `tryOn`, nested `entitlement`) until
/// README names settle.
abstract final class EntitlementWire {
  /// Primary read (WARDROBE-91 README).
  static const mePath = '/me';

  /// Alternate dedicated read if `GET /me` is 404.
  static const entitlementPath = '/me/entitlement';

  static const readPaths = <String>[mePath, entitlementPath];

  static const userId = 'userId';
  static const tier = 'tier';
  static const status = 'status';
  static const entitlement = 'entitlement';
  static const features = 'features';
  static const flags = 'flags';
  static const limits = 'limits';
  static const usage = 'usage';

  static const unlimitedCatalog = 'unlimitedCatalog';
  static const aiTryOn = 'aiTryOn';
  static const otherAi = 'otherAi';
  static const aiEnabled = 'aiEnabled';
  static const tryOn = 'tryOn';

  static const wardrobes = 'wardrobes';
  static const items = 'items';
  static const outfits = 'outfits';
  static const maxWardrobes = 'maxWardrobes';
  static const maxItems = 'maxItems';
  static const maxOutfits = 'maxOutfits';

  static const free = 'FREE';
  static const basic = 'BASIC';
  static const premium = 'PREMIUM';
}
