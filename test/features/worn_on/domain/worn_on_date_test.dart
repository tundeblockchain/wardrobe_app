import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_date.dart';

void main() {
  group('WornOnDate.tryParse', () {
    test('maps ISO date YYYY-MM-DD to a UTC calendar date', () {
      expect(WornOnDate.tryParse('2026-09-18'), DateTime.utc(2026, 9, 18));
    });

    test('keeps the calendar day when a datetime sneaks onto a read', () {
      expect(
        WornOnDate.tryParse('2026-09-18T19:10:00.000Z'),
        DateTime.utc(2026, 9, 18),
      );
    });

    test('strict parse rejects datetimes and impossible days', () {
      expect(WornOnDate.tryParseStrict('2026-09-18T19:10:00Z'), isNull);
      expect(WornOnDate.tryParseStrict('2026-02-30'), isNull);
      expect(WornOnDate.tryParse('2026-02-30'), isNull);
      expect(WornOnDate.tryParse(''), isNull);
    });
  });

  group('WornOnDate.toWire', () {
    test('writes YYYY-MM-DD and omits null', () {
      expect(WornOnDate.toWire(DateTime.utc(2026, 9, 18)), '2026-09-18');
      expect(WornOnDate.toWire(DateTime(2026, 9, 18, 21)), '2026-09-18');
      expect(WornOnDate.toWire(null), isNull);
    });
  });

  test('todayLocal uses the local calendar day', () {
    expect(
      WornOnDate.todayLocal(DateTime(2026, 9, 19, 15, 30)),
      DateTime.utc(2026, 9, 19),
    );
  });

  test('monthRange is inclusive first-to-last day', () {
    final range = WornOnDate.monthRange(DateTime.utc(2026, 9, 19));
    expect(range.from, DateTime.utc(2026, 9, 1));
    expect(range.to, DateTime.utc(2026, 9, 30));
  });

  test('formatDisplay is a short calendar label', () {
    expect(WornOnDate.formatDisplay(DateTime.utc(2026, 9, 18)), '18 Sep 2026');
    expect(WornOnDate.formatMonth(DateTime.utc(2026, 9, 1)), 'September 2026');
  });
}
