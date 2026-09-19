import '../domain/worn_on_entry.dart';
import '../domain/worn_on_repository.dart';

/// Empty source used when the Backend worn-on API is not live yet.
class StubWornOnRepository implements WornOnRepository {
  const StubWornOnRepository();

  @override
  Future<WornOnEntry> setWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) async {
    return WornOnEntry(
      outfitId: outfitId,
      wardrobeId: wardrobeId,
      wornOn: wornOn,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<List<WornOnEntry>> listOutfitWornOn({
    required String wardrobeId,
    required String outfitId,
  }) async => const [];

  @override
  Future<void> removeWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) async {}

  @override
  Future<List<WornOnEntry>> listWardrobeWornOn({
    required String wardrobeId,
    DateTime? from,
    DateTime? to,
  }) async => const [];
}
