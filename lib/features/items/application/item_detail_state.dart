import '../domain/item.dart';

/// Immutable detail-screen state owned by [ItemDetailController].
class ItemDetailState {
  const ItemDetailState({
    this.item,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.errorMessage,
  });

  final Item? item;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleted;
  final String? errorMessage;

  ItemDetailState copyWith({
    Item? item,
    bool clearItem = false,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ItemDetailState(
      item: clearItem ? null : (item ?? this.item),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemDetailState &&
            item == other.item &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            isDeleted == other.isDeleted &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(item, isLoading, isSaving, isDeleted, errorMessage);
}
