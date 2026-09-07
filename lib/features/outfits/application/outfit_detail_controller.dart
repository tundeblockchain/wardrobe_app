import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';
import '../domain/outfit_repository.dart';
import 'outfit_detail_state.dart';
import 'outfit_scope.dart';
import 'outfits_controller.dart';

/// Loads an outfit and handles replace / delete.
class OutfitDetailController extends Notifier<OutfitDetailState> {
  OutfitDetailController(this.scope);

  final OutfitScope scope;

  @override
  OutfitDetailState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const OutfitDetailState();
    }
    Future<void>.microtask(refresh);
    return const OutfitDetailState(isLoading: true);
  }

  OutfitRepository get _repository => ref.read(outfitRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final outfit = await _repository.getOutfit(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, outfit: outfit);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void replace(Outfit outfit) {
    state = state.copyWith(outfit: outfit, clearError: true);
  }

  Future<bool> delete() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteOutfit(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
      );
      if (!ref.mounted) {
        return true;
      }
      ref
          .read(outfitsControllerProvider(scope.wardrobeId).notifier)
          .remove(scope.outfitId);
      state = state.copyWith(
        isSaving: false,
        isDeleted: true,
        clearOutfit: true,
      );
      return true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }
}

final outfitDetailControllerProvider =
    NotifierProvider.family<
      OutfitDetailController,
      OutfitDetailState,
      OutfitScope
    >(OutfitDetailController.new);
