import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/recommendations/data/recommendation_dtos.dart';
import 'package:wardrobe_app/features/recommendations/domain/recommendation.dart';

void main() {
  final json = {
    'name': 'Navy + Beige look',
    'items': [
      {'itemId': 'item_top123', 'slot': 'TOP'},
      {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
    ],
  };

  group('RecommendationResponse', () {
    test('fromJson maps name and slot assignments to domain', () {
      final domain = RecommendationResponse.fromJson(json).toDomain();

      expect(domain.name, 'Navy + Beige look');
      expect(domain.items, hasLength(2));
      expect(domain.items.first.itemId, 'item_top123');
      expect(domain.items.first.slot, ItemCategory.top);
      expect(domain.items.last.slot, ItemCategory.bottom);
    });

    test('defaults a missing or blank name', () {
      expect(
        RecommendationResponse.fromJson({
          'items': [
            {'itemId': 'item_top123', 'slot': 'TOP'},
          ],
        }).toDomain().name,
        'Suggested look',
      );
      expect(
        RecommendationResponse.fromJson({
          'name': '   ',
          'items': [
            {'itemId': 'item_top123', 'slot': 'TOP'},
          ],
        }).toDomain().name,
        'Suggested look',
      );
    });

    test('rejects an unknown slot', () {
      expect(
        () => RecommendationResponse.fromJson({
          'name': 'Odd hat look',
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

  group('RecommendationListResponse', () {
    test('maps nested recommendations array to domain list', () {
      final domain = RecommendationListResponse.fromJson({
        'recommendations': [json],
      }).toDomain();

      expect(domain, hasLength(1));
      expect(domain.single.name, 'Navy + Beige look');
    });

    test('empty envelope maps to an empty list', () {
      expect(
        RecommendationListResponse.fromJson({
          'recommendations': <Map<String, dynamic>>[],
        }).toDomain(),
        isEmpty,
      );
    });
  });

  group('createOutfitRequestFromRecommendation', () {
    test('save maps to CreateOutfitRequest name + items[{itemId,slot}]', () {
      const recommendation = Recommendation(
        name: 'Navy + Beige look',
        items: [
          OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
          OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
        ],
      );

      expect(createOutfitRequestFromRecommendation(recommendation).toJson(), {
        'name': 'Navy + Beige look',
        'items': [
          {'itemId': 'item_top123', 'slot': 'TOP'},
          {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
        ],
      });
    });
  });
}
