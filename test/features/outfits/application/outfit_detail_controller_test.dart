import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_detail_controller.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_scope.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  const scope = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'outfit_123');

  late FakeOutfitRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeOutfitRepository(seed: [testOutfit()]);
    container = ProviderContainer.test(
      overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads outfit detail by id', () async {
    container.read(outfitDetailControllerProvider(scope));
    await settle();

    final state = container.read(outfitDetailControllerProvider(scope));
    expect(state.outfit?.id, 'outfit_123');
    expect(state.outfit?.name, 'Friday Night');
    expect(state.isLoading, isFalse);
    expect(repository.getCalls, 1);
  });

  test('delete removes the outfit from the list', () async {
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(outfitDetailControllerProvider(scope));
    await settle();

    final ok = await container
        .read(outfitDetailControllerProvider(scope).notifier)
        .delete();

    expect(ok, isTrue);
    expect(
      container.read(outfitDetailControllerProvider(scope)).isDeleted,
      isTrue,
    );
    expect(
      container.read(outfitsControllerProvider('wd_abc123')).outfits,
      isEmpty,
    );
  });

  test('load failure surfaces ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Outfit not found.',
      code: 'OUTFIT_NOT_FOUND',
    );

    const missing = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'missing');
    container.read(outfitDetailControllerProvider(missing));
    await settle();

    expect(
      container.read(outfitDetailControllerProvider(missing)).errorMessage,
      'Outfit not found.',
    );
  });
}
