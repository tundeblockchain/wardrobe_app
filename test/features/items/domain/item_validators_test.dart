import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_validators.dart';

void main() {
  test('name requires a non-empty trimmed value', () {
    expect(ItemValidators.name(null), isNotNull);
    expect(ItemValidators.name('   '), isNotNull);
    expect(ItemValidators.name('Tee'), isNull);
  });

  test('category is required', () {
    expect(ItemValidators.category(null), isNotNull);
    expect(ItemValidators.category(ItemCategory.top), isNull);
  });

  test('subcategory is optional', () {
    expect(ItemValidators.subcategory(null), isNull);
    expect(ItemValidators.subcategory(''), isNull);
    expect(ItemValidators.subcategory('TSHIRT'), isNull);
  });

  test('parseColours splits and trims comma-separated values', () {
    expect(ItemValidators.parseColours(' black, white , '), ['black', 'white']);
    expect(ItemValidators.parseColours(''), isEmpty);
  });
}
