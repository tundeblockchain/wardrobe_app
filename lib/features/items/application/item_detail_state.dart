import '../domain/item.dart';

/// Immutable detail-screen state owned by [ItemDetailController].
class ItemDetailState {
  const ItemDetailState({
    this.item,
    this.isLoading = false,
    this.isSaving = false,
    this.isReprocessing = false,
    this.isPolling = false,
    this.isDeleted = false,
    this.errorMessage,
    this.snackMessage,
  });

  final Item? item;
  final bool isLoading;
  final bool isSaving;
  final bool isReprocessing;
  final bool isPolling;
  final bool isDeleted;
  final String? errorMessage;
  final String? snackMessage;

  bool get showProcessingRetry =>
      item?.processingStatus.canReprocess == true &&
      !isReprocessing &&
      !isPolling;

  bool get showProcessingProgress =>
      isPolling && item?.processingStatus.isInProgress == true;

  bool get showProcessingBanner =>
      item != null &&
      (item!.processingStatus.canReprocess || showProcessingProgress);

  ItemDetailState copyWith({
    Item? item,
    bool clearItem = false,
    bool? isLoading,
    bool? isSaving,
    bool? isReprocessing,
    bool? isPolling,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
    String? snackMessage,
    bool clearSnack = false,
  }) {
    return ItemDetailState(
      item: clearItem ? null : (item ?? this.item),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isReprocessing: isReprocessing ?? this.isReprocessing,
      isPolling: isPolling ?? this.isPolling,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      snackMessage: clearSnack ? null : (snackMessage ?? this.snackMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemDetailState &&
            item == other.item &&
            isLoading == other.isLoading &&
            isSaving == other.isSaving &&
            isReprocessing == other.isReprocessing &&
            isPolling == other.isPolling &&
            isDeleted == other.isDeleted &&
            errorMessage == other.errorMessage &&
            snackMessage == other.snackMessage;
  }

  @override
  int get hashCode => Object.hash(
    item,
    isLoading,
    isSaving,
    isReprocessing,
    isPolling,
    isDeleted,
    errorMessage,
    snackMessage,
  );
}
