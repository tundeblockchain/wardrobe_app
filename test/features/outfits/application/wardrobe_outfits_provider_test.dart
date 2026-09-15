import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/application/wardrobe_outfits_provider.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeOutfitRepository outfits;
  late FakeWardrobeRepository wardrobes;
  late ProviderContainer container;

  setUp(() {
    outfits = FakeOutfitRepository(
      seed: [
        testOutfit(),
        testOutfit(id: 'outfit_w', wardrobeId: 'wd_winter', name: 'Snow day'),
      ],
    );
    wardrobes = FakeWardrobeRepository(
      seed: [
        testWardrobe(),
        testWardrobe(id: 'wd_winter', name: 'Winter'),
      ],
    );
    container = ProviderContainer.test(
      overrides: [
        outfitRepositoryProvider.overrideWithValue(outfits),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('home outfits flatten every wardrobe in list order', () async {
    container.read(wardrobesControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(wardrobeOutfitsProvider('wd_abc123').future);
    await container.read(wardrobeOutfitsProvider('wd_winter').future);

    final result = container.read(homeOutfitsProvider);

    expect(result.map((outfit) => outfit.id), ['outfit_123', 'outfit_w']);
    expect(result.map((outfit) => outfit.wardrobeId), [
      'wd_abc123',
      'wd_winter',
    ]);
    expect(outfits.listCalls, 2);
  });
}
