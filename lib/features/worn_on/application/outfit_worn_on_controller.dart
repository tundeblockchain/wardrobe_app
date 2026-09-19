import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../outfits/application/outfit_scope.dart';
import '../data/dio_worn_on_repository.dart';
import '../data/worn_on_dtos.dart';
import '../domain/worn_on_date.dart';
import '../domain/worn_on_entry.dart';
import '../domain/worn_on_errors.dart';
import '../domain/worn_on_repository.dart';
import 'outfit_worn_on_state.dart';
import 'worn_on_clock.dart';

/// Loads and mutates the worn-on log for one outfit.
class OutfitWornOnController extends Notifier<OutfitWornOnState> {
  OutfitWornOnController(this.scope);

  final OutfitScope scope;

  @override
  OutfitWornOnState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const OutfitWornOnState();
    }
    Future<void>.microtask(refresh);
    return const OutfitWornOnState(isLoading: true);
  }

  WornOnRepository get _repository => ref.read(wornOnRepositoryProvider);

  DateTime get _today => WornOnDate.todayLocal(ref.read(wornOnClockProvider)());

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final entries = await _repository.listOutfitWornOn(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, entries: entries);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: WornOnErrors.messageFor(error),
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: WornOnErrors.generic,
      );
    }
  }

  Future<bool> markToday() => markDate(_today);

  Future<bool> markDate(DateTime date) async {
    final wornOn = WornOnDate.dateOnly(date);
    if (WornOnDate.tryParseStrict(WornOnDate.formatWire(wornOn)) == null) {
      state = state.copyWith(errorMessage: WornOnErrors.validation);
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final entry = await _repository.setWornOn(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
        wornOn: wornOn,
      );
      if (!ref.mounted) {
        return true;
      }
      state = state.copyWith(
        isSaving: false,
        entries: _upsert(state.entries, entry),
      );
      return true;
    } on ApiException catch (error) {
      return _fail(error);
    } catch (_) {
      return _failGeneric();
    }
  }

  Future<bool> unmark(DateTime date) async {
    final wornOn = WornOnDate.dateOnly(date);
    if (WornOnDate.tryParseStrict(WornOnDate.formatWire(wornOn)) == null) {
      state = state.copyWith(errorMessage: WornOnErrors.validation);
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.removeWornOn(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
        wornOn: wornOn,
      );
      if (!ref.mounted) {
        return true;
      }
      state = state.copyWith(
        isSaving: false,
        entries: [
          for (final entry in state.entries)
            if (!WornOnDate.isSameDay(entry.wornOn, wornOn)) entry,
        ],
      );
      return true;
    } on ApiException catch (error) {
      return _fail(error);
    } catch (_) {
      return _failGeneric();
    }
  }

  List<WornOnEntry> _upsert(List<WornOnEntry> current, WornOnEntry incoming) {
    final next = [
      for (final entry in current)
        if (!(entry.outfitId == incoming.outfitId &&
            WornOnDate.isSameDay(entry.wornOn, incoming.wornOn)))
          entry,
      incoming,
    ];
    return sortWornOnEntries(next);
  }

  bool _fail(ApiException error) {
    if (!ref.mounted) {
      return false;
    }
    state = state.copyWith(
      isSaving: false,
      errorMessage: WornOnErrors.messageFor(error),
    );
    return false;
  }

  bool _failGeneric() {
    if (!ref.mounted) {
      return false;
    }
    state = state.copyWith(isSaving: false, errorMessage: WornOnErrors.generic);
    return false;
  }
}

final outfitWornOnControllerProvider =
    NotifierProvider.family<
      OutfitWornOnController,
      OutfitWornOnState,
      OutfitScope
    >(OutfitWornOnController.new);
