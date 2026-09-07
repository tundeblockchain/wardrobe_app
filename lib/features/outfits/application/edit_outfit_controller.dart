import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../items/domain/item.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';
import '../domain/outfit_repository.dart';
import '../domain/outfit_validators.dart';
import 'edit_outfit_state.dart';
import 'outfit_detail_controller.dart';
import 'outfit_scope.dart';
import 'outfits_controller.dart';

/// Updates an outfit name and slot assignments.
class EditOutfitController extends Notifier<EditOutfitState> {
  EditOutfitController(this.scope);

  final OutfitScope scope;

  @override
  EditOutfitState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    ref.listen(outfitDetailControllerProvider(scope), (previous, next) {
      final outfit = next.outfit;
      if (!state.hasSeeded && outfit != null) {
        state = state.copyWith(items: outfit.items, hasSeeded: true);
      }
    });
    final existing = ref.read(outfitDetailControllerProvider(scope)).outfit;
    if (existing != null) {
      return EditOutfitState(items: existing.items, hasSeeded: true);
    }
    return const EditOutfitState();
  }

  OutfitRepository get _repository => ref.read(outfitRepositoryProvider);

  void seed(Outfit outfit) {
    if (state.hasSeeded) {
      return;
    }
    state = state.copyWith(items: outfit.items, hasSeeded: true);
  }

  void assign({required ItemCategory slot, required String itemId}) {
    state = state.copyWith(
      items: assignOutfitItem(
        current: state.items,
        assignment: OutfitItem(itemId: itemId, slot: slot),
      ),
      clearError: true,
    );
  }

  void clearSlot(ItemCategory slot) {
    state = state.copyWith(
      items: clearOutfitSlot(current: state.items, slot: slot),
      clearError: true,
    );
  }

  Future<Outfit?> submit({required String name}) async {
    final nameError = OutfitValidators.name(name);
    if (nameError != null) {
      state = state.copyWith(errorMessage: nameError);
      return null;
    }
    final itemsError = OutfitValidators.items(state.items);
    if (itemsError != null) {
      state = state.copyWith(errorMessage: itemsError);
      return null;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final outfit = await _repository.updateOutfit(
        wardrobeId: scope.wardrobeId,
        outfitId: scope.outfitId,
        name: name.trim(),
        items: state.items,
      );
      if (!ref.mounted) {
        return outfit;
      }
      ref
          .read(outfitsControllerProvider(scope.wardrobeId).notifier)
          .upsert(outfit);
      ref.read(outfitDetailControllerProvider(scope).notifier).replace(outfit);
      state = state.copyWith(isSaving: false);
      return outfit;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(isSaving: false, errorMessage: error.message);
      return null;
    } catch (_) {
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }
}

final editOutfitControllerProvider =
    NotifierProvider.family<EditOutfitController, EditOutfitState, OutfitScope>(
      EditOutfitController.new,
    );
