/// Family key for an outfit nested under a wardrobe.
class OutfitScope {
  const OutfitScope({required this.wardrobeId, required this.outfitId});

  final String wardrobeId;
  final String outfitId;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitScope &&
            wardrobeId == other.wardrobeId &&
            outfitId == other.outfitId;
  }

  @override
  int get hashCode => Object.hash(wardrobeId, outfitId);
}
