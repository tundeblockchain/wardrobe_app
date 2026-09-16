import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at.dart';

void main() {
  group('ItemAcquiredAt.tryParse', () {
    test('maps ISO date YYYY-MM-DD to a UTC calendar date', () {
      expect(ItemAcquiredAt.tryParse('2024-03-09'), DateTime.utc(2024, 3, 9));
    });

    test('keeps the wire calendar date when Backend returns a datetime', () {
      expect(
        ItemAcquiredAt.tryParse('2024-03-09T18:45:00Z'),
        DateTime.utc(2024, 3, 9),
      );
      expect(
        ItemAcquiredAt.tryParse('2024-03-09T00:00:00+01:00'),
        DateTime.utc(2024, 3, 9),
      );
    });

    test('treats missing, blank, and invalid values as unset', () {
      expect(ItemAcquiredAt.tryParse(null), isNull);
      expect(ItemAcquiredAt.tryParse(''), isNull);
      expect(ItemAcquiredAt.tryParse('   '), isNull);
      expect(ItemAcquiredAt.tryParse('not-a-date'), isNull);
      expect(ItemAcquiredAt.tryParse('2024-13-40'), isNull);
      expect(ItemAcquiredAt.tryParse(20240309), isNull);
    });

    test('normalizes a DateTime to date-only UTC', () {
      expect(
        ItemAcquiredAt.tryParse(DateTime(2024, 3, 9, 18, 30)),
        DateTime.utc(2024, 3, 9),
      );
    });
  });

  group('ItemAcquiredAt.toWire', () {
    test('writes YYYY-MM-DD and omits null', () {
      expect(ItemAcquiredAt.toWire(DateTime.utc(2024, 3, 9)), '2024-03-09');
      expect(ItemAcquiredAt.toWire(DateTime(2024, 3, 9, 12)), '2024-03-09');
      expect(ItemAcquiredAt.toWire(null), isNull);
    });
  });

  test('formatDisplay is a short calendar label', () {
    expect(
      ItemAcquiredAt.formatDisplay(DateTime.utc(2024, 3, 9)),
      '9 Mar 2024',
    );
  });
}
