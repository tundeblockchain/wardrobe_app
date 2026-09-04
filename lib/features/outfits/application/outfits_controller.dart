import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';
import '../domain/outfit_repository.dart';
import 'outfits_state.dart';

/// Loads and maintains outfits for one wardrobe.
class OutfitsController extends Notifier<OutfitsState> {
  OutfitsController(this.wardrobeId);

  final String wardrobeId;

  @override
  OutfitsState build() {
    Future<void>.microtask(refresh);
    return const OutfitsState(isLoading: true);
  }

  OutfitRepository get _repository => ref.read(outfitRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final outfits = await _repository.listOutfits(wardrobeId);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, outfits: outfits);
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

  void upsert(Outfit outfit) {
    final next = [...state.outfits];
    final index = next.indexWhere((existing) => existing.id == outfit.id);
    if (index >= 0) {
      next[index] = outfit;
    } else {
      next.add(outfit);
    }
    state = state.copyWith(outfits: next, clearError: true);
  }

  void remove(String outfitId) {
    state = state.copyWith(
      outfits: [
        for (final outfit in state.outfits)
          if (outfit.id != outfitId) outfit,
      ],
      clearError: true,
    );
  }
}

final outfitsControllerProvider =
    NotifierProvider.family<OutfitsController, OutfitsState, String>(
      OutfitsController.new,
    );
