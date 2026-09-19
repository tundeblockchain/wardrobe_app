import 'worn_on_entry.dart';

/// Outfit worn-on log (WARDROBE-120 / WARDROBE-121).
abstract interface class WornOnRepository {
  /// `POST /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on`
  /// → 201 first log, 200 if that date already exists.
  Future<WornOnEntry> setWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  });

  /// `GET /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on`
  /// → `{ "entries": [...] }` newest `wornOn` first.
  Future<List<WornOnEntry>> listOutfitWornOn({
    required String wardrobeId,
    required String outfitId,
  });

  /// `DELETE /wardrobes/{wardrobeId}/outfits/{outfitId}/worn-on/{date}` → 204.
  Future<void> removeWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  });

  /// `GET /wardrobes/{wardrobeId}/worn-on?from&to` — all entries in range.
  Future<List<WornOnEntry>> listWardrobeWornOn({
    required String wardrobeId,
    DateTime? from,
    DateTime? to,
  });
}
