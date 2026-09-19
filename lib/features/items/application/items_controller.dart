import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../entitlements/application/entitlements_controller.dart';
import '../../entitlements/domain/paywall_placement.dart';
import '../data/dio_item_repository.dart';
import '../domain/item.dart';
import '../domain/item_list_filters.dart';
import '../domain/item_reprocess.dart';
import '../domain/item_repository.dart';
import 'item_local_preview_cache.dart';
import 'item_processing_poll.dart';
import 'items_state.dart';

/// Loads and maintains clothing items for one wardrobe.
class ItemsController extends Notifier<ItemsState> {
  ItemsController(this.wardrobeId);

  final String wardrobeId;

  @override
  ItemsState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const ItemsState();
    }
    ref.listen<int>(appLifecycleTickProvider, (previous, next) {
      if (previous != null && previous != next) {
        refresh();
      }
    });
    Future<void>.microtask(refresh);
    return const ItemsState(isLoading: true);
  }

  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // WARDROBE-116: load the wardrobe deck, then filter in
      // [ItemsState.visibleItems]. Do not invent a search API.
      //
      // TODO(WARDROBE-116): if the loaded list is insufficient (very
      // large wardrobes), pass `state.filters.toQueryParameters()` to
      // `GET /wardrobes/{id}/items` (Backend GSI). Keep client [apply]
      // as an idempotent safety window over whatever the list returns.
      final items = await _repository.listItems(wardrobeId);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, items: items);
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

  /// Apply category / colour / tag chips over the already-loaded list.
  ///
  /// Does not refetch. Pull-to-refresh, resume, and route re-entry still
  /// reload the full deck; [ItemsState.visibleItems] reapplies [filters].
  Future<void> setFilters(ItemListFilters filters) async {
    if (state.filters == filters) {
      return;
    }
    state = state.copyWith(filters: filters);
  }

  void upsert(Item item) {
    final next = [...state.items];
    final index = next.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) {
      next[index] = item;
    } else {
      next.add(item);
    }
    state = state.copyWith(items: next, clearError: true);
  }

  void remove(String itemId) {
    ref.read(itemLocalPreviewCacheProvider.notifier).evict(itemId);
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id != itemId) item,
      ],
      reprocessingItemIds: {...state.reprocessingItemIds}..remove(itemId),
      pollingItemIds: {...state.pollingItemIds}..remove(itemId),
      clearError: true,
    );
  }

  void clearSnackMessage() {
    if (state.snackMessage != null) {
      state = state.copyWith(clearSnack: true);
    }
  }

  /// One-tap retry for a FAILED list tile (WARDROBE-124).
  Future<bool> reprocessItem(String itemId) async {
    Item? current;
    for (final item in state.items) {
      if (item.id == itemId) {
        current = item;
        break;
      }
    }
    if (current == null) {
      return false;
    }
    if (state.isReprocessing(itemId) || state.isPolling(itemId)) {
      return state.isPolling(itemId);
    }
    if (!current.processingStatus.canReprocess) {
      return false;
    }

    state = state.copyWith(
      reprocessingItemIds: {...state.reprocessingItemIds, itemId},
      clearError: true,
      clearSnack: true,
    );
    try {
      final item = await _repository.reprocessItem(
        wardrobeId: wardrobeId,
        itemId: itemId,
      );
      if (!ref.mounted) {
        return false;
      }
      _markPolling(item);
      await _pollUntilDone(itemId);
      return _itemById(itemId)?.processingStatus.isTerminal == true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      if (ItemReprocessErrorCodes.isProcessingInProgress(error)) {
        state = state.copyWith(
          reprocessingItemIds: {...state.reprocessingItemIds}..remove(itemId),
          pollingItemIds: {...state.pollingItemIds, itemId},
        );
        await _refreshThenPoll(itemId);
        return _itemById(itemId)?.processingStatus.isTerminal == true;
      }
      queueEntitlementPaywall(ref, error, fallback: PaywallPlacement.otherAi);
      state = state.copyWith(
        reprocessingItemIds: {...state.reprocessingItemIds}..remove(itemId),
        pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        snackMessage: ItemReprocessErrorCodes.snackMessage(error),
      );
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        reprocessingItemIds: {...state.reprocessingItemIds}..remove(itemId),
        pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        snackMessage: 'Could not retry processing. Please try again.',
      );
      return false;
    }
  }

  Item? _itemById(String itemId) {
    for (final item in state.items) {
      if (item.id == itemId) {
        return item;
      }
    }
    return null;
  }

  void _markPolling(Item item) {
    upsert(item);
    state = state.copyWith(
      reprocessingItemIds: {...state.reprocessingItemIds}..remove(item.id),
      pollingItemIds: {...state.pollingItemIds, item.id},
    );
  }

  Future<void> _refreshThenPoll(String itemId) async {
    try {
      final item = await _repository.getItem(
        wardrobeId: wardrobeId,
        itemId: itemId,
      );
      if (!ref.mounted) {
        return;
      }
      upsert(item);
      if (item.processingStatus.isTerminal) {
        state = state.copyWith(
          pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        );
        return;
      }
      await _pollUntilDone(itemId);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        snackMessage: error.message,
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        snackMessage: 'Could not check processing status. Please try again.',
      );
    }
  }

  Future<void> _pollUntilDone(String itemId) async {
    state = state.copyWith(pollingItemIds: {...state.pollingItemIds, itemId});
    try {
      await pollItemProcessing(
        fetch: () =>
            _repository.getItem(wardrobeId: wardrobeId, itemId: itemId),
        config: ref.read(itemProcessingPollConfigProvider),
        delay: ref.read(itemProcessingDelayProvider),
        isMounted: () => ref.mounted,
        initial: _itemById(itemId),
        onUpdate: (item) {
          if (!ref.mounted) {
            return;
          }
          upsert(item);
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
        state = state.copyWith(
          reprocessingItemIds: {...state.reprocessingItemIds}..remove(itemId),
          pollingItemIds: {...state.pollingItemIds}..remove(itemId),
        );
      }
    }
  }

  /// `DELETE /wardrobes/{id}/items/{itemId}` then drop the row from the list.
  Future<bool> deleteItem(String itemId) async {
    try {
      await _repository.deleteItem(wardrobeId: wardrobeId, itemId: itemId);
      if (!ref.mounted) {
        return true;
      }
      remove(itemId);
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

final itemsControllerProvider =
    NotifierProvider.family<ItemsController, ItemsState, String>(
      ItemsController.new,
    );
