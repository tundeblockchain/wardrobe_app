import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at_patch.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item_subcategory_patch.dart';

/// In-memory [ItemRepository] for unit tests.
class FakeItemRepository implements ItemRepository {
  FakeItemRepository({List<Item>? seed}) : items = [...?seed];

  final List<Item> items;
  ApiException? nextFailure;
  int listCalls = 0;
  int getCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;
  String? lastImageKey;
  String? lastSubcategoryArg;
  ItemSubcategoryPatch lastSubcategoryPatch = const ItemSubcategoryPatch.omit();
  DateTime? lastAcquiredAtArg;
  ItemAcquiredAtPatch lastAcquiredAtPatch = const ItemAcquiredAtPatch.omit();
  ItemListFilters lastListFilters = const ItemListFilters();

  /// When false (default), acquired query params are recorded but not applied
  /// so tests cover the client-side [ItemListFilters.applyLoadedFallback]
  /// window. Set true to mimic Backend WARDROBE-92 list filtering.
  bool applyAcquiredQueryParams = false;

  @override
  Future<List<Item>> listItems(
    String wardrobeId, {
    ItemListFilters filters = const ItemListFilters(),
  }) async {
    listCalls++;
    lastListFilters = filters;
    _maybeFail();
    return [
      for (final item in items)
        if (item.wardrobeId == wardrobeId && _matchesFilters(item, filters))
          item,
    ];
  }

  @override
  Future<Item> getItem({
    required String wardrobeId,
    required String itemId,
  }) async {
    getCalls++;
    _maybeFail();
    return items.firstWhere(
      (item) => item.wardrobeId == wardrobeId && item.id == itemId,
      orElse: () => throw const ApiException(
        message: 'Item not found.',
        code: 'ITEM_NOT_FOUND',
        statusCode: 404,
      ),
    );
  }

  @override
  Future<Item> createItem({
    required String wardrobeId,
    required String name,
    required ItemCategory category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    required String imageKey,
    DateTime? acquiredAt,
  }) async {
    createCalls++;
    lastImageKey = imageKey;
    lastSubcategoryArg = subcategory;
    lastAcquiredAtArg = ItemAcquiredAt.dateOnlyOrNull(acquiredAt);
    _maybeFail();
    final now = DateTime.utc(2026, 9, 4, 12);
    final item = Item(
      id: 'item_${items.length + 1}',
      wardrobeId: wardrobeId,
      name: name,
      category: category,
      subcategory: subcategory,
      colours: [...?colours],
      brand: brand,
      originalImageKey: imageKey,
      processingStatus: ItemProcessingStatus.pending,
      acquiredAt: lastAcquiredAtArg,
      createdAt: now,
      updatedAt: now,
    );
    items.add(item);
    return item;
  }

  @override
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
  }) async {
    updateCalls++;
    lastSubcategoryPatch = subcategory;
    lastAcquiredAtPatch = acquiredAt;
    lastSubcategoryArg = switch (subcategory.op) {
      ItemSubcategoryPatchOp.omit => null,
      ItemSubcategoryPatchOp.clear => null,
      ItemSubcategoryPatchOp.set => subcategory.value,
    };
    lastAcquiredAtArg = switch (acquiredAt.op) {
      ItemAcquiredAtPatchOp.omit => null,
      ItemAcquiredAtPatchOp.clear => null,
      ItemAcquiredAtPatchOp.set => acquiredAt.value,
    };
    if (imageKey != null) {
      lastImageKey = imageKey;
    }
    _maybeFail();
    final index = items.indexWhere(
      (item) => item.wardrobeId == wardrobeId && item.id == itemId,
    );
    if (index < 0) {
      throw const ApiException(
        message: 'Item not found.',
        code: 'ITEM_NOT_FOUND',
        statusCode: 404,
      );
    }
    final current = items[index];
    final nextSubcategory = switch (subcategory.op) {
      ItemSubcategoryPatchOp.omit => current.subcategory,
      ItemSubcategoryPatchOp.clear => null,
      ItemSubcategoryPatchOp.set => subcategory.value,
    };
    final nextAcquiredAt = switch (acquiredAt.op) {
      ItemAcquiredAtPatchOp.omit => current.acquiredAt,
      ItemAcquiredAtPatchOp.clear => null,
      ItemAcquiredAtPatchOp.set => acquiredAt.value,
    };
    final updated = current.copyWith(
      name: name ?? current.name,
      category: category ?? current.category,
      subcategory: nextSubcategory,
      colours: colours ?? current.colours,
      brand: brand ?? current.brand,
      originalImageKey: imageKey ?? current.originalImageKey,
      acquiredAt: nextAcquiredAt,
      updatedAt: DateTime.utc(2026, 9, 4, 13),
    );
    items[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteItem({
    required String wardrobeId,
    required String itemId,
  }) async {
    deleteCalls++;
    _maybeFail();
    items.removeWhere(
      (item) => item.wardrobeId == wardrobeId && item.id == itemId,
    );
  }

  bool _matchesFilters(Item item, ItemListFilters filters) {
    if (filters.category != null && item.category != filters.category) {
      return false;
    }
    if (filters.subcategory != null &&
        item.subcategory != filters.subcategory!.wireValue) {
      return false;
    }
    if (filters.colour != null &&
        !item.colours.contains(filters.colour!.wireValue)) {
      return false;
    }
    if (applyAcquiredQueryParams && !filters.matchesAcquired(item)) {
      return false;
    }
    return true;
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

Item testItem({
  String id = 'item_xyz123',
  String wardrobeId = 'wd_abc123',
  String name = 'Black Nike T-Shirt',
  ItemCategory category = ItemCategory.top,
  String? subcategory = 'TSHIRT',
  List<String> colours = const ['BLACK'],
  String? brand = 'Nike',
  String? originalImageKey = 'users/uid/uploads/uuid.jpg',
  String? processedImageKey,
  ItemProcessingStatus processingStatus = ItemProcessingStatus.ready,
  String? processingError,
  String? originalImageUrl,
  String? processedImageUrl,
  ItemAiMetadata? ai,
  DateTime? acquiredAt,
}) {
  return Item(
    id: id,
    wardrobeId: wardrobeId,
    name: name,
    category: category,
    subcategory: subcategory,
    colours: colours,
    brand: brand,
    originalImageKey: originalImageUrl ?? originalImageKey,
    processedImageKey: processedImageUrl ?? processedImageKey,
    processingStatus: processingStatus,
    processingError: processingError,
    ai: ai,
    acquiredAt: acquiredAt,
    createdAt: DateTime.utc(2026, 9, 3, 18, 45),
    updatedAt: DateTime.utc(2026, 9, 3, 18, 45),
  );
}
