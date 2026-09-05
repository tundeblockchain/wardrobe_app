import 'recommendation.dart';

/// Derived outfit suggestions nested under a wardrobe. Read-only.
abstract interface class RecommendationRepository {
  Future<List<Recommendation>> listRecommendations(String wardrobeId);
}
