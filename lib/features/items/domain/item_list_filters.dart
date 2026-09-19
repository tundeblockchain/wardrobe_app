import 'item.dart';
import 'item_acquired_at.dart';
import 'item_taxonomy.dart';

/// Client-first list filters over an already-loaded wardrobe item deck
/// (WARDROBE-116).
///
/// Filters AND across params. Category, colour, and subcategory/tag match
/// user fields or `ai.*` metadata already on the item DTO. Acquired-date
/// bounds stay inclusive and exclude items with no `acquiredAt`.
///
/// [toQueryParameters] is the extension point for a future Backend GSI
/// (`GET /wardrobes/{wardrobeId}/items?category=&colour=&subcategory=`).
/// Do not add a dedicated search API for this story — escalate only if
/// the loaded list is insufficient.
class ItemListFilters {
  const ItemListFilters({
    this.category,
    this.colour,
    this.subcategory,
    this.acquiredAfter,
    this.acquiredBefore,
  });

  final ItemCategory? category;
  final ItemColour? colour;

  /// Subcategory chip; treated as the item tag on the wardrobe list.
  final ItemSubcategory? subcategory;

  /// Inclusive lower bound (`acquiredAfter=YYYY-MM-DD`). Hides older clothes.
  final DateTime? acquiredAfter;

  /// Inclusive upper bound (`acquiredBefore=YYYY-MM-DD`).
  final DateTime? acquiredBefore;

  bool get isEmpty =>
      category == null &&
      colour == null &&
      subcategory == null &&
      acquiredAfter == null &&
      acquiredBefore == null;

  bool get hasAcquiredWindow => acquiredAfter != null || acquiredBefore != null;

  /// Wire query parameters for a future Backend GSI list (WARDROBE-21 /
  /// WARDROBE-92). The wardrobe items controller does not send these on
  /// list/refresh — [apply] filters the loaded deck instead.
  ///
  /// TODO(WARDROBE-116): if client filter over the loaded list is
  /// insufficient (very large wardrobes), pass this map to
  /// `GET /wardrobes/{wardrobeId}/items`. Do not invent a search API.
  Map<String, String> toQueryParameters() {
    return {
      if (category != null) 'category': category!.wireValue,
      if (colour != null) 'colour': colour!.wireValue,
      if (subcategory != null) 'subcategory': subcategory!.wireValue,
      if (acquiredAfter != null)
        'acquiredAfter': ItemAcquiredAt.toWire(acquiredAfter)!,
      if (acquiredBefore != null)
        'acquiredBefore': ItemAcquiredAt.toWire(acquiredBefore)!,
    };
  }

  /// Inclusive acquired-date window (WARDROBE-92).
  ///
  /// Items without [Item.acquiredAt] are excluded when either bound is set —
  /// they cannot be proven to fall in range.
  bool matchesAcquired(Item item) {
    if (!hasAcquiredWindow) {
      return true;
    }
    final acquired = ItemAcquiredAt.dateOnlyOrNull(item.acquiredAt);
    if (acquired == null) {
      return false;
    }
    final after = ItemAcquiredAt.dateOnlyOrNull(acquiredAfter);
    if (after != null && acquired.isBefore(after)) {
      return false;
    }
    final before = ItemAcquiredAt.dateOnlyOrNull(acquiredBefore);
    if (before != null && acquired.isAfter(before)) {
      return false;
    }
    return true;
  }

  /// Whether [item] satisfies every selected filter (AND).
  bool matches(Item item) {
    if (category != null && !_matchesCategory(item, category!)) {
      return false;
    }
    if (colour != null && !_matchesColour(item, colour!)) {
      return false;
    }
    if (subcategory != null && !_matchesSubcategory(item, subcategory!)) {
      return false;
    }
    return matchesAcquired(item);
  }

  /// Client-side filter over an already-loaded list (WARDROBE-116).
  List<Item> apply(List<Item> items) {
    if (isEmpty) {
      return items;
    }
    return [
      for (final item in items)
        if (matches(item)) item,
    ];
  }

  /// Alias for [apply] — keeps existing call sites and tests compiling.
  List<Item> applyLoadedFallback(List<Item> items) => apply(items);

  static bool _matchesCategory(Item item, ItemCategory category) {
    if (item.category == category) {
      return true;
    }
    return item.ai?.detectedCategory == category;
  }

  static bool _matchesColour(Item item, ItemColour colour) {
    if (_colourListContains(item.colours, colour)) {
      return true;
    }
    return _colourListContains(item.ai?.detectedColours ?? const [], colour);
  }

  static bool _matchesSubcategory(Item item, ItemSubcategory subcategory) {
    if (_subcategoryEquals(item.subcategory, subcategory)) {
      return true;
    }
    return _subcategoryEquals(item.ai?.detectedSubcategory, subcategory);
  }

  static bool _colourListContains(Iterable<String> colours, ItemColour colour) {
    for (final value in colours) {
      if (ItemColour.tryParse(value) == colour) {
        return true;
      }
    }
    return false;
  }

  static bool _subcategoryEquals(String? raw, ItemSubcategory subcategory) {
    return ItemSubcategory.tryParse(raw) == subcategory;
  }

  ItemListFilters copyWith({
    ItemCategory? category,
    ItemColour? colour,
    ItemSubcategory? subcategory,
    DateTime? acquiredAfter,
    DateTime? acquiredBefore,
    bool clearCategory = false,
    bool clearColour = false,
    bool clearSubcategory = false,
    bool clearAcquiredAfter = false,
    bool clearAcquiredBefore = false,
  }) {
    final nextCategory = clearCategory ? null : (category ?? this.category);
    var nextSubcategory = clearSubcategory
        ? null
        : (subcategory ?? this.subcategory);
    if (nextCategory == null ||
        (nextSubcategory != null &&
            !ItemSubcategory.forCategory(nextCategory)
                .contains(nextSubcategory))) {
      nextSubcategory = null;
    }
    return ItemListFilters(
      category: nextCategory,
      colour: clearColour ? null : (colour ?? this.colour),
      subcategory: nextSubcategory,
      acquiredAfter: clearAcquiredAfter
          ? null
          : ItemAcquiredAt.dateOnlyOrNull(acquiredAfter ?? this.acquiredAfter),
      acquiredBefore: clearAcquiredBefore
          ? null
          : ItemAcquiredAt.dateOnlyOrNull(
              acquiredBefore ?? this.acquiredBefore,
            ),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemListFilters &&
            category == other.category &&
            colour == other.colour &&
            subcategory == other.subcategory &&
            acquiredAfter == other.acquiredAfter &&
            acquiredBefore == other.acquiredBefore;
  }

  @override
  int get hashCode =>
      Object.hash(category, colour, subcategory, acquiredAfter, acquiredBefore);

  @override
  String toString() =>
      'ItemListFilters(category: $category, colour: $colour, '
      'subcategory: $subcategory, acquiredAfter: ${ItemAcquiredAt.toWire(acquiredAfter)}, '
      'acquiredBefore: ${ItemAcquiredAt.toWire(acquiredBefore)})';
}
