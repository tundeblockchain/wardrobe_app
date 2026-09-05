import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';

void main() {
  group('ItemListFilters.toQueryParameters', () {
    test('omits empty filters', () {
      expect(const ItemListFilters().toQueryParameters(), isEmpty);
    });

    test('builds category only', () {
      expect(
        const ItemListFilters(category: ItemCategory.top).toQueryParameters(),
        {'category': 'TOP'},
      );
    });

    test('builds category and colour', () {
      expect(
        const ItemListFilters(
          category: ItemCategory.top,
          colour: ItemColour.black,
        ).toQueryParameters(),
        {'category': 'TOP', 'colour': 'BLACK'},
      );
    });

    test('builds category, colour, and subcategory', () {
      expect(
        const ItemListFilters(
          category: ItemCategory.top,
          colour: ItemColour.black,
          subcategory: ItemSubcategory.tshirt,
        ).toQueryParameters(),
        {'category': 'TOP', 'colour': 'BLACK', 'subcategory': 'TSHIRT'},
      );
    });
  });

  group('ItemListFilters.copyWith', () {
    test('clears a subcategory that does not belong to the next category', () {
      const filters = ItemListFilters(
        category: ItemCategory.top,
        subcategory: ItemSubcategory.tshirt,
      );

      expect(
        filters.copyWith(category: ItemCategory.bottom).subcategory,
        isNull,
      );
    });

    test('keeps a subcategory that still belongs to the next category', () {
      const filters = ItemListFilters(
        category: ItemCategory.top,
        subcategory: ItemSubcategory.tshirt,
      );

      expect(
        filters.copyWith(category: ItemCategory.top).subcategory,
        ItemSubcategory.tshirt,
      );
    });
  });
}
