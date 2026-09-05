import 'item.dart';
import 'item_taxonomy.dart';

/// Server-side list filters for `GET /wardrobes/{wardrobeId}/items`.
///
/// Empty fields are omitted from the query string. Filters AND across
/// params; matching user OR `ai.*` fields is handled by the backend.
class ItemListFilters {
  const ItemListFilters({this.category, this.colour, this.subcategory});

  final ItemCategory? category;
  final ItemColour? colour;
  final ItemSubcategory? subcategory;

  bool get isEmpty => category == null && colour == null && subcategory == null;

  /// Wire query parameters accepted by WARDROBE-21.
  Map<String, String> toQueryParameters() {
    return {
      if (category != null) 'category': category!.wireValue,
      if (colour != null) 'colour': colour!.wireValue,
      if (subcategory != null) 'subcategory': subcategory!.wireValue,
    };
  }

  ItemListFilters copyWith({
    ItemCategory? category,
    ItemColour? colour,
    ItemSubcategory? subcategory,
    bool clearCategory = false,
    bool clearColour = false,
    bool clearSubcategory = false,
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
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemListFilters &&
            category == other.category &&
            colour == other.colour &&
            subcategory == other.subcategory;
  }

  @override
  int get hashCode => Object.hash(category, colour, subcategory);

  @override
  String toString() =>
      'ItemListFilters(category: $category, colour: $colour, subcategory: $subcategory)';
}
