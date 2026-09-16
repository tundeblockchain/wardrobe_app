/// Locked WARDROBE-96 HTTP contract (wardrobe-backend#47 `86c5d6a`).
///
/// Flip [liveEnabled] when that SHA (or a later merge) lands on Backend main.
abstract final class ShoppingLinksContract {
  /// `false` until Backend posts the live SHA. Stub stays empty until then.
  static const liveEnabled = false;

  static const homePath = '/shopping-links';

  static String itemPath({
    required String wardrobeId,
    required String itemId,
  }) => '/wardrobes/$wardrobeId/items/$itemId/shopping-links';

  static const defaultLimit = 5;
  static const maxLimit = 10;
  static const defaultLinksPerItem = 8;
  static const maxLinksPerItem = 12;

  static const limitQuery = 'limit';
  static const linksPerItemQuery = 'linksPerItem';

  static int clampLimit(int value) => value.clamp(1, maxLimit);

  static int clampLinksPerItem(int value) => value.clamp(1, maxLinksPerItem);

  static Map<String, dynamic> homeQueryParameters({
    int limit = defaultLimit,
    int linksPerItem = defaultLinksPerItem,
  }) {
    return {
      limitQuery: '${clampLimit(limit)}',
      linksPerItemQuery: '${clampLinksPerItem(linksPerItem)}',
    };
  }
}
