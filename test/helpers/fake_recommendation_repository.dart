import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/recommendations/domain/recommendation.dart';
import 'package:wardrobe_app/features/recommendations/domain/recommendation_repository.dart';

/// In-memory [RecommendationRepository] for unit tests.
class FakeRecommendationRepository implements RecommendationRepository {
  FakeRecommendationRepository({List<Recommendation>? seed})
    : recommendations = [...?seed];

  final List<Recommendation> recommendations;
  ApiException? nextFailure;
  int listCalls = 0;

  @override
  Future<List<Recommendation>> listRecommendations(String wardrobeId) async {
    listCalls++;
    _maybeFail();
    return [...recommendations];
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

Recommendation testRecommendation({
  String name = 'Navy + Beige look',
  List<OutfitItem>? items,
}) {
  return Recommendation(
    name: name,
    items:
        items ??
        const [
          OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
          OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
        ],
  );
}
