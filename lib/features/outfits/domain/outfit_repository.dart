import 'outfit.dart';
import 'outfit_render.dart';

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

  /// `POST /wardrobes/{wardrobeId}/outfits/{outfitId}/render` → 202 Outfit.
  Future<Outfit> requestRender({
    required String wardrobeId,
    required String outfitId,
    required String aiProfileId,
    List<OutfitItem>? items,
    List<String>? itemIds,
  });

  /// `GET /wardrobes/{wardrobeId}/outfits/{outfitId}/render` for polling.
  Future<OutfitRender> getRender({
    required String wardrobeId,
    required String outfitId,
  });
}
