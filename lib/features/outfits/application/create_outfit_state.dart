import '../../items/domain/item.dart';
import '../domain/outfit.dart';

/// Immutable create-outfit form state owned by [CreateOutfitController].
class CreateOutfitState {
  const CreateOutfitState({
    this.items = const [],
    this.isSaving = false,
    this.errorMessage,
  });

  final List<OutfitItem> items;
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

  CreateOutfitState copyWith({
    List<OutfitItem>? items,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateOutfitState(
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CreateOutfitState &&
            isSaving == other.isSaving &&
            errorMessage == other.errorMessage &&
            _listEquals(items, other.items);
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), isSaving, errorMessage);
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
