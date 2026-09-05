import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../outfits/data/dio_outfit_repository.dart';
import '../../outfits/domain/outfit.dart';
import '../../outfits/domain/outfit_repository.dart';
import '../../outfits/domain/outfit_validators.dart';
import '../data/recommendation_dtos.dart';
import 'recommendation_detail_state.dart';
import 'recommendation_scope.dart';
import 'recommendations_controller.dart';

/// Previews one suggestion and saves it through existing outfit create.
class RecommendationDetailController
    extends Notifier<RecommendationDetailState> {
  RecommendationDetailController(this.scope);

  final RecommendationScope scope;

  @override
  RecommendationDetailState build() {
    Future<void>.microtask(refresh);
    return const RecommendationDetailState(isLoading: true);
  }

  OutfitRepository get _outfits => ref.read(outfitRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSavedOutfit: true,
    );
    final list = ref.read(recommendationsControllerProvider(scope.wardrobeId));
    if (list.isLoading && list.recommendations.isEmpty) {
      await ref
          .read(recommendationsControllerProvider(scope.wardrobeId).notifier)
          .refresh();
    }
    if (!ref.mounted) {
      return;
    }
    final recommendation = ref
        .read(recommendationsControllerProvider(scope.wardrobeId).notifier)
        .recommendationAt(scope.index);
    if (recommendation == null) {
      final listError = ref
          .read(recommendationsControllerProvider(scope.wardrobeId))
          .errorMessage;
      state = state.copyWith(
        isLoading: false,
        clearRecommendation: true,
        errorMessage: listError ?? 'Suggestion not found.',
      );
      return;
    }
    state = state.copyWith(isLoading: false, recommendation: recommendation);
  }

  Future<Outfit?> save() async {
    final recommendation = state.recommendation;
    if (recommendation == null) {
      return null;
    }
    final nameError = OutfitValidators.name(recommendation.name);
    if (nameError != null) {
      state = state.copyWith(errorMessage: nameError);
      return null;
    }
    final itemsError = OutfitValidators.items(recommendation.items);
    if (itemsError != null) {
      state = state.copyWith(errorMessage: itemsError);
      return null;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      // Persist only when the user taps Save — never auto-save suggestions.
      final request = createOutfitRequestFromRecommendation(recommendation);
      final outfit = await _outfits.createOutfit(
        wardrobeId: scope.wardrobeId,
        name: request.name,
        items: recommendation.items,
      );
      if (!ref.mounted) {
        return outfit;
      }
      ref
          .read(outfitsControllerProvider(scope.wardrobeId).notifier)
          .upsert(outfit);
      state = state.copyWith(isSaving: false, savedOutfit: outfit);
      return outfit;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return null;
    } catch (_) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }
}

final recommendationDetailControllerProvider =
    NotifierProvider.family<
      RecommendationDetailController,
      RecommendationDetailState,
      RecommendationScope
    >(RecommendationDetailController.new);
