import 'item.dart';
import 'item_acquired_at.dart';
import 'item_taxonomy.dart';

/// Server-side list filters for `GET /wardrobes/{wardrobeId}/items`.
///
/// Empty fields are omitted from the query string. Filters AND across
/// params; matching user OR `ai.*` fields is handled by the backend.
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

  /// Wire query parameters accepted by WARDROBE-21 and WARDROBE-92.
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

  /// Inclusive acquired-date window. Items without [Item.acquiredAt] stay
  /// visible — unknown is not treated as older.
  bool matchesAcquired(Item item) {
    if (!hasAcquiredWindow) {
      return true;
    }
    final acquired = ItemAcquiredAt.dateOnlyOrNull(item.acquiredAt);
    if (acquired == null) {
      return true;
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

  /// Client-side acquired-date window over an already-loaded list.
  ///
  /// Prefer Backend `acquiredAfter` / `acquiredBefore` query params
  /// ([toQueryParameters]). This fallback still applies when WARDROBE-92 is
  /// not live yet (unknown params ignored). When Backend filters, the same
  /// window is idempotent.
  List<Item> applyLoadedFallback(List<Item> items) {
    if (!hasAcquiredWindow) {
      return items;
    }
    return [
      for (final item in items)
        if (matchesAcquired(item)) item,
    ];
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
