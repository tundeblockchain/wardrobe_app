import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobe_detail_controller.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeWardrobeRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeWardrobeRepository(seed: [testWardrobe()]);
    container = ProviderContainer.test(
      overrides: [wardrobeRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads wardrobe detail by id', () async {
    container.read(wardrobeDetailControllerProvider('wd_abc123'));
    await settle();

    final state = container.read(wardrobeDetailControllerProvider('wd_abc123'));
    expect(state.wardrobe?.id, 'wd_abc123');
    expect(state.wardrobe?.name, 'Summer Clothes');
    expect(state.isLoading, isFalse);
    expect(repository.getCalls, 1);
  });

  test('rename updates detail and list cache', () async {
    container.read(wardrobesControllerProvider);
    container.read(wardrobeDetailControllerProvider('wd_abc123'));
    await settle();

    final ok = await container
        .read(wardrobeDetailControllerProvider('wd_abc123').notifier)
        .rename('Work Clothes');

    expect(ok, isTrue);
    expect(
      container
          .read(wardrobeDetailControllerProvider('wd_abc123'))
          .wardrobe
          ?.name,
      'Work Clothes',
    );
    expect(
      container.read(wardrobesControllerProvider).wardrobes.single.name,
      'Work Clothes',
    );
  });

  test('delete removes the wardrobe from the list', () async {
    container.read(wardrobesControllerProvider);
    container.read(wardrobeDetailControllerProvider('wd_abc123'));
    await settle();

    final ok = await container
        .read(wardrobeDetailControllerProvider('wd_abc123').notifier)
        .delete();

    expect(ok, isTrue);
    expect(
      container.read(wardrobeDetailControllerProvider('wd_abc123')).isDeleted,
      isTrue,
    );
    expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
  });

  test('load failure surfaces ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Wardrobe not found.',
      code: 'WARDROBE_NOT_FOUND',
    );

    container.read(wardrobeDetailControllerProvider('missing'));
    await settle();

    expect(
      container.read(wardrobeDetailControllerProvider('missing')).errorMessage,
      'Wardrobe not found.',
    );
  });
}
