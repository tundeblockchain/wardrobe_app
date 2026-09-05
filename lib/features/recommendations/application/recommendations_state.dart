import '../domain/recommendation.dart';

/// Immutable list-screen state owned by [RecommendationsController].
class RecommendationsState {
  const RecommendationsState({
    this.recommendations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Recommendation> recommendations;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => recommendations.isEmpty;

  /// True when the API failed. Phase-1 wardrobe/outfit flows stay usable.
  bool get isUnavailable => errorMessage != null && recommendations.isEmpty;

  RecommendationsState copyWith({
    List<Recommendation>? recommendations,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RecommendationsState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecommendationsState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            _listEquals(recommendations, other.recommendations);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(recommendations), isLoading, errorMessage);
}

bool _listEquals(List<Recommendation> a, List<Recommendation> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
