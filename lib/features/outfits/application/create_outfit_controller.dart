import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../items/domain/item.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';
import '../domain/outfit_repository.dart';
import '../domain/outfit_validators.dart';
import 'create_outfit_state.dart';
import 'outfits_controller.dart';

/// Picks wardrobe items into slots and creates an outfit.
class CreateOutfitController extends Notifier<CreateOutfitState> {
  CreateOutfitController(this.wardrobeId);

  final String wardrobeId;

  @override
  CreateOutfitState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const CreateOutfitState();
  }

  OutfitRepository get _repository => ref.read(outfitRepositoryProvider);

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
      final outfit = await _repository.createOutfit(
        wardrobeId: wardrobeId,
        name: name.trim(),
        items: state.items,
      );
      if (!ref.mounted) {
        return outfit;
      }
      ref.read(outfitsControllerProvider(wardrobeId).notifier).upsert(outfit);
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

final createOutfitControllerProvider =
    NotifierProvider.family<CreateOutfitController, CreateOutfitState, String>(
      CreateOutfitController.new,
    );
