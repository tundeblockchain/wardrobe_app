import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_ai_profile_repository.dart';
import '../domain/ai_profile_repository.dart';
import 'generic_models_state.dart';

/// Loads the seeded GENERIC_MODEL catalog for try-on prep.
class GenericModelsController extends Notifier<GenericModelsState> {
  @override
  GenericModelsState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const GenericModelsState();
    }
    Future<void>.microtask(refresh);
    return const GenericModelsState(isLoading: true);
  }

  AiProfileRepository get _repository => ref.read(aiProfileRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final models = await _repository.listGenericModels();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, models: models);
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

  void clearLocal() {
    state = state.copyWith(models: const [], clearError: true);
  }
}

final genericModelsControllerProvider =
    NotifierProvider<GenericModelsController, GenericModelsState>(
      GenericModelsController.new,
    );
