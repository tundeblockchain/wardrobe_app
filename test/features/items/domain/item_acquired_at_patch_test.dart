import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at_patch.dart';

void main() {
  final stored = DateTime.utc(2024, 3, 9);

  test('fromEdit omits when the calendar date is unchanged', () {
    expect(
      ItemAcquiredAtPatch.fromEdit(original: stored, edited: stored),
      const ItemAcquiredAtPatch.omit(),
    );
    expect(
      ItemAcquiredAtPatch.fromEdit(
        original: stored,
        edited: DateTime(2024, 3, 9, 18),
      ),
      const ItemAcquiredAtPatch.omit(),
    );
    expect(
      ItemAcquiredAtPatch.fromEdit(original: null, edited: null),
      const ItemAcquiredAtPatch.omit(),
    );
  });

  test('fromEdit clears when the user removes the date', () {
    expect(
      ItemAcquiredAtPatch.fromEdit(original: stored, edited: null),
      const ItemAcquiredAtPatch.clear(),
    );
  });

  test('fromEdit sets a calendar date', () {
    expect(
      ItemAcquiredAtPatch.fromEdit(
        original: null,
        edited: DateTime(2025, 1, 2),
      ),
      ItemAcquiredAtPatch.set(DateTime.utc(2025, 1, 2)),
    );
  });

  test('toJson omits, clears with JSON null, or sets YYYY-MM-DD', () {
    expect(const ItemAcquiredAtPatch.omit().toJson(), isEmpty);
    expect(
      const ItemAcquiredAtPatch.omit().toJson().containsKey('acquiredAt'),
      isFalse,
    );
    expect(const ItemAcquiredAtPatch.clear().toJson(), {'acquiredAt': null});
    expect(ItemAcquiredAtPatch.set(stored).toJson(), {
      'acquiredAt': '2024-03-09',
    });
  });
}
