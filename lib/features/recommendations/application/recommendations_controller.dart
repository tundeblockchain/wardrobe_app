import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/dio_recommendation_repository.dart';
import '../domain/recommendation.dart';
import '../domain/recommendation_repository.dart';
import 'recommendations_state.dart';

/// Loads suggested outfits for one wardrobe. Failures stay local to this
/// feature so Phase-1 wardrobe/item/outfit flows keep working.
class RecommendationsController extends Notifier<RecommendationsState> {
  RecommendationsController(this.wardrobeId);

  final String wardrobeId;

  @override
  RecommendationsState build() {
    Future<void>.microtask(refresh);
    return const RecommendationsState(isLoading: true);
  }

  RecommendationRepository get _repository =>
      ref.read(recommendationRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final recommendations = await _repository.listRecommendations(wardrobeId);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        recommendations: recommendations,
      );
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Suggestions are unavailable right now.',
      );
    }
  }

  Recommendation? recommendationAt(int index) {
    if (index < 0 || index >= state.recommendations.length) {
      return null;
    }
    return state.recommendations[index];
  }
}

final recommendationsControllerProvider =
    NotifierProvider.family<
      RecommendationsController,
      RecommendationsState,
      String
    >(RecommendationsController.new);
