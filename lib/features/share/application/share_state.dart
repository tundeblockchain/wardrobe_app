/// Immutable share-action state owned by [ShareController].
class ShareState {
  const ShareState({this.isSharing = false, this.snackMessage});

  final bool isSharing;
  final String? snackMessage;

  ShareState copyWith({
    bool? isSharing,
    String? snackMessage,
    bool clearSnack = false,
  }) {
    return ShareState(
      isSharing: isSharing ?? this.isSharing,
      snackMessage: clearSnack ? null : (snackMessage ?? this.snackMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShareState &&
            isSharing == other.isSharing &&
            snackMessage == other.snackMessage;
  }

  @override
  int get hashCode => Object.hash(isSharing, snackMessage);
}
