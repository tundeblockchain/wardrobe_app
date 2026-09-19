import 'item.dart';
import 'item_acquired_at_patch.dart';
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
    DateTime? acquiredAt,
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
    ItemAcquiredAtPatch acquiredAt = const ItemAcquiredAtPatch.omit(),
  });

  Future<void> deleteItem({required String wardrobeId, required String itemId});

  /// Relocates the same `itemId` to [targetWardrobeId]. Backend `200`.
  Future<Item> moveItem({
    required String wardrobeId,
    required String itemId,
    required String targetWardrobeId,
  });

  /// Creates a new `itemId` in [targetWardrobeId] (shared S3 keys). Backend `201`.
  Future<Item> copyItem({
    required String wardrobeId,
    required String itemId,
    required String targetWardrobeId,
  });

  /// `POST /wardrobes/{wardrobeId}/items/{itemId}/reprocess` (WARDROBE-123).
  ///
  /// Success is `202` with `processingStatus: PENDING`. Body is optional.
  Future<Item> reprocessItem({
    required String wardrobeId,
    required String itemId,
  });
}
