import '../../items/domain/item.dart';
import '../domain/outfit.dart';

/// Immutable edit-outfit form state owned by [EditOutfitController].
class EditOutfitState {
  const EditOutfitState({
    this.items = const [],
    this.hasSeeded = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final List<OutfitItem> items;
  final bool hasSeeded;
  final bool isSaving;
  final String? errorMessage;

  OutfitItem? assignmentFor(ItemCategory slot) {
    for (final item in items) {
      if (item.slot == slot) {
        return item;
      }
    }
    return null;
  }

  EditOutfitState copyWith({
    List<OutfitItem>? items,
    bool? hasSeeded,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditOutfitState(
      items: items ?? this.items,
      hasSeeded: hasSeeded ?? this.hasSeeded,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EditOutfitState &&
            hasSeeded == other.hasSeeded &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage &&
            _listEquals(items, other.items);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), hasSeeded, isSaving, errorMessage);
}

bool _listEquals(List<OutfitItem> a, List<OutfitItem> b) {
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
