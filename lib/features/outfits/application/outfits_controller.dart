import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';
import '../domain/outfit_cover.dart';
import '../domain/outfit_render.dart';
import '../domain/outfit_repository.dart';
import 'outfits_state.dart';

/// Loads and maintains outfits for one wardrobe.
class OutfitsController extends Notifier<OutfitsState> {
  OutfitsController(this.wardrobeId);

  final String wardrobeId;

  @override
  OutfitsState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const OutfitsState();
    }
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
      final hydrated = await _hydrateTryOnUrls(outfits);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, outfits: hydrated);
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

  /// List omits `render.imageUrl`; fill READY rows from GET `/render`.
  Future<List<Outfit>> _hydrateTryOnUrls(List<Outfit> outfits) async {
    return Future.wait([for (final outfit in outfits) _hydrateOne(outfit)]);
  }

  Future<Outfit> _hydrateOne(Outfit outfit) async {
    if (outfitPreviewImageUrl(outfit) != null) {
      return outfit;
    }
    final render = outfit.render;
    if (render == null) {
      return outfit;
    }
    final hasKey = render.imageKey?.trim().isNotEmpty == true;
    if (render.status != OutfitRenderStatus.ready && !hasKey) {
      return outfit;
    }
    try {
      final latest = await _repository.getRender(
        wardrobeId: wardrobeId,
        outfitId: outfit.id,
      );
      if (latest.hasDisplayImage) {
        return outfit.copyWith(render: latest);
      }
    } on ApiException {
      // Keep the list row; cards fall back to an item photo or hanger.
    } catch (_) {
      // Same soft fallback as a missing presigned URL.
    }
    return outfit;
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

  /// `DELETE /wardrobes/{id}/outfits/{outfitId}` then drop the row from the list.
  Future<bool> deleteOutfit(String outfitId) async {
    try {
      await _repository.deleteOutfit(
        wardrobeId: wardrobeId,
        outfitId: outfitId,
      );
      if (!ref.mounted) {
        return true;
      }
      remove(outfitId);
      return true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }
}

final outfitsControllerProvider =
    NotifierProvider.family<OutfitsController, OutfitsState, String>(
      OutfitsController.new,
    );
