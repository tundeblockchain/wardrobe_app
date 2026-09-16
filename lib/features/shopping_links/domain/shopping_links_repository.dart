import 'shopping_link.dart';
import 'shopping_links_contract.dart';

/// Related shopping links. Locked WARDROBE-96 paths; stub until Backend SHA.
abstract interface class ShoppingLinksRepository {
  /// Mixed recent items: `GET /shopping-links?limit=&linksPerItem=`.
  Future<HomeShoppingLinks> listHomeShoppingLinks({
    int limit = ShoppingLinksContract.defaultLimit,
    int linksPerItem = ShoppingLinksContract.defaultLinksPerItem,
  });

  /// `GET /wardrobes/{wardrobeId}/items/{itemId}/shopping-links`.
  Future<ShoppingLinksItemResult> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  });
}
