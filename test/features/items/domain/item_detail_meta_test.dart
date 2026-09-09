import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_detail_meta.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  test('uses user category, subcategory, colours, and brand', () {
    final item = testItem();

    expect(ItemDetailMeta.categoryLabel(item), 'Top');
    expect(ItemDetailMeta.subcategoryLabel(item), 'T-shirt');
    expect(ItemDetailMeta.colourLabels(item), ['Black']);
    expect(ItemDetailMeta.brandLabel(item), 'Nike');
  });

  test('empty subcategory, colours, and brand render the placeholder', () {
    final item = testItem(subcategory: null, colours: const [], brand: null);

    expect(ItemDetailMeta.categoryLabel(item), 'Top');
    expect(
      ItemDetailMeta.subcategoryLabel(item),
      ItemDetailMeta.emptyPlaceholder,
    );
    expect(ItemDetailMeta.colourWires(item), isEmpty);
    expect(ItemDetailMeta.colourLabels(item), isEmpty);
    expect(ItemDetailMeta.brandLabel(item), ItemDetailMeta.emptyPlaceholder);
    expect(
      ItemDetailMeta.isPlaceholder(ItemDetailMeta.brandLabel(item)),
      isTrue,
    );
  });

  test(
    'falls back to AI subcategory and colours when user fields are empty',
    () {
      final item = testItem(
        subcategory: '  ',
        colours: const [],
        brand: null,
        ai: const ItemAiMetadata(
          detectedCategory: ItemCategory.bottom,
          detectedSubcategory: 'JEANS',
          detectedColours: ['BLUE', 'NAVY'],
        ),
      );

      expect(ItemDetailMeta.categoryLabel(item), 'Top');
      expect(ItemDetailMeta.subcategoryLabel(item), 'Jeans');
      expect(ItemDetailMeta.colourLabels(item), ['Blue', 'Navy']);
      expect(ItemDetailMeta.brandLabel(item), ItemDetailMeta.emptyPlaceholder);
    },
  );

  test('user colours stay authoritative over AI detections', () {
    final item = testItem(
      colours: const ['BLACK'],
      ai: const ItemAiMetadata(detectedColours: ['WHITE', 'RED']),
    );

    expect(ItemDetailMeta.colourWires(item), ['BLACK']);
    expect(ItemDetailMeta.colourLabels(item), ['Black']);
  });

  test('humanizes unknown tokens and blank brand', () {
    expect(ItemDetailMeta.humanizeToken('NAVY_BLUE'), 'Navy Blue');
    expect(ItemDetailMeta.colourLabel('CUSTOM_TEAL'), 'Custom Teal');
    expect(ItemDetailMeta.brandLabel(testItem(brand: '   ')), 'Not set');
  });
}
