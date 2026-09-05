/// Family key for one suggestion nested under a wardrobe list.
class RecommendationScope {
  const RecommendationScope({required this.wardrobeId, required this.index});

  final String wardrobeId;
  final int index;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecommendationScope &&
            wardrobeId == other.wardrobeId &&
            index == other.index;
  }

  @override
  int get hashCode => Object.hash(wardrobeId, index);
}
