import '../domain/try_on_history.dart';

/// Outfit-scoped WARDROBE-85 history. Empty when the route is not live yet.
class TryOnHistoryState {
  const TryOnHistoryState({
    this.entries = const [],
    this.isLoading = false,
    this.isUnavailable = false,
    this.errorMessage,
  });

  final List<TryOnHistoryEntry> entries;
  final bool isLoading;
  final bool isUnavailable;
  final String? errorMessage;

  TryOnHistoryState copyWith({
    List<TryOnHistoryEntry>? entries,
    bool? isLoading,
    bool? isUnavailable,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TryOnHistoryState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isUnavailable: isUnavailable ?? this.isUnavailable,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TryOnHistoryState &&
            entries == other.entries &&
            isLoading == other.isLoading &&
            isUnavailable == other.isUnavailable &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(entries),
    isLoading,
    isUnavailable,
    errorMessage,
  );
}
