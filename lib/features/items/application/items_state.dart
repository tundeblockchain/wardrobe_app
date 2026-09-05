import '../domain/item.dart';
import '../domain/item_list_filters.dart';

/// Immutable list-screen state owned by [ItemsController].
class ItemsState {
  const ItemsState({
    this.items = const [],
    this.filters = const ItemListFilters(),
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Item> items;
  final ItemListFilters filters;
  final bool isLoading;
  final String? errorMessage;

  bool get isEmpty => items.isEmpty;

  ItemsState copyWith({
    List<Item>? items,
    ItemListFilters? filters,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ItemsState(
      items: items ?? this.items,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemsState &&
            isLoading == other.isLoading &&
            errorMessage == other.errorMessage &&
            filters == other.filters &&
            _listEquals(items, other.items);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), filters, isLoading, errorMessage);
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
