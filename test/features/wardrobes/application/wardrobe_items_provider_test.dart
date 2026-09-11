import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobe_items_provider.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeItemRepository items;
  late FakeWardrobeRepository wardrobes;
  late ProviderContainer container;

  setUp(() {
    items = FakeItemRepository(
      seed: [
        testItem(),
        testItem(id: 'item_coat', wardrobeId: 'wd_winter', name: 'Wool coat'),
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
        itemRepositoryProvider.overrideWithValue(items),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('home clothing items flatten every wardrobe in list order', () async {
    container.read(wardrobesControllerProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(wardrobeItemsProvider('wd_abc123').future);
    await container.read(wardrobeItemsProvider('wd_winter').future);

    final result = container.read(homeClothingItemsProvider);

    expect(result.map((item) => item.id), ['item_xyz123', 'item_coat']);
    expect(result.map((item) => item.wardrobeId), ['wd_abc123', 'wd_winter']);
    expect(items.listCalls, 2);
  });
}
