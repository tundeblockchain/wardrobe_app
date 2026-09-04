import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/dio_item_repository.dart';
import '../domain/item_repository.dart';
import 'item_detail_state.dart';
import 'item_scope.dart';
import 'items_controller.dart';

/// Loads a clothing item and handles delete.
class ItemDetailController extends Notifier<ItemDetailState> {
  ItemDetailController(this.scope);

  final ItemScope scope;

  @override
  ItemDetailState build() {
    Future<void>.microtask(refresh);
    return const ItemDetailState(isLoading: true);
  }

  ItemRepository get _repository => ref.read(itemRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final item = await _repository.getItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      state = state.copyWith(isLoading: false, item: item);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void replace(Item item) {
    state = state.copyWith(item: item, clearError: true);
  }

  Future<bool> delete() async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteItem(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      );
      ref
          .read(itemsControllerProvider(scope.wardrobeId).notifier)
          .remove(scope.itemId);
      state = state.copyWith(isSaving: false, isDeleted: true, clearItem: true);
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

final itemDetailControllerProvider =
    NotifierProvider.family<ItemDetailController, ItemDetailState, ItemScope>(
      ItemDetailController.new,
    );
