import '../domain/ai_profile.dart';

/// Immutable catalog state for seeded GENERIC_MODEL profiles.
class GenericModelsState {
  const GenericModelsState({
    this.models = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<AiProfile> models;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => models.isEmpty;

  GenericModelsState copyWith({
    List<AiProfile>? models,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GenericModelsState(
      models: models ?? this.models,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GenericModelsState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            _listEquals(models, other.models);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(models), isLoading, errorMessage);
}

bool _listEquals(List<AiProfile> a, List<AiProfile> b) {
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
