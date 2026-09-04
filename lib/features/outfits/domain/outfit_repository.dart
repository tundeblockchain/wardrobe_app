import 'outfit.dart';

/// Outfit CRUD nested under a wardrobe.
abstract interface class OutfitRepository {
  Future<List<Outfit>> listOutfits(String wardrobeId);

  Future<Outfit> getOutfit({
    required String wardrobeId,
    required String outfitId,
  });

  Future<Outfit> createOutfit({
    required String wardrobeId,
    required String name,
    required List<OutfitItem> items,
  });

  Future<Outfit> updateOutfit({
    required String wardrobeId,
    required String outfitId,
    String? name,
    List<OutfitItem>? items,
  });

  Future<void> deleteOutfit({
    required String wardrobeId,
    required String outfitId,
  });
}
