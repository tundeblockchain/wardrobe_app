import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_worn_on_repository.dart';
import '../domain/worn_on_date.dart';
import '../domain/worn_on_errors.dart';
import '../domain/worn_on_repository.dart';
import 'wardrobe_worn_on_state.dart';
import 'worn_on_clock.dart';

/// Wardrobe-level worn-on calendar for one month.
class WardrobeWornOnController extends Notifier<WardrobeWornOnState> {
  WardrobeWornOnController(this.wardrobeId);

  final String wardrobeId;

  @override
  WardrobeWornOnState build() {
    final month = WornOnDate.monthOf(
      WornOnDate.todayLocal(ref.read(wornOnClockProvider)()),
    );
    if (!watchAllowsUserDataFetch(ref)) {
      return WardrobeWornOnState(visibleMonth: month);
    }
    Future<void>.microtask(refresh);
    return WardrobeWornOnState(visibleMonth: month, isLoading: true);
  }

  WornOnRepository get _repository => ref.read(wornOnRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final range = WornOnDate.monthRange(state.visibleMonth);
      final entries = await _repository.listWardrobeWornOn(
        wardrobeId: wardrobeId,
        from: range.from,
        to: range.to,
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

  Future<void> showMonth(DateTime month) async {
    final next = WornOnDate.monthOf(month);
    final selected = state.selectedDay;
    final keepSelected =
        selected != null && WornOnDate.monthOf(selected) == next;
    state = state.copyWith(visibleMonth: next, clearSelectedDay: !keepSelected);
    await refresh();
  }

  Future<void> shiftMonth(int delta) =>
      showMonth(WornOnDate.addMonths(state.visibleMonth, delta));

  void selectDay(DateTime? day) {
    if (day == null) {
      state = state.copyWith(clearSelectedDay: true);
      return;
    }
    final normalized = WornOnDate.dateOnly(day);
    if (state.selectedDay != null &&
        WornOnDate.isSameDay(state.selectedDay!, normalized)) {
      state = state.copyWith(clearSelectedDay: true);
      return;
    }
    state = state.copyWith(selectedDay: normalized);
  }

  Future<bool> unmark({
    required String outfitId,
    required DateTime wornOn,
  }) async {
    final date = WornOnDate.dateOnly(wornOn);
    if (WornOnDate.tryParseStrict(WornOnDate.formatWire(date)) == null) {
      state = state.copyWith(errorMessage: WornOnErrors.validation);
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.removeWornOn(
        wardrobeId: wardrobeId,
        outfitId: outfitId,
        wornOn: date,
      );
      if (!ref.mounted) {
        return true;
      }
      state = state.copyWith(
        isSaving: false,
        entries: [
          for (final entry in state.entries)
            if (!(entry.outfitId == outfitId &&
                WornOnDate.isSameDay(entry.wornOn, date)))
              entry,
        ],
      );
      return true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: WornOnErrors.messageFor(error),
      );
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: WornOnErrors.generic,
      );
      return false;
    }
  }
}

final wardrobeWornOnControllerProvider =
    NotifierProvider.family<
      WardrobeWornOnController,
      WardrobeWornOnState,
      String
    >(WardrobeWornOnController.new);
