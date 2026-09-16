import 'shopping_link.dart';

/// Related shopping links. Paths are provisional until WARDROBE-96 confirms.
abstract interface class ShoppingLinksRepository {
  /// Mixed recommendations from recent items across the user's wardrobes.
  Future<List<ShoppingLink>> listHomeShoppingLinks();

  /// Shopping links for one clothing item.
  Future<List<ShoppingLink>> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  });
}
