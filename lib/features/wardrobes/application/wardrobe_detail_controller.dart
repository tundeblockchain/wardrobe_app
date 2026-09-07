import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_wardrobe_repository.dart';
import '../domain/wardrobe_repository.dart';
import 'wardrobe_detail_state.dart';
import 'wardrobes_controller.dart';

/// Loads a single wardrobe and handles rename / delete.
class WardrobeDetailController extends Notifier<WardrobeDetailState> {
  WardrobeDetailController(this.wardrobeId);

  final String wardrobeId;

  @override
  WardrobeDetailState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const WardrobeDetailState();
    }
    Future<void>.microtask(refresh);
    return const WardrobeDetailState(isLoading: true);
  }

  WardrobeRepository get _repository => ref.read(wardrobeRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final wardrobe = await _repository.getWardrobe(wardrobeId);
      state = state.copyWith(isLoading: false, wardrobe: wardrobe);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<bool> rename(String name) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final wardrobe = await _repository.updateWardrobe(
        id: wardrobeId,
        name: name.trim(),
      );
      ref.read(wardrobesControllerProvider.notifier).upsert(wardrobe);
      state = state.copyWith(isSaving: false, wardrobe: wardrobe);
      return true;
    } on ApiException catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<bool> delete() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteWardrobe(wardrobeId);
      ref.read(wardrobesControllerProvider.notifier).remove(wardrobeId);
      state = state.copyWith(
        isSaving: false,
        isDeleted: true,
        clearWardrobe: true,
      );
      return true;
    } on ApiException catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }
}

final wardrobeDetailControllerProvider =
    NotifierProvider.family<
      WardrobeDetailController,
      WardrobeDetailState,
      String
    >(WardrobeDetailController.new);
