import 'item.dart';
import 'item_taxonomy.dart';

/// Display labels for the item-details meta block.
///
/// User fields stay authoritative. Empty subcategory / colours fall back to
/// `ai.detectedSubcategory` and `ai.detectedColours`. [Item.category] is
/// required on the wire so it does not need an AI fallback.
abstract final class ItemDetailMeta {
  static const emptyPlaceholder = 'Not set';

  static String categoryLabel(Item item) => item.category.label;

  static String subcategoryLabel(Item item) {
    final wire = _firstNonEmpty([
      item.subcategory,
      item.ai?.detectedSubcategory,
    ]);
    if (wire == null) {
      return emptyPlaceholder;
    }
    return ItemSubcategory.tryParse(wire)?.label ?? humanizeToken(wire);
  }

  static List<String> colourWires(Item item) {
    if (item.colours.isNotEmpty) {
      return item.colours;
    }
    return [...?item.ai?.detectedColours];
  }

  static List<String> colourLabels(Item item) {
    return [for (final wire in colourWires(item)) colourLabel(wire)];
  }

  static String colourLabel(String wire) {
    return ItemColour.tryParse(wire)?.label ?? humanizeToken(wire);
  }

  static String brandLabel(Item item) {
    return _firstNonEmpty([item.brand]) ?? emptyPlaceholder;
  }

  static bool isPlaceholder(String value) => value == emptyPlaceholder;

  /// Title-cases a backend token (`TSHIRT` → `Tshirt`, `NAVY_BLUE` → `Navy blue`).
  static String humanizeToken(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return emptyPlaceholder;
    }
    final words = trimmed
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) {
          final lower = word.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        });
    return words.join(' ');
  }

  static String? _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }
}

/// Tappable wardrobe or outfit chip on the item-details meta block.
class ItemDetailMetaLink {
  const ItemDetailMetaLink({required this.id, required this.label});

  final String id;
  final String label;
}
