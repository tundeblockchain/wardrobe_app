import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';

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
}
