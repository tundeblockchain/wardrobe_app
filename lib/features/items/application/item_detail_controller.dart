import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_item_repository.dart';
import '../domain/item.dart';
import '../domain/item_repository.dart';
import 'item_detail_state.dart';
import 'item_processing_poll.dart';
import 'item_scope.dart';
import 'items_controller.dart';

/// Loads a clothing item and handles delete.
class ItemDetailController extends Notifier<ItemDetailState> {
  ItemDetailController(this.scope);

  final ItemScope scope;

  bool _polling = false;

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
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, item: item);
      _publishToList(item);
      _schedulePollIfNeeded();
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
    state = state.copyWith(item: item, clearError: true);
    _publishToList(item);
    _schedulePollIfNeeded();
  }

  void _publishToList(Item item) {
    ref.read(itemsControllerProvider(scope.wardrobeId).notifier).upsert(item);
  }

  void _schedulePollIfNeeded() {
    if (state.item?.processingStatus.isInProgress == true) {
      unawaited(_pollUntilSettled());
    }
  }

  Future<void> _pollUntilSettled() async {
    if (_polling) {
      return;
    }
    _polling = true;
    final config = ref.read(itemProcessingPollConfigProvider);
    final delay = ref.read(itemProcessingDelayProvider);
    final deadline = DateTime.now().add(config.timeout);
    try {
      while (ref.mounted) {
        final current = state.item;
        if (current == null || current.processingStatus.isTerminal) {
          return;
        }
        if (!current.processingStatus.isInProgress) {
          return;
        }
        if (!DateTime.now().isBefore(deadline)) {
          return;
        }
        await delay(config.interval);
        if (!ref.mounted) {
          return;
        }
        try {
          final item = await _repository.getItem(
            wardrobeId: scope.wardrobeId,
            itemId: scope.itemId,
          );
          if (!ref.mounted) {
            return;
          }
          state = state.copyWith(item: item);
          _publishToList(item);
        } on ApiException {
          return;
        } catch (_) {
          return;
        }
      }
    } finally {
      _polling = false;
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
}

final itemDetailControllerProvider =
    NotifierProvider.family<ItemDetailController, ItemDetailState, ItemScope>(
      ItemDetailController.new,
    );
