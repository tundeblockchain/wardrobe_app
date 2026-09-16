import '../domain/shopping_link.dart';
import '../domain/shopping_links_contract.dart';
import '../domain/shopping_links_repository.dart';

/// Empty source kept for tests. Production uses DioShoppingLinksRepository.
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
