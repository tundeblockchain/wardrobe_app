import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_default_name.dart';
import 'package:wardrobe_app/features/items/domain/item_validators.dart';

import '../../../helpers/fake_item_image_picker.dart';

void main() {
  test('uses a cleaned file name without the extension', () {
    expect(
      defaultItemName(
        FakeItemImagePicker.sample(fileName: 'navy-jeans.png'),
        0,
      ),
      'navy jeans',
    );
  });

  test('falls back to New item N when the file name is empty', () {
    expect(
      defaultItemName(FakeItemImagePicker.sample(fileName: ''), 2),
      'New item 3',
    );
    expect(
      defaultItemName(FakeItemImagePicker.sample(fileName: '.jpg'), 0),
      'New item 1',
    );
  });

  test('truncates long file names to the item name limit', () {
    final long = '${'a' * (ItemValidators.maxNameLength + 8)}.jpg';
    expect(
      defaultItemName(FakeItemImagePicker.sample(fileName: long), 0).length,
      ItemValidators.maxNameLength,
    );
  });
}
