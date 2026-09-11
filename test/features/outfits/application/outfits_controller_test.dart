import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  late FakeOutfitRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeOutfitRepository();
    container = ProviderContainer.test(
      overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads outfits for the wardrobe', () async {
    repository.outfits.add(testOutfit());

    final first = container.read(outfitsControllerProvider('wd_abc123'));
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(outfitsControllerProvider('wd_abc123'));
    expect(state.isLoading, isFalse);
    expect(state.outfits, hasLength(1));
    expect(state.outfits.single.id, 'outfit_123');
    expect(repository.listCalls, 1);
  });

  test('refresh records ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(outfitsControllerProvider('wd_abc123'));
    await settle();

    expect(
      container.read(outfitsControllerProvider('wd_abc123')).errorMessage,
      contains('connection'),
    );
  });

  test('refresh hydrates READY list rows from GET /render', () async {
    repository.outfits.add(
      testOutfit(render: testOutfitRender(imageUrl: null)),
    );
    repository.renderPollQueue.add(
      testOutfitRender(imageUrl: 'https://cdn.example.com/try-on/hydrated.png'),
    );

    container.read(outfitsControllerProvider('wd_abc123'));
    await settle();

    final state = container.read(outfitsControllerProvider('wd_abc123'));
    expect(repository.listCalls, 1);
    expect(repository.getRenderCalls, 1);
    expect(
      state.outfits.single.render?.imageUrl,
      'https://cdn.example.com/try-on/hydrated.png',
    );
  });

  test('deleteOutfit calls DELETE and removes the list row', () async {
    repository.outfits.add(testOutfit());
    container.read(outfitsControllerProvider('wd_abc123'));
    await settle();

    final ok = await container
        .read(outfitsControllerProvider('wd_abc123').notifier)
        .deleteOutfit('outfit_123');

    expect(ok, isTrue);
    expect(repository.deleteCalls, 1);
    expect(
      container.read(outfitsControllerProvider('wd_abc123')).outfits,
      isEmpty,
    );
  });

  test(
    'deleteOutfit failure surfaces ApiException without removing the row',
    () async {
      repository.outfits.add(testOutfit());
      container.read(outfitsControllerProvider('wd_abc123'));
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Outfit not found.',
        code: 'OUTFIT_NOT_FOUND',
      );

      final ok = await container
          .read(outfitsControllerProvider('wd_abc123').notifier)
          .deleteOutfit('outfit_123');

      expect(ok, isFalse);
      expect(
        container.read(outfitsControllerProvider('wd_abc123')).errorMessage,
        'Outfit not found.',
      );
      expect(
        container.read(outfitsControllerProvider('wd_abc123')).outfits,
        hasLength(1),
      );
    },
  );
}
