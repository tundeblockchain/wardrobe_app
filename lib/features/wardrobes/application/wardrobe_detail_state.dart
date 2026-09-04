import '../domain/wardrobe.dart';

/// Immutable detail-screen state owned by [WardrobeDetailController].
class WardrobeDetailState {
  const WardrobeDetailState({
    this.wardrobe,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.errorMessage,
  });

  final Wardrobe? wardrobe;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleted;
  final String? errorMessage;

  WardrobeDetailState copyWith({
    Wardrobe? wardrobe,
    bool clearWardrobe = false,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WardrobeDetailState(
      wardrobe: clearWardrobe ? null : (wardrobe ?? this.wardrobe),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WardrobeDetailState &&
            wardrobe == other.wardrobe &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            isDeleted == other.isDeleted &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(wardrobe, isLoading, isSaving, isDeleted, errorMessage);
}
