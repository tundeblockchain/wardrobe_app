import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/worn_on/data/worn_on_dtos.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_date.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_entry.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_repository.dart';

/// In-memory [WornOnRepository] for unit and widget tests.
class FakeWornOnRepository implements WornOnRepository {
  FakeWornOnRepository({List<WornOnEntry>? seed}) : entries = [...?seed];

  final List<WornOnEntry> entries;
  ApiException? nextFailure;
  int setCalls = 0;
  int listOutfitCalls = 0;
  int removeCalls = 0;
  int listWardrobeCalls = 0;
  DateTime? lastWornOn;
  DateTime? lastFrom;
  DateTime? lastTo;

  @override
  Future<WornOnEntry> setWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) async {
    setCalls++;
    lastWornOn = WornOnDate.dateOnly(wornOn);
    _maybeFail();
    final existing = _indexOf(wardrobeId, outfitId, lastWornOn!);
    if (existing >= 0) {
      return entries[existing];
    }
    final entry = WornOnEntry(
      outfitId: outfitId,
      wardrobeId: wardrobeId,
      wornOn: lastWornOn!,
      createdAt: DateTime.utc(2026, 9, 19, 19, 10),
    );
    entries.add(entry);
    return entry;
  }

  @override
  Future<List<WornOnEntry>> listOutfitWornOn({
    required String wardrobeId,
    required String outfitId,
  }) async {
    listOutfitCalls++;
    _maybeFail();
    return sortWornOnEntries([
      for (final entry in entries)
        if (entry.wardrobeId == wardrobeId && entry.outfitId == outfitId) entry,
    ]);
  }

  @override
  Future<void> removeWornOn({
    required String wardrobeId,
    required String outfitId,
    required DateTime wornOn,
  }) async {
    removeCalls++;
    lastWornOn = WornOnDate.dateOnly(wornOn);
    _maybeFail();
    entries.removeWhere(
      (entry) =>
          entry.wardrobeId == wardrobeId &&
          entry.outfitId == outfitId &&
          WornOnDate.isSameDay(entry.wornOn, lastWornOn!),
    );
  }

  @override
  Future<List<WornOnEntry>> listWardrobeWornOn({
    required String wardrobeId,
    DateTime? from,
    DateTime? to,
  }) async {
    listWardrobeCalls++;
    lastFrom = from == null ? null : WornOnDate.dateOnly(from);
    lastTo = to == null ? null : WornOnDate.dateOnly(to);
    _maybeFail();
    if (lastFrom != null && lastTo != null && lastFrom!.isAfter(lastTo!)) {
      throw WornOnErrors.validationException(WornOnErrors.range);
    }
    return sortWornOnEntries([
      for (final entry in entries)
        if (entry.wardrobeId == wardrobeId &&
            _inRange(entry.wornOn, lastFrom, lastTo))
          entry,
    ]);
  }

  int _indexOf(String wardrobeId, String outfitId, DateTime wornOn) {
    return entries.indexWhere(
      (entry) =>
          entry.wardrobeId == wardrobeId &&
          entry.outfitId == outfitId &&
          WornOnDate.isSameDay(entry.wornOn, wornOn),
    );
  }

  bool _inRange(DateTime wornOn, DateTime? from, DateTime? to) {
    if (from != null && wornOn.isBefore(from)) {
      return false;
    }
    if (to != null && wornOn.isAfter(to)) {
      return false;
    }
    return true;
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

WornOnEntry testWornOnEntry({
  String outfitId = 'outfit_123',
  String wardrobeId = 'wd_abc123',
  DateTime? wornOn,
  DateTime? createdAt,
}) {
  return WornOnEntry(
    outfitId: outfitId,
    wardrobeId: wardrobeId,
    wornOn: wornOn ?? DateTime.utc(2026, 9, 18),
    createdAt: createdAt ?? DateTime.utc(2026, 9, 18, 19, 10),
  );
}
