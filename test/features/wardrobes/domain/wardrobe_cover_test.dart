import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/wardrobes/domain/wardrobe_cover.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  group('WardrobeCover.fromItems', () {
    test('uses the first listed item as the cover', () {
      final first = testItem();
      final second = testItem(id: 'item_jeans', name: 'Blue jeans');

      final cover = WardrobeCover.fromItems([first, second]);

      expect(cover.firstItem?.id, first.id);
      expect(cover.itemCount, 2);
      expect(cover.isEmpty, isFalse);
      expect(cover.itemCountLabel, '2 items');
    });

    test('is empty when the wardrobe has no items', () {
      final cover = WardrobeCover.fromItems(const []);

      expect(cover.firstItem, isNull);
      expect(cover.itemCount, 0);
      expect(cover.isEmpty, isTrue);
      expect(cover.itemCountLabel, 'No items yet');
    });

    test('labels a single item without a plural', () {
      final cover = WardrobeCover.fromItems([testItem()]);

      expect(cover.itemCountLabel, '1 item');
    });
  });
}
