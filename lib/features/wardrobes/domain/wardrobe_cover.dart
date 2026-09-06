import '../../items/domain/item.dart';

/// Client-side cover for a wardrobe list card (WARDROBE-55).
///
/// The first clothing item in [listItems] supplies the photo. Empty wardrobes
/// have no cover item so the UI can show a themed placeholder. No extra
/// backend field is required.
class WardrobeCover {
  const WardrobeCover({this.firstItem, required this.itemCount});

  /// First item in the wardrobe list, or `null` when the wardrobe is empty.
  final Item? firstItem;

  final int itemCount;

  bool get isEmpty => itemCount == 0 || firstItem == null;

  factory WardrobeCover.fromItems(List<Item> items) {
    return WardrobeCover(
      firstItem: items.isEmpty ? null : items.first,
      itemCount: items.length,
    );
  }

  String get itemCountLabel {
    if (itemCount <= 0) {
      return 'No items yet';
    }
    if (itemCount == 1) {
      return '1 item';
    }
    return '$itemCount items';
  }
}
