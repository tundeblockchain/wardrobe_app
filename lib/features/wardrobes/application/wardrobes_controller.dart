import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_wardrobe_repository.dart';
import '../domain/wardrobe.dart';
import '../domain/wardrobe_repository.dart';
import 'wardrobes_state.dart';

/// Loads and maintains the authenticated user's wardrobe list.
class WardrobesController extends Notifier<WardrobesState> {
  @override
  WardrobesState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const WardrobesState();
    }
    Future<void>.microtask(refresh);
    return const WardrobesState(isLoading: true);
  }

  WardrobeRepository get _repository => ref.read(wardrobeRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final wardrobes = await _repository.listWardrobes();
      state = state.copyWith(isLoading: false, wardrobes: wardrobes);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void upsert(Wardrobe wardrobe) {
    final next = [...state.wardrobes];
    final index = next.indexWhere((item) => item.id == wardrobe.id);
    if (index >= 0) {
      next[index] = wardrobe;
    } else {
      next.add(wardrobe);
    }
    state = state.copyWith(wardrobes: next, clearError: true);
  }

  void remove(String id) {
    state = state.copyWith(
      wardrobes: [
        for (final wardrobe in state.wardrobes)
          if (wardrobe.id != id) wardrobe,
      ],
      clearError: true,
    );
  }

  /// Drops the in-memory list after a successful `DELETE /me/content`.
  void clearLocal() {
    state = state.copyWith(wardrobes: const [], clearError: true);
  }
}

/// Submits a new wardrobe and keeps the list cache in sync.
class CreateWardrobeController extends Notifier<CreateWardrobeState> {
  @override
  CreateWardrobeState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const CreateWardrobeState();
  }

  WardrobeRepository get _repository => ref.read(wardrobeRepositoryProvider);

  Future<Wardrobe?> submit({required String name}) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final wardrobe = await _repository.createWardrobe(name: name.trim());
      ref.read(wardrobesControllerProvider.notifier).upsert(wardrobe);
      state = state.copyWith(isSaving: false);
      return wardrobe;
    } on ApiException catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return null;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }
}

final wardrobesControllerProvider =
    NotifierProvider<WardrobesController, WardrobesState>(
      WardrobesController.new,
    );

final createWardrobeControllerProvider =
    NotifierProvider<CreateWardrobeController, CreateWardrobeState>(
      CreateWardrobeController.new,
    );
