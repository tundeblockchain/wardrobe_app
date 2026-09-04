import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/outfit_dtos.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';

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
}
