import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';

import '../../../helpers/fake_item_repository.dart';

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

    test('builds acquiredAfter and acquiredBefore as ISO dates', () {
      expect(
        ItemListFilters(
          acquiredAfter: DateTime.utc(2024, 1, 1),
          acquiredBefore: DateTime.utc(2025, 12, 31),
        ).toQueryParameters(),
        {'acquiredAfter': '2024-01-01', 'acquiredBefore': '2025-12-31'},
      );
    });

    test('omits empty acquired window', () {
      expect(
        const ItemListFilters(category: ItemCategory.top)
            .toQueryParameters()
            .containsKey('acquiredAfter'),
        isFalse,
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

    test('clears acquiredAfter independently of category chips', () {
      final filters = ItemListFilters(
        category: ItemCategory.top,
        acquiredAfter: DateTime.utc(2024, 1, 1),
      );

      expect(filters.copyWith(clearAcquiredAfter: true).acquiredAfter, isNull);
      expect(
        filters.copyWith(clearAcquiredAfter: true).category,
        ItemCategory.top,
      );
    });
  });

  group('ItemListFilters.applyLoadedFallback', () {
    test('hides items acquired before acquiredAfter', () {
      final older = testItem(id: 'old', acquiredAt: DateTime.utc(2020, 1, 1));
      final newer = testItem(id: 'new', acquiredAt: DateTime.utc(2025, 6, 1));
      final unknown = testItem(id: 'unknown', acquiredAt: null);
      final filters = ItemListFilters(acquiredAfter: DateTime.utc(2024, 1, 1));

      expect(filters.applyLoadedFallback([older, newer, unknown]), [newer]);
    });

    test('excludes items with no acquiredAt when a bound is set', () {
      final unknown = testItem(id: 'unknown', acquiredAt: null);
      final dated = testItem(id: 'dated', acquiredAt: DateTime.utc(2024, 6, 1));
      final filters = ItemListFilters(
        acquiredBefore: DateTime.utc(2025, 12, 31),
      );

      expect(filters.applyLoadedFallback([unknown, dated]), [dated]);
    });

    test('hides items acquired after acquiredBefore', () {
      final older = testItem(id: 'old', acquiredAt: DateTime.utc(2020, 1, 1));
      final newer = testItem(id: 'new', acquiredAt: DateTime.utc(2025, 6, 1));
      final filters = ItemListFilters(
        acquiredBefore: DateTime.utc(2024, 12, 31),
      );

      expect(filters.applyLoadedFallback([older, newer]), [older]);
    });

    test('empty acquired window returns the loaded list unchanged', () {
      final items = [testItem(), testItem(id: 'item_2')];
      expect(const ItemListFilters().applyLoadedFallback(items), items);
    });

    test('inclusive bounds keep items acquired on the bound dates', () {
      final onBound = testItem(
        id: 'on-bound',
        acquiredAt: DateTime.utc(2024, 1, 1),
      );
      final filters = ItemListFilters(
        acquiredAfter: DateTime.utc(2024, 1, 1),
        acquiredBefore: DateTime.utc(2024, 1, 1),
      );

      expect(filters.applyLoadedFallback([onBound]), [onBound]);
    });
  });
}
