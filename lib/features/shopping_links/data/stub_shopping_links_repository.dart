import '../domain/shopping_link.dart';
import '../domain/shopping_links_repository.dart';

/// Empty source used until WARDROBE-96 lands a confirmed contract.
class StubShoppingLinksRepository implements ShoppingLinksRepository {
  const StubShoppingLinksRepository();

  @override
  Future<List<ShoppingLink>> listHomeShoppingLinks() async => const [];

  @override
  Future<List<ShoppingLink>> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) async => const [];
}
