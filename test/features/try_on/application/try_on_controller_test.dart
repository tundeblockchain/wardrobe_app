import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_scope.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/try_on/application/try_on_controller.dart';
import 'package:wardrobe_app/features/try_on/application/try_on_poll.dart';

import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  const scope = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'outfit_123');

  late FakeOutfitRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeOutfitRepository(seed: [testOutfit()]);
    container = ProviderContainer.test(
      overrides: [
        outfitRepositoryProvider.overrideWithValue(repository),
        tryOnPollConfigProvider.overrideWithValue(
          const TryOnPollConfig(
            interval: Duration.zero,
            timeout: Duration(minutes: 1),
          ),
        ),
        tryOnDelayProvider.overrideWithValue((_) async {}),
      ],
    );
    container
        .read(selectedAiProfileProvider.notifier)
        .select(testGenericModel());
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads outfit and existing render', () async {
    repository.outfits[0] = testOutfit(
      render: testOutfitRender(status: OutfitRenderStatus.ready),
    );

    container.read(tryOnControllerProvider(scope));
    await settle();

    final state = container.read(tryOnControllerProvider(scope));
    expect(state.outfit?.id, 'outfit_123');
    expect(state.render?.status, OutfitRenderStatus.ready);
    expect(state.render?.imageUrl, contains('cdn.example.com'));
    expect(state.isLoading, isFalse);
  });

  test('submit posts then polls PENDING → PROCESSING → READY', () async {
    repository.renderPollQueue.addAll([
      testOutfitRender(status: OutfitRenderStatus.pending, imageKey: null),
      testOutfitRender(status: OutfitRenderStatus.processing, imageKey: null),
      testOutfitRender(status: OutfitRenderStatus.ready),
    ]);

    container.read(tryOnControllerProvider(scope));
    await settle();

    final ok = await container
        .read(tryOnControllerProvider(scope).notifier)
        .submit();

    expect(ok, isTrue);
    expect(repository.requestRenderCalls, 1);
    expect(repository.lastAiProfileId, 'profile_generic_01');
    expect(repository.getRenderCalls, 3);
    final state = container.read(tryOnControllerProvider(scope));
    expect(state.render?.status, OutfitRenderStatus.ready);
    expect(
      state.render?.imageUrl,
      'https://cdn.example.com/try-on/outfit_123.png',
    );
    expect(state.isPolling, isFalse);
  });

  test('submit surfaces FAILED render error', () async {
    repository.renderPollQueue.add(
      testOutfitRender(
        status: OutfitRenderStatus.failed,
        imageKey: null,
        error: 'Profile is not ready.',
      ),
    );

    container.read(tryOnControllerProvider(scope));
    await settle();

    final ok = await container
        .read(tryOnControllerProvider(scope).notifier)
        .submit();

    expect(ok, isFalse);
    expect(
      container.read(tryOnControllerProvider(scope)).errorMessage,
      'Profile is not ready.',
    );
    expect(
      container.read(tryOnControllerProvider(scope)).render?.status,
      OutfitRenderStatus.failed,
    );
  });

  test('timeout stops polling with a friendly message', () async {
    final timed = ProviderContainer.test(
      overrides: [
        outfitRepositoryProvider.overrideWithValue(repository),
        tryOnPollConfigProvider.overrideWithValue(
          const TryOnPollConfig(
            interval: Duration.zero,
            timeout: Duration.zero,
          ),
        ),
        tryOnDelayProvider.overrideWithValue((_) async {}),
      ],
    );
    addTearDown(timed.dispose);
    timed.read(selectedAiProfileProvider.notifier).select(testGenericModel());

    timed.read(tryOnControllerProvider(scope));
    await settle();

    await timed.read(tryOnControllerProvider(scope).notifier).submit();

    expect(
      timed.read(tryOnControllerProvider(scope)).errorMessage,
      contains('taking longer than expected'),
    );
    expect(repository.getRenderCalls, 0);
  });

  test('blocks submit when no profile is selected', () async {
    container.read(selectedAiProfileProvider.notifier).clear();
    container.read(tryOnControllerProvider(scope));
    await settle();

    final ok = await container
        .read(tryOnControllerProvider(scope).notifier)
        .submit();

    expect(ok, isFalse);
    expect(repository.requestRenderCalls, 0);
    expect(
      container.read(tryOnControllerProvider(scope)).errorMessage,
      'Pick an AI profile to try this outfit on.',
    );
  });

  test('maps requestRender ApiException', () async {
    repository.nextFailure = const ApiException(
      message: 'This profile is not ready.',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );
    container.read(tryOnControllerProvider(scope));
    await settle();
    repository.nextFailure = const ApiException(
      message: 'This profile is not ready.',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );

    final ok = await container
        .read(tryOnControllerProvider(scope).notifier)
        .submit();

    expect(ok, isFalse);
    expect(
      container.read(tryOnControllerProvider(scope)).errorMessage,
      'This profile is not ready.',
    );
  });

  test('tryOnBlockReason rejects PERSONAL without photos', () {
    expect(
      tryOnBlockReason(testPersonalProfile()),
      'Add a reference photo to your profile first.',
    );
    expect(tryOnBlockReason(testGenericModel()), isNull);
    expect(
      tryOnBlockReason(
        testPersonalProfile(referenceImages: const ['users/uid/ref.jpg']),
      ),
      isNull,
    );
  });
}
