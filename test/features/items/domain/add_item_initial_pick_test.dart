import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/add_item_initial_pick.dart';

void main() {
  test('parses gallery and camera query values', () {
    expect(AddItemInitialPick.tryParse('gallery'), AddItemInitialPick.gallery);
    expect(AddItemInitialPick.tryParse('camera'), AddItemInitialPick.camera);
    expect(AddItemInitialPick.tryParse('other'), isNull);
    expect(AddItemInitialPick.tryParse(null), isNull);
  });
}
