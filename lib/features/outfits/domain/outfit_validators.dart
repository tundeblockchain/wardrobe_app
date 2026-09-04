import '../../items/domain/item.dart';
import 'outfit.dart';

/// Presentation-level validators for outfit forms.
abstract final class OutfitValidators {
  static const maxNameLength = 100;

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter an outfit name.';
    }
    if (trimmed.length > maxNameLength) {
      return 'Name must be $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? items(List<OutfitItem> value) {
    if (value.isEmpty) {
      return 'Add at least one item to this outfit.';
    }
    return null;
  }
}

/// Replaces [slot] and drops any previous assignment of [itemId].
List<OutfitItem> assignOutfitItem({
  required List<OutfitItem> current,
  required OutfitItem assignment,
}) {
  return [
    for (final item in current)
      if (item.slot != assignment.slot && item.itemId != assignment.itemId)
        item,
    assignment,
  ];
}

/// Removes the item in [slot], if any.
List<OutfitItem> clearOutfitSlot({
  required List<OutfitItem> current,
  required ItemCategory slot,
}) {
  return [
    for (final item in current)
      if (item.slot != slot) item,
  ];
}
