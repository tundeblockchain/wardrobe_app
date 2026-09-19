import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../entitlements/application/entitlements_controller.dart';
import '../../entitlements/domain/paywall_placement.dart';
import '../data/dio_item_repository.dart';
import '../domain/item.dart';
import '../domain/item_repository.dart';
import '../domain/item_reprocess.dart';
import '../domain/item_transfer.dart';
import 'item_detail_state.dart';
import 'item_local_preview_cache.dart';
import 'item_processing_poll.dart';
import 'item_scope.dart';
import 'items_controller.dart';

/// Loads a clothing item and handles delete / reprocess.
class ItemDetailController extends Notifier<ItemDetailState> {
  ItemDetailController(this.scope);

  final ItemScope scope;

  @override
  ItemDetailState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const ItemDetailState();
    }
    ref.listen<int>(appLifecycleTickProvider, (previous, next) {
      if (previous != null && previous != next) {
        refresh();
      }
    });
    final cached = _itemFromListCache();
    Future<void>.microtask(refresh);
    if (cached != null) {
      return ItemDetailState(item: cached);
    }
    return const ItemDetailState(isLoading: true);
  }

  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  Item? _itemFromListCache() {
    final items = ref.read(itemsControllerProvider(scope.wardrobeId)).items;
    for (final item in items) {
      if (item.id == scope.itemId) {
        return item;
      }
    }
    return null;
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: state.item == null, clearError: true);
    try {
      final item = await _repository.getItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, item: item);
      _publishToList(item);
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

  void replace(Item item) {
    state = state.copyWith(item: item, isLoading: false, clearError: true);
    _publishToList(item);
  }

  void clearSnackMessage() {
    if (state.snackMessage != null) {
      state = state.copyWith(clearSnack: true);
    }
  }

  void _publishToList(Item item) {
    ref.read(itemsControllerProvider(scope.wardrobeId).notifier).upsert(item);
  }

  /// One-tap retry for FAILED image / AI processing (WARDROBE-124).
  Future<bool> reprocess() async {
    final current = state.item;
    if (current == null) {
      return false;
    }
    if (state.isReprocessing || state.isPolling) {
      return state.isPolling;
    }
    if (!current.processingStatus.canReprocess) {
      return false;
    }

    state = state.copyWith(
      isReprocessing: true,
      clearError: true,
      clearSnack: true,
    );
    try {
      final item = await _repository.reprocessItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      if (!ref.mounted) {
        return false;
      }
      _applyPending(item);
      await _pollUntilDone();
      return state.item?.processingStatus.isTerminal == true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      if (ItemReprocessErrorCodes.isProcessingInProgress(error)) {
        state = state.copyWith(isReprocessing: false, isPolling: true);
        await _refreshThenPoll();
        return state.item?.processingStatus.isTerminal == true;
      }
      queueEntitlementPaywall(ref, error, fallback: PaywallPlacement.otherAi);
      state = state.copyWith(
        isReprocessing: false,
        isPolling: false,
        snackMessage: ItemReprocessErrorCodes.snackMessage(error),
      );
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isReprocessing: false,
        isPolling: false,
        snackMessage: 'Could not retry processing. Please try again.',
      );
      return false;
    }
  }

  void _applyPending(Item item) {
    state = state.copyWith(
      item: item,
      isReprocessing: false,
      isPolling: true,
      clearError: true,
      clearSnack: true,
    );
    _publishToList(item);
  }

  Future<void> _refreshThenPoll() async {
    try {
      final item = await _repository.getItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      if (!ref.mounted) {
        return;
      }
      replace(item);
      if (item.processingStatus.isTerminal) {
        state = state.copyWith(isPolling: false);
        return;
      }
      await _pollUntilDone();
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isPolling: false, snackMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isPolling: false,
        snackMessage: 'Could not check processing status. Please try again.',
      );
    }
  }

  Future<void> _pollUntilDone() async {
    state = state.copyWith(isPolling: true);
    try {
      await pollItemProcessing(
        fetch: () => _repository.getItem(
          wardrobeId: scope.wardrobeId,
          itemId: scope.itemId,
        ),
        config: ref.read(itemProcessingPollConfigProvider),
        delay: ref.read(itemProcessingDelayProvider),
        isMounted: () => ref.mounted,
        initial: state.item,
        onUpdate: (item) {
          if (!ref.mounted) {
            return;
          }
          replace(item);
        },
      );
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(snackMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        snackMessage: 'Could not check processing status. Please try again.',
      );
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isReprocessing: false, isPolling: false);
      }
    }
  }

  Future<bool> delete() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      if (!ref.mounted) {
        return true;
      }
      ref
          .read(itemsControllerProvider(scope.wardrobeId).notifier)
          .remove(scope.itemId);
      state = state.copyWith(isSaving: false, isDeleted: true, clearItem: true);
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

  Future<Item?> moveTo(String targetWardrobeId) {
    return _transfer(ItemTransferKind.move, targetWardrobeId);
  }

  Future<Item?> copyTo(String targetWardrobeId) {
    return _transfer(ItemTransferKind.copy, targetWardrobeId);
  }

  Future<Item?> _transfer(
    ItemTransferKind kind,
    String targetWardrobeId,
  ) async {
    final trimmedTarget = targetWardrobeId.trim();
    if (trimmedTarget.isEmpty || trimmedTarget == scope.wardrobeId) {
      state = state.copyWith(errorMessage: ItemTransferMessages.sameWardrobe);
      return null;
    }
    final current = state.item;
    if (current != null && !canTransferItem(current)) {
      state = state.copyWith(errorMessage: ItemTransferMessages.processing);
      return null;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final item = kind == ItemTransferKind.move
          ? await _repository.moveItem(
              wardrobeId: scope.wardrobeId,
              itemId: scope.itemId,
              targetWardrobeId: trimmedTarget,
            )
          : await _repository.copyItem(
              wardrobeId: scope.wardrobeId,
              itemId: scope.itemId,
              targetWardrobeId: trimmedTarget,
            );
      if (!ref.mounted) {
        return item;
      }
      await _publishTransfer(kind, item);
      state = state.copyWith(isSaving: false, clearError: true);
      return item;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      if (kind.countsTowardItemLimit) {
        queueEntitlementPaywall(
          ref,
          error,
          fallback: PaywallPlacement.itemLimit,
        );
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: mapItemTransferError(error, kind: kind),
      );
      return null;
    } catch (_) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: ItemTransferMessages.failed(kind),
      );
      return null;
    }
  }

  Future<void> _publishTransfer(ItemTransferKind kind, Item item) async {
    if (kind == ItemTransferKind.move) {
      ref
          .read(itemsControllerProvider(scope.wardrobeId).notifier)
          .remove(scope.itemId);
      ref.read(itemsControllerProvider(item.wardrobeId).notifier).upsert(item);
      return;
    }
    ref.read(itemsControllerProvider(item.wardrobeId).notifier).upsert(item);
    final preview = ref.read(itemLocalPreviewCacheProvider)[scope.itemId];
    if (preview != null) {
      ref.read(itemLocalPreviewCacheProvider.notifier).store(item.id, preview);
    }
    // Copy counts as a catalog create — refresh GET /me when the app binder
    // already owns EntitlementsController (skip constructing it in unit tests).
    if (ref.exists(entitlementsControllerProvider)) {
      await ref.read(entitlementsControllerProvider.notifier).refresh();
    }
  }
}

final itemDetailControllerProvider =
    NotifierProvider.family<ItemDetailController, ItemDetailState, ItemScope>(
      ItemDetailController.new,
    );
