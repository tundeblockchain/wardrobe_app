import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeWardrobeRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeWardrobeRepository();
    container = ProviderContainer.test(
      overrides: [wardrobeRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads wardrobes from the repository', () async {
    repository.items.add(testWardrobe());

    final first = container.read(wardrobesControllerProvider);
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(wardrobesControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.wardrobes, hasLength(1));
    expect(state.wardrobes.single.id, 'wd_abc123');
    expect(repository.listCalls, 1);
  });

  test('refresh records ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(wardrobesControllerProvider);
    await settle();

    final state = container.read(wardrobesControllerProvider);
    expect(state.errorMessage, contains('connection'));
    expect(state.wardrobes, isEmpty);
  });

  test('create submits and upserts into the list', () async {
    container.read(wardrobesControllerProvider);
    await settle();

    final created = await container
        .read(createWardrobeControllerProvider.notifier)
        .submit(name: '  Home  ');

    expect(created?.name, 'Home');
    expect(created?.id, 'wd_1');
    expect(
      container.read(wardrobesControllerProvider).wardrobes.single.name,
      'Home',
    );
    expect(container.read(createWardrobeControllerProvider).isSaving, isFalse);
  });

  test('deleteWardrobe calls DELETE and removes the list row', () async {
    repository.items.add(testWardrobe());
    container.read(wardrobesControllerProvider);
    await settle();

    final ok = await container
        .read(wardrobesControllerProvider.notifier)
        .deleteWardrobe('wd_abc123');

    expect(ok, isTrue);
    expect(repository.deleteCalls, 1);
    expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
  });

  test(
    'deleteWardrobe failure surfaces ApiException without removing the row',
    () async {
      repository.items.add(testWardrobe());
      container.read(wardrobesControllerProvider);
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Wardrobe not found.',
        code: 'WARDROBE_NOT_FOUND',
      );

      final ok = await container
          .read(wardrobesControllerProvider.notifier)
          .deleteWardrobe('wd_abc123');

      expect(ok, isFalse);
      expect(
        container.read(wardrobesControllerProvider).errorMessage,
        'Wardrobe not found.',
      );
      expect(
        container.read(wardrobesControllerProvider).wardrobes,
        hasLength(1),
      );
    },
  );

  test('clearLocal empties the in-memory list', () async {
    repository.items.add(testWardrobe());
    container.read(wardrobesControllerProvider);
    await settle();
    expect(container.read(wardrobesControllerProvider).wardrobes, hasLength(1));

    container.read(wardrobesControllerProvider.notifier).clearLocal();

    expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
  });

  test('create records failure without changing the list', () async {
    container.read(wardrobesControllerProvider);
    await settle();
    repository.nextFailure = const ApiException(
      message: 'name is required.',
      code: 'VALIDATION_ERROR',
    );

    final created = await container
        .read(createWardrobeControllerProvider.notifier)
        .submit(name: 'Home');

    expect(created, isNull);
    expect(
      container.read(createWardrobeControllerProvider).errorMessage,
      'name is required.',
    );
    expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
  });
}
