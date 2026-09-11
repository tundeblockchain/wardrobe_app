import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/outfit_dtos.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';

void main() {
  final json = {
    'outfitId': 'outfit_123',
    'wardrobeId': 'wd_abc123',
    'name': 'Friday Night',
    'items': [
      {'itemId': 'item_top123', 'slot': 'TOP'},
      {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
      {'itemId': 'item_shoes789', 'slot': 'SHOES'},
    ],
    'createdAt': '2026-09-04T18:00:00Z',
    'updatedAt': '2026-09-04T19:00:00Z',
  };

  group('OutfitResponse', () {
    test(
      'fromJson maps outfitId to domain id without leaking backend names',
      () {
        final domain = OutfitResponse.fromJson(json).toDomain();

        expect(domain.id, 'outfit_123');
        expect(domain.wardrobeId, 'wd_abc123');
        expect(domain.name, 'Friday Night');
        expect(domain.items, hasLength(3));
        expect(domain.items.first.itemId, 'item_top123');
        expect(domain.items.first.slot, ItemCategory.top);
        expect(domain.items.first.slot.label, 'Top');
        expect(domain.createdAt.toUtc(), DateTime.utc(2026, 9, 4, 18));
        expect(domain.updatedAt.toUtc(), DateTime.utc(2026, 9, 4, 19));
        expect(domain.toString(), isNot(contains('outfitId')));
      },
    );

    test('rejects an unknown slot', () {
      expect(
        () => OutfitResponse.fromJson({
          ...json,
          'items': [
            {'itemId': 'item_hat', 'slot': 'HAT'},
          ],
        }).toDomain(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.code,
            'code',
            'INVALID_RESPONSE',
          ),
        ),
      );
    });
  });

  group('OutfitListResponse', () {
    test('maps nested outfits array to domain list', () {
      final domain = OutfitListResponse.fromJson({
        'outfits': [json],
      }).toDomain();

      expect(domain, hasLength(1));
      expect(domain.single.id, 'outfit_123');
    });
  });

  group('write request DTOs', () {
    test('create serializes name and slot assignments', () {
      expect(
        CreateOutfitRequest.fromDomain(
          name: 'Friday Night',
          items: const [
            OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
          ],
        ).toJson(),
        {
          'name': 'Friday Night',
          'items': [
            {'itemId': 'item_top123', 'slot': 'TOP'},
          ],
        },
      );
    });

    test('update serializes only provided fields', () {
      expect(const UpdateOutfitRequest(name: 'Saturday Brunch').toJson(), {
        'name': 'Saturday Brunch',
      });
    });
  });

  group('OutfitRenderResponse', () {
    test('maps READY fields including imageUrl for display', () {
      final domain = OutfitRenderResponse.fromJson({
        'status': 'READY',
        'aiProfileId': 'profile_generic_01',
        'imageKey': 'users/uid/outfits/outfit_123/render.png',
        'imageUrl': 'https://cdn.example.com/try-on.png',
      }).toDomain();

      expect(domain.status, OutfitRenderStatus.ready);
      expect(domain.aiProfileId, 'profile_generic_01');
      expect(domain.imageUrl, 'https://cdn.example.com/try-on.png');
      expect(domain.hasDisplayImage, isTrue);
    });

    test('maps FAILED error without leaking empty strings', () {
      final domain = OutfitRenderResponse.fromJson({
        'status': 'FAILED',
        'aiProfileId': 'profile_personal_1',
        'error': '  Profile is not ready.  ',
        'imageUrl': '',
      }).toDomain();

      expect(domain.status, OutfitRenderStatus.failed);
      expect(domain.error, 'Profile is not ready.');
      expect(domain.imageUrl, isNull);
      expect(domain.hasDisplayImage, isFalse);
    });
  });

  group('RequestOutfitRenderRequest', () {
    test('serializes aiProfileId and optional items', () {
      expect(
        RequestOutfitRenderRequest(
          aiProfileId: 'profile_generic_01',
          items: [
            OutfitItemRequest.fromDomain(
              const OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
            ),
          ],
        ).toJson(),
        {
          'aiProfileId': 'profile_generic_01',
          'items': [
            {'itemId': 'item_top123', 'slot': 'TOP'},
          ],
        },
      );
    });

    test('omits optional items and itemIds when null', () {
      expect(
        const RequestOutfitRenderRequest(aiProfileId: 'profile_generic_01')
            .toJson(),
        {'aiProfileId': 'profile_generic_01'},
      );
    });
  });

  group('OutfitResponse with render', () {
    test('maps nested render onto the outfit domain', () {
      final domain = OutfitResponse.fromJson({
        ...json,
        'render': {'status': 'PENDING', 'aiProfileId': 'profile_generic_01'},
      }).toDomain();

      expect(domain.render?.status, OutfitRenderStatus.pending);
      expect(domain.render?.aiProfileId, 'profile_generic_01');
    });
  });

  group('WARDROBE-85 render history mapping', () {
    test('keeps newest-first URLs and omits a bad or missing URL only', () {
      final entries = parseRenderHistory([
        {
          'imageKey': 'users/uid/outfits/outfit_123/renders/rend_new.png',
          'imageUrl': 'https://cdn.example.com/try-on/newer.png',
          'createdAt': '2026-09-10T00:00:00Z',
          'aiProfileId': 'profile_generic_02',
        },
        {
          'imageKey': 'users/uid/outfits/outfit_123/render.png',
          'createdAt': '2026-09-01T00:00:00Z',
          'aiProfileId': 'profile_generic_01',
        },
        {
          'imageKey': 'users/uid/outfits/outfit_123/renders/bad.png',
          'imageUrl': 'users/uid/outfits/outfit_123/renders/bad.png',
          'createdAt': '2026-08-01T00:00:00Z',
          'aiProfileId': 'profile_generic_01',
        },
      ]);

      expect(entries, hasLength(3));
      expect(
        entries.first.imageUrl,
        'https://cdn.example.com/try-on/newer.png',
      );
      expect(entries[1].imageUrl, isNull);
      expect(entries[2].imageUrl, isNull);
    });

    test('parseRenderImageUrls drops keys and empty strings', () {
      expect(
        parseRenderImageUrls([
          'https://cdn.example.com/try-on/newer.png',
          'users/uid/outfits/outfit_123/renders/rend_old.png',
          '',
          'https://cdn.example.com/try-on/older.png',
        ]),
        [
          'https://cdn.example.com/try-on/newer.png',
          'https://cdn.example.com/try-on/older.png',
        ],
      );
      expect(parseRenderImageUrls(null), isEmpty);
    });
  });
}
