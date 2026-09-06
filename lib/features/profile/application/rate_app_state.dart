/// Immutable rate-app state owned by [RateAppController].
class RateAppState {
  const RateAppState({this.isBusy = false, this.errorMessage});

  final bool isBusy;
  final String? errorMessage;

  RateAppState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RateAppState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RateAppState &&
            isBusy == other.isBusy &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(isBusy, errorMessage);
}
