import 'item.dart';
import 'item_list_filters.dart';
import 'item_subcategory_patch.dart';

/// Clothing-item CRUD nested under a wardrobe.
abstract interface class ItemRepository {
  Future<List<Item>> listItems(
    String wardrobeId, {
    ItemListFilters filters = const ItemListFilters(),
  });

  Future<Item> getItem({required String wardrobeId, required String itemId});

  Future<Item> createItem({
    required String wardrobeId,
    required String name,
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    required String imageKey,
  });

  Future<Item> updateItem({
    required String wardrobeId,
    required String itemId,
    String? name,
    ItemCategory? category,
    ItemSubcategoryPatch subcategory = const ItemSubcategoryPatch.omit(),
    List<String>? colours,
    String? brand,
    String? imageKey,
  });

  Future<void> deleteItem({required String wardrobeId, required String itemId});
}
