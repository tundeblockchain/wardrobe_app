import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/ai_profiles/application/generic_models_controller.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';

import '../../../helpers/fake_ai_profile_repository.dart';

void main() {
  late FakeAiProfileRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAiProfileRepository();
    container = ProviderContainer.test(
      overrides: [aiProfileRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads the seeded GENERIC_MODEL catalog', () async {
    container.read(genericModelsControllerProvider);
    await settle();

    final state = container.read(genericModelsControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.models, hasLength(4));
    expect(state.models.map((model) => model.id), [
      'profile_generic_01',
      'profile_generic_02',
      'profile_generic_03',
      'profile_generic_04',
    ]);
    expect(state.models.map((model) => model.label), [
      'Alex',
      'Jordan',
      'Sam',
      'Riley',
    ]);
    expect(repository.listModelsCalls, 1);
  });

  test('refresh records ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(genericModelsControllerProvider);
    await settle();

    expect(
      container.read(genericModelsControllerProvider).errorMessage,
      contains('connection'),
    );
  });
}
