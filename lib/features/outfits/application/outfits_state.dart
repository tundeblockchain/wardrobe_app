import '../domain/outfit.dart';

/// Immutable list-screen state owned by [OutfitsController].
class OutfitsState {
  const OutfitsState({
    this.outfits = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Outfit> outfits;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => outfits.isEmpty;

  OutfitsState copyWith({
    List<Outfit>? outfits,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OutfitsState(
      outfits: outfits ?? this.outfits,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitsState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            _listEquals(outfits, other.outfits);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(outfits), isLoading, errorMessage);
}

bool _listEquals(List<Outfit> a, List<Outfit> b) {
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
