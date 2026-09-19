import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/share/data/share_dtos.dart';
import 'package:wardrobe_app/features/share/domain/share.dart';

void main() {
  final itemJson = {
    'token': 'shr_itemtoken21charsxx',
    'resourceType': 'ITEM',
    'wardrobeId': 'wd_abc123',
    'itemId': 'item_xyz123',
    'sharePath': '/share/shr_itemtoken21charsxx',
    'expiresAt': '2026-10-19T12:00:00.000Z',
    'createdAt': '2026-09-19T12:00:00.000Z',
  };

  final outfitJson = {
    'token': 'shr_outfittoken21charsx',
    'resourceType': 'OUTFIT',
    'wardrobeId': 'wd_abc123',
    'outfitId': 'outfit_123',
    'sharePath': '/share/shr_outfittoken21charsx',
    'expiresAt': '2026-10-19T12:00:00.000Z',
    'createdAt': '2026-09-19T12:00:00.000Z',
  };

  test('parses item share and omits unused outfitId', () {
    final share = parseShare(itemJson);

    expect(share.token, 'shr_itemtoken21charsxx');
    expect(share.resourceType, ShareResourceType.item);
    expect(share.itemId, 'item_xyz123');
    expect(share.outfitId, isNull);
    expect(share.sharePath, '/share/shr_itemtoken21charsxx');
    expect(share.expiresAt, DateTime.utc(2026, 10, 19, 12));
  });

  test('parses outfit share and omits unused itemId', () {
    final share = parseShare(outfitJson);

    expect(share.resourceType, ShareResourceType.outfit);
    expect(share.outfitId, 'outfit_123');
    expect(share.itemId, isNull);
  });

  test('ShareResponse.toJson omits unused ids and never writes null', () {
    final item = ShareResponse.fromJson(itemJson).toJson();
    expect(item.containsKey('outfitId'), isFalse);
    expect(item.values, isNot(contains(null)));

    final outfit = ShareResponse.fromJson(outfitJson).toJson();
    expect(outfit.containsKey('itemId'), isFalse);
    expect(outfit.values, isNot(contains(null)));
  });

  test('rejects absolute sharePath and missing resource id', () {
    expect(
      () => parseShare({
        ...itemJson,
        'sharePath': 'https://share.example.com/share/shr_x',
      }),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'INVALID_RESPONSE',
        ),
      ),
    );
    expect(
      () => parseShare({...itemJson}..remove('itemId')),
      throwsA(isA<ApiException>()),
    );
  });

  test('ShareResponse.toDomain maps a valid item payload', () {
    final domain = ShareResponse.fromJson(itemJson).toDomain();
    expect(domain?.token, 'shr_itemtoken21charsxx');
    expect(domain?.resourceType, ShareResourceType.item);
  });
}
