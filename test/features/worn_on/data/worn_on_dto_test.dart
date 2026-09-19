import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/worn_on/data/worn_on_dtos.dart';

void main() {
  final json = {
    'outfitId': 'outfit_xyz123ab',
    'wardrobeId': 'wd_abc123xyz0',
    'wornOn': '2026-09-18',
    'createdAt': '2026-09-18T19:10:00.000Z',
  };

  test('SetWornOnRequest writes date-only wornOn', () {
    expect(SetWornOnRequest.fromDomain(DateTime.utc(2026, 9, 18)).toJson(), {
      'wornOn': '2026-09-18',
    });
  });

  test('WornOnEntryResponse maps to domain without leaking JSON nulls', () {
    final domain = WornOnEntryResponse.fromJson(json).toDomain();

    expect(domain?.outfitId, 'outfit_xyz123ab');
    expect(domain?.wardrobeId, 'wd_abc123xyz0');
    expect(domain?.wornOn, DateTime.utc(2026, 9, 18));
    expect(domain?.createdAt, DateTime.utc(2026, 9, 18, 19, 10));
  });

  test('parseWornOnList unwraps entries and skips junk rows', () {
    final entries = parseWornOnList({
      'entries': [
        json,
        {'outfitId': 'bad'},
        {
          'outfitId': 'outfit_older',
          'wardrobeId': 'wd_abc123xyz0',
          'wornOn': '2026-09-10',
          'createdAt': '2026-09-10T08:00:00Z',
        },
      ],
    });

    expect(entries, hasLength(2));
    expect(entries.first.wornOn, DateTime.utc(2026, 9, 18));
    expect(entries.last.outfitId, 'outfit_older');
  });

  test('empty or omitted entries is an empty log', () {
    expect(parseWornOnList({'entries': []}), isEmpty);
    expect(parseWornOnList({}), isEmpty);
    expect(parseWornOnList(null), isEmpty);
  });

  test('unexpected list shape throws INVALID_RESPONSE', () {
    expect(
      () => parseWornOnList({'entries': 'nope'}),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'INVALID_RESPONSE',
        ),
      ),
    );
  });
}
