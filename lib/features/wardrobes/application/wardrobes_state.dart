import '../domain/wardrobe.dart';

/// Immutable list-screen state owned by [WardrobesController].
class WardrobesState {
  const WardrobesState({
    this.wardrobes = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Wardrobe> wardrobes;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => wardrobes.isEmpty;

  WardrobesState copyWith({
    List<Wardrobe>? wardrobes,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WardrobesState(
      wardrobes: wardrobes ?? this.wardrobes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WardrobesState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            _listEquals(wardrobes, other.wardrobes);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(wardrobes), isLoading, errorMessage);
}

/// Immutable create-form state owned by [CreateWardrobeController].
class CreateWardrobeState {
  const CreateWardrobeState({this.isSaving = false, this.errorMessage});

  final bool isSaving;
  final String? errorMessage;

  CreateWardrobeState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateWardrobeState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CreateWardrobeState &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(isSaving, errorMessage);
}

bool _listEquals(List<Wardrobe> a, List<Wardrobe> b) {
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
