import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../ai_profiles/application/selected_ai_profile.dart';
import '../../ai_profiles/domain/ai_profile.dart';
import '../../outfits/application/outfit_detail_controller.dart';
import '../../outfits/application/outfit_hero_selection.dart';
import '../../outfits/application/outfit_scope.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../outfits/data/dio_outfit_repository.dart';
import '../../outfits/domain/outfit.dart';
import '../../outfits/domain/outfit_cover.dart';
import '../../outfits/domain/outfit_render.dart';
import '../../outfits/domain/outfit_repository.dart';
import '../../outfits/domain/try_on_history.dart';
import 'try_on_poll.dart';
import 'try_on_state.dart';

/// Client-side reason a selected profile cannot be sent to POST `/render`.
String? tryOnBlockReason(AiProfile? profile) {
  if (profile == null) {
    return 'Pick an AI profile to try this outfit on.';
  }
  if (profile.status != AiProfileStatus.ready) {
    return 'This profile is not ready yet.';
  }
  if (profile.isPersonal && profile.referenceImages.isEmpty) {
    return 'Add a reference photo to your profile first.';
  }
  if (!profile.canUseForTryOn) {
    return 'Choose a ready personal profile or a try-on model.';
  }
  return null;
}

/// Loads an outfit, requests a render, and polls GET `/render`.
class TryOnController extends Notifier<TryOnState> {
  TryOnController(this.scope);

  final OutfitScope scope;

  bool _polling = false;

  @override
  TryOnState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const TryOnState();
    }
    Future<void>.microtask(() async {
      await refresh();
      if (!ref.mounted) {
        return;
      }
      if (state.render?.status.isInProgress == true) {
        await _pollUntilDone();
      }
    });
    return const TryOnState(isLoading: true);
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
      state = state.copyWith(
        isLoading: false,
        outfit: outfit,
        render: outfit.render,
        clearRender: outfit.render == null,
      );
      _publishOutfit(outfit, selectLatestHero: true);
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

  Future<bool> submit() async {
    final blocked = tryOnBlockReason(ref.read(selectedAiProfileProvider));
    if (blocked != null) {
      state = state.copyWith(errorMessage: blocked);
      return false;
    }
    final profile = ref.read(selectedAiProfileProvider)!;
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final outfit = await _repository.requestRender(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
        aiProfileId: profile.id,
      );
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSubmitting: false,
        outfit: outfit,
        render: outfit.render,
        clearRender: outfit.render == null,
      );
      _publishOutfit(outfit);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Could not start try-on. Please try again.',
      );
      return false;
    }
    if (state.render?.status.isTerminal == true) {
      if (state.isReady) {
        await _refreshHistoryFromOutfit();
      }
      return state.isReady;
    }
    await _pollUntilDone();
    return state.isReady;
  }

  Future<void> _pollUntilDone() async {
    if (_polling) {
      return;
    }
    _polling = true;
    state = state.copyWith(isPolling: true, clearError: true);
    final config = ref.read(tryOnPollConfigProvider);
    final delay = ref.read(tryOnDelayProvider);
    final deadline = DateTime.now().add(config.timeout);
    try {
      while (ref.mounted) {
        final current = state.render;
        if (current == null || current.status.isTerminal) {
          return;
        }
        if (!DateTime.now().isBefore(deadline)) {
          state = state.copyWith(
            errorMessage:
                'Try-on is taking longer than expected. Try again in a moment.',
          );
          return;
        }
        await delay(config.interval);
        if (!ref.mounted) {
          return;
        }
        try {
          final next = await _repository.getRender(
            wardrobeId: scope.wardrobeId,
            outfitId: scope.outfitId,
          );
          if (!ref.mounted) {
            return;
          }
          final outfit = state.outfit?.copyWith(render: next);
          state = state.copyWith(
            render: next,
            outfit: outfit,
            errorMessage: next.status == OutfitRenderStatus.failed
                ? (next.error ?? 'Try-on failed. Please try again.')
                : null,
            clearError: next.status != OutfitRenderStatus.failed,
          );
          if (outfit != null) {
            _publishOutfit(outfit);
            if (next.hasDisplayImage) {
              await _refreshHistoryFromOutfit();
            }
          }
        } on ApiException catch (error) {
          if (!ref.mounted) {
            return;
          }
          state = state.copyWith(errorMessage: error.message);
          return;
        } catch (_) {
          if (!ref.mounted) {
            return;
          }
          state = state.copyWith(
            errorMessage: 'Could not check try-on status. Please try again.',
          );
          return;
        }
      }
    } finally {
      _polling = false;
      if (ref.mounted) {
        state = state.copyWith(isPolling: false);
      }
    }
  }

  /// Push list/detail heroes from the outfit DTO (including prior history).
  void _publishOutfit(Outfit outfit, {bool selectLatestHero = false}) {
    final withLatest = _withLatestGalleryUrl(outfit);
    ref
        .read(outfitsControllerProvider(scope.wardrobeId).notifier)
        .upsert(withLatest);
    ref
        .read(outfitDetailControllerProvider(scope).notifier)
        .replace(withLatest);
    if (selectLatestHero) {
      final hero = latestOutfitTryOnUrl(withLatest);
      if (hero != null) {
        ref.read(outfitHeroSelectionProvider(scope).notifier).select(hero);
      }
    }
  }

  Future<void> _refreshHistoryFromOutfit() async {
    try {
      final fresh = await _repository.getOutfit(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        outfit: fresh,
        render: fresh.render,
        clearRender: fresh.render == null,
      );
      _publishOutfit(fresh, selectLatestHero: true);
    } on ApiException {
      // Keep the polled render; gallery still has that URL.
    } catch (_) {
      // Same soft fallback as a missing history envelope.
    }
  }

  Outfit _withLatestGalleryUrl(Outfit outfit) {
    final url = presignedTryOnUrl(outfit.render?.imageUrl);
    if (url == null || outfit.renderImageUrls.contains(url)) {
      return outfit;
    }
    return outfit.copyWith(renderImageUrls: [url, ...outfit.renderImageUrls]);
  }
}

final tryOnControllerProvider =
    NotifierProvider.family<TryOnController, TryOnState, OutfitScope>(
      TryOnController.new,
    );
