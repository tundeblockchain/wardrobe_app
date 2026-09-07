import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_item_repository.dart';
import '../domain/item.dart';
import '../domain/item_list_filters.dart';
import '../domain/item_repository.dart';
import 'item_local_preview_cache.dart';
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
      final items = await _repository.listItems(
        wardrobeId,
        filters: state.filters,
      );
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

  Future<void> setFilters(ItemListFilters filters) async {
    if (state.filters == filters) {
      return;
    }
    state = state.copyWith(filters: filters);
    await refresh();
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
      clearError: true,
    );
  }
}

final itemsControllerProvider =
    NotifierProvider.family<ItemsController, ItemsState, String>(
      ItemsController.new,
    );
