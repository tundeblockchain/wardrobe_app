import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/dio_item_repository.dart';
import '../domain/item.dart';
import '../domain/item_repository.dart';
import 'items_state.dart';

/// Loads and maintains clothing items for one wardrobe.
class ItemsController extends Notifier<ItemsState> {
  ItemsController(this.wardrobeId);

  final String wardrobeId;

  @override
  ItemsState build() {
    Future<void>.microtask(refresh);
    return const ItemsState(isLoading: true);
  }

  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = await _repository.listItems(wardrobeId);
      state = state.copyWith(isLoading: false, items: items);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
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
