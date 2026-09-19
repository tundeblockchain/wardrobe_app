import 'share.dart';

/// Owner share-token API. Flutter never calls public GET.
abstract interface class ShareRepository {
  /// `POST /wardrobes/{wardrobeId}/items/{itemId}/share` → `201 Share`.
  Future<Share> createItemShare({
    required String wardrobeId,
    required String itemId,
  });

  /// `POST /wardrobes/{wardrobeId}/outfits/{outfitId}/share` → `201 Share`.
  Future<Share> createOutfitShare({
    required String wardrobeId,
    required String outfitId,
  });

  /// `DELETE /shares/{token}` → `204` (idempotent if already gone).
  Future<void> revokeShare(String token);
}
