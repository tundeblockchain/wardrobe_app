/// Family key for a clothing item nested under a wardrobe.
class ItemScope {
  const ItemScope({required this.wardrobeId, required this.itemId});

  final String wardrobeId;
  final String itemId;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemScope &&
            wardrobeId == other.wardrobeId &&
            itemId == other.itemId;
  }

  @override
  int get hashCode => Object.hash(wardrobeId, itemId);
}
