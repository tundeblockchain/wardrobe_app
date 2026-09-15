import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/search/application/app_search_providers.dart';
import 'package:wardrobe_app/features/search/domain/app_search.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeItemRepository items;
  late FakeOutfitRepository outfits;
  late FakeWardrobeRepository wardrobes;
  late ProviderContainer container;

  setUp(() {
    items = FakeItemRepository(seed: [testItem()]);
    outfits = FakeOutfitRepository(seed: [testOutfit()]);
    wardrobes = FakeWardrobeRepository(seed: [testWardrobe()]);
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(items),
        outfitRepositoryProvider.overrideWithValue(outfits),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settleLists() async {
    container.read(wardrobesControllerProvider);
    await Future<void>.delayed(Duration.zero);
    container.read(appSearchQueryProvider.notifier).setQuery('x');
    container.read(appSearchCatalogProvider);
    await Future<void>.delayed(Duration.zero);
  }

  test('empty query does not read the catalog or return hits', () async {
    container.read(wardrobesControllerProvider);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(appSearchResultsProvider).isEmpty, isTrue);
    expect(items.listCalls, 0);
    expect(outfits.listCalls, 0);
  });

  test('catalog flattens loaded items and outfits', () async {
    await settleLists();

    final catalog = container.read(appSearchCatalogProvider);
    expect(catalog.wardrobes.single.id, 'wd_abc123');
    expect(catalog.items.single.id, 'item_xyz123');
    expect(catalog.outfits.single.id, 'outfit_123');
    expect(items.listCalls, 1);
    expect(outfits.listCalls, 1);
  });

  test('results use the loaded-list engine for a name query', () async {
    await settleLists();
    container.read(appSearchQueryProvider.notifier).setQuery('Friday');

    final results = container.read(appSearchResultsProvider);
    expect(results.outfits.single.id, 'outfit_123');
    expect(results.items, isEmpty);
    expect(results.wardrobes, isEmpty);
  });

  test('engine provider defaults to loadedListAppSearch', () {
    expect(container.read(appSearchEngineProvider), same(loadedListAppSearch));
  });
}
