import '../domain/outfit.dart';

/// Immutable detail-screen state owned by [OutfitDetailController].
class OutfitDetailState {
  const OutfitDetailState({
    this.outfit,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.errorMessage,
  });

  final Outfit? outfit;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleted;
  final String? errorMessage;

  OutfitDetailState copyWith({
    Outfit? outfit,
    bool clearOutfit = false,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OutfitDetailState(
      outfit: clearOutfit ? null : (outfit ?? this.outfit),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitDetailState &&
            outfit == other.outfit &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            isDeleted == other.isDeleted &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(outfit, isLoading, isSaving, isDeleted, errorMessage);
}
