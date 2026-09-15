import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/search/domain/app_search.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  group('normalizeAppSearchQuery', () {
    test('trims and lowercases', () {
      expect(normalizeAppSearchQuery('  Shirt '), 'shirt');
    });

    test('empty and whitespace are soft-omit', () {
      expect(isAppSearchQueryEmpty(''), isTrue);
      expect(isAppSearchQueryEmpty('   '), isTrue);
      expect(isAppSearchQueryEmpty('coat'), isFalse);
    });
  });

  group('loadedListAppSearch', () {
    final catalog = AppSearchCatalog(
      wardrobes: [
        testWardrobe(),
        testWardrobe(id: 'wd_winter', name: 'Winter'),
      ],
      items: [
        testItem(),
        testItem(
          id: 'item_coat',
          wardrobeId: 'wd_winter',
          name: 'Wool coat',
          category: ItemCategory.outerwear,
          subcategory: 'COAT',
        ),
      ],
      outfits: [
        testOutfit(),
        testOutfit(id: 'outfit_office', name: 'Office Layer'),
      ],
    );

    test('empty query returns no hits', () {
      final results = loadedListAppSearch(query: '  ', catalog: catalog);
      expect(results.isEmpty, isTrue);
      expect(results.allHits, isEmpty);
    });

    test('matches item name case-insensitively', () {
      final results = loadedListAppSearch(query: 'nike', catalog: catalog);
      expect(results.items.single.id, 'item_xyz123');
      expect(
        results.items.single.location,
        AppRoutes.itemDetail('wd_abc123', 'item_xyz123'),
      );
    });

    test('matches item category and subcategory labels', () {
      expect(
        loadedListAppSearch(
          query: 'outerwear',
          catalog: catalog,
        ).items.single.id,
        'item_coat',
      );
      expect(
        loadedListAppSearch(query: 't-shirt', catalog: catalog).items.single.id,
        'item_xyz123',
      );
      expect(
        loadedListAppSearch(query: 'COAT', catalog: catalog).items.single.id,
        'item_coat',
      );
    });

    test('matches outfit name', () {
      final results = loadedListAppSearch(query: 'friday', catalog: catalog);
      expect(results.outfits.single.id, 'outfit_123');
      expect(
        results.outfits.single.location,
        AppRoutes.outfitDetail('wd_abc123', 'outfit_123'),
      );
    });

    test('matches wardrobe name', () {
      final results = loadedListAppSearch(query: 'summer', catalog: catalog);
      expect(results.wardrobes.single.id, 'wd_abc123');
      expect(
        results.wardrobes.single.location,
        AppRoutes.wardrobeDetail('wd_abc123'),
      );
    });

    test('omits kinds that do not match', () {
      final results = loadedListAppSearch(query: 'winter', catalog: catalog);
      expect(results.wardrobes.single.id, 'wd_winter');
      expect(results.items, isEmpty);
      expect(results.outfits, isEmpty);
    });
  });
}
