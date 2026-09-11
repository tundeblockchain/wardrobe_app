import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_subcategory_patch.dart';

void main() {
  test('normalize treats blank as empty/none', () {
    expect(ItemSubcategoryPatch.normalize(null), isNull);
    expect(ItemSubcategoryPatch.normalize(''), isNull);
    expect(ItemSubcategoryPatch.normalize('   '), isNull);
    expect(ItemSubcategoryPatch.normalize('TSHIRT'), 'TSHIRT');
    expect(ItemSubcategoryPatch.normalize('  JEANS '), 'JEANS');
  });

  test('fromEdit omits when the value is unchanged', () {
    expect(
      ItemSubcategoryPatch.fromEdit(original: 'TSHIRT', edited: 'TSHIRT'),
      const ItemSubcategoryPatch.omit(),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: ' TSHIRT ', edited: 'TSHIRT'),
      const ItemSubcategoryPatch.omit(),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: null, edited: null),
      const ItemSubcategoryPatch.omit(),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: '', edited: '  '),
      const ItemSubcategoryPatch.omit(),
    );
  });

  test('fromEdit clears when the user selects empty/none', () {
    expect(
      ItemSubcategoryPatch.fromEdit(original: 'TSHIRT', edited: null),
      const ItemSubcategoryPatch.clear(),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: 'TSHIRT', edited: ''),
      const ItemSubcategoryPatch.clear(),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: 'TSHIRT', edited: '  '),
      const ItemSubcategoryPatch.clear(),
    );
  });

  test('fromEdit sets a trimmed non-empty value', () {
    expect(
      ItemSubcategoryPatch.fromEdit(original: 'TSHIRT', edited: ' SHIRT '),
      const ItemSubcategoryPatch.set('SHIRT'),
    );
    expect(
      ItemSubcategoryPatch.fromEdit(original: null, edited: 'CUSTOM_CUT'),
      const ItemSubcategoryPatch.set('CUSTOM_CUT'),
    );
  });

  test('toJson omits, clears with JSON null, or sets a trimmed token', () {
    expect(const ItemSubcategoryPatch.omit().toJson(), isEmpty);
    expect(
      const ItemSubcategoryPatch.omit().toJson().containsKey('subcategory'),
      isFalse,
    );
    expect(const ItemSubcategoryPatch.clear().toJson(), {'subcategory': null});
    expect(const ItemSubcategoryPatch.set('TSHIRT').toJson(), {
      'subcategory': 'TSHIRT',
    });
  });

  test('clear never invents a dummy token', () {
    expect(const ItemSubcategoryPatch.clear().toJson()['subcategory'], isNull);
    expect(
      const ItemSubcategoryPatch.clear().toJson()['subcategory'],
      isNot(anyOf('NONE', 'UNSET', '')),
    );
  });
}
