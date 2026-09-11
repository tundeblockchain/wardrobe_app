import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit_repository.dart';
import '../domain/try_on_history.dart';
import 'outfit_scope.dart';
import 'try_on_history_state.dart';

/// Loads persisted try-ons for one outfit. Soft-empty when WARDROBE-85 is down.
class TryOnHistoryController extends Notifier<TryOnHistoryState> {
  TryOnHistoryController(this.scope);

  final OutfitScope scope;

  @override
  TryOnHistoryState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const TryOnHistoryState();
    }
    Future<void>.microtask(refresh);
    return const TryOnHistoryState(isLoading: true);
  }

  OutfitRepository get _repository => ref.read(outfitRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final entries = await _repository.listTryOnHistory(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
      );
      if (!ref.mounted) {
        return;
      }
      state = TryOnHistoryState(entries: entries);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      if (isTryOnHistoryGap(error)) {
        state = const TryOnHistoryState(isUnavailable: true);
        return;
      }
      state = TryOnHistoryState(errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = const TryOnHistoryState(
        errorMessage: 'Could not load try-on history.',
      );
    }
  }
}

final tryOnHistoryControllerProvider =
    NotifierProvider.family<
      TryOnHistoryController,
      TryOnHistoryState,
      OutfitScope
    >(TryOnHistoryController.new);
