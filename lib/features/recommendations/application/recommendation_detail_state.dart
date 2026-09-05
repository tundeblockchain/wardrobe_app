import '../../outfits/domain/outfit.dart';
import '../domain/recommendation.dart';

/// Immutable detail-screen state owned by [RecommendationDetailController].
class RecommendationDetailState {
  const RecommendationDetailState({
    this.recommendation,
    this.savedOutfit,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final Recommendation? recommendation;
  final Outfit? savedOutfit;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  RecommendationDetailState copyWith({
    Recommendation? recommendation,
    bool clearRecommendation = false,
    Outfit? savedOutfit,
    bool clearSavedOutfit = false,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecommendationDetailState(
      recommendation: clearRecommendation
          ? null
          : (recommendation ?? this.recommendation),
      savedOutfit: clearSavedOutfit ? null : (savedOutfit ?? this.savedOutfit),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecommendationDetailState &&
            recommendation == other.recommendation &&
            savedOutfit == other.savedOutfit &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    recommendation,
    savedOutfit,
    isLoading,
    isSaving,
    errorMessage,
  );
}
