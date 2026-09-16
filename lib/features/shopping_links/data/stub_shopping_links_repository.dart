import '../domain/shopping_link.dart';
import '../domain/shopping_links_contract.dart';
import '../domain/shopping_links_repository.dart';

/// Empty source used until WARDROBE-96 `86c5d6a` lands on Backend main.
class StubShoppingLinksRepository implements ShoppingLinksRepository {
  const StubShoppingLinksRepository();

  @override
  Future<HomeShoppingLinks> listHomeShoppingLinks({
    int limit = ShoppingLinksContract.defaultLimit,
    int linksPerItem = ShoppingLinksContract.defaultLinksPerItem,
  }) async => const HomeShoppingLinks();

  @override
  Future<ShoppingLinksItemResult> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) async => ShoppingLinksItemResult(itemId: itemId, wardrobeId: wardrobeId);
}
