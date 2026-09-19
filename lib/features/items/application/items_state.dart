import '../domain/item.dart';
import '../domain/item_list_filters.dart';

/// Immutable list-screen state owned by [ItemsController].
class ItemsState {
  const ItemsState({
    this.items = const [],
    this.filters = const ItemListFilters(),
    this.isLoading = false,
    this.reprocessingItemIds = const <String>{},
    this.pollingItemIds = const <String>{},
    this.errorMessage,
    this.snackMessage,
  });

  /// Full wardrobe list from the last repository fetch. Filters never
  /// mutate this list — [visibleItems] is the client-side projection.
  final List<Item> items;
  final ItemListFilters filters;
  final bool isLoading;
  final Set<String> reprocessingItemIds;
  final Set<String> pollingItemIds;
  final String? errorMessage;
  final String? snackMessage;

  bool get isEmpty => items.isEmpty;

  /// Category / colour / tag / acquired window over [items] (WARDROBE-116).
  List<Item> get visibleItems => filters.apply(items);

  bool isReprocessing(String itemId) => reprocessingItemIds.contains(itemId);

  bool isPolling(String itemId) => pollingItemIds.contains(itemId);

  bool showProcessingRetry(Item item) =>
      item.processingStatus.canReprocess &&
      !isReprocessing(item.id) &&
      !isPolling(item.id);

  bool showProcessingProgress(Item item) =>
      isPolling(item.id) && item.processingStatus.isInProgress;

  ItemsState copyWith({
    List<Item>? items,
    ItemListFilters? filters,
    bool? isLoading,
    Set<String>? reprocessingItemIds,
    Set<String>? pollingItemIds,
    String? errorMessage,
    bool clearError = false,
    String? snackMessage,
    bool clearSnack = false,
  }) {
    return ItemsState(
      items: items ?? this.items,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      reprocessingItemIds: reprocessingItemIds ?? this.reprocessingItemIds,
      pollingItemIds: pollingItemIds ?? this.pollingItemIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      snackMessage: clearSnack ? null : (snackMessage ?? this.snackMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemsState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            snackMessage == other.snackMessage &&
            filters == other.filters &&
            _setEquals(reprocessingItemIds, other.reprocessingItemIds) &&
            _setEquals(pollingItemIds, other.pollingItemIds) &&
            _listEquals(items, other.items);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(items),
    filters,
    isLoading,
    Object.hashAll(reprocessingItemIds),
    Object.hashAll(pollingItemIds),
    errorMessage,
    snackMessage,
  );
}

bool _listEquals(List<Item> a, List<Item> b) {
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

bool _setEquals(Set<String> a, Set<String> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  return a.containsAll(b);
}
