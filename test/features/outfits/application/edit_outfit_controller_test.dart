import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/application/edit_outfit_controller.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_detail_controller.dart';
import 'package:wardrobe_app/features/outfits/application/outfit_scope.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  const scope = OutfitScope(wardrobeId: 'wd_abc123', outfitId: 'outfit_123');

  late FakeOutfitRepository outfits;
  late FakeItemRepository items;
  late ProviderContainer container;

  setUp(() {
    outfits = FakeOutfitRepository(seed: [testOutfit()]);
    items = FakeItemRepository(
      seed: [
        testItem(id: 'item_top123'),
        testItem(
          id: 'item_bottom456',
          name: 'Navy Jeans',
          category: ItemCategory.bottom,
        ),
      ],
    );
    container = ProviderContainer.test(
      overrides: [
        outfitRepositoryProvider.overrideWithValue(outfits),
        itemRepositoryProvider.overrideWithValue(items),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('seeds slots from the loaded outfit and submits an update', () async {
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(outfitDetailControllerProvider(scope));
    await settle();

    final controller = container.read(
      editOutfitControllerProvider(scope).notifier,
    );
    expect(
      container.read(editOutfitControllerProvider(scope)).items,
      isNotEmpty,
    );

    controller.assign(slot: ItemCategory.accessory, itemId: 'item_top123');
    final updated = await controller.submit(name: 'Saturday Brunch');

    expect(updated?.name, 'Saturday Brunch');
    expect(outfits.updateCalls, 1);
    expect(
      container.read(outfitDetailControllerProvider(scope)).outfit?.name,
      'Saturday Brunch',
    );
    expect(
      container
          .read(outfitsControllerProvider('wd_abc123'))
          .outfits
          .single
          .name,
      'Saturday Brunch',
    );
  });

  test('submit records ApiException message', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(outfitDetailControllerProvider(scope));
    await settle();
    outfits.nextFailure = const ApiException(
      message: 'Outfit not found.',
      code: 'OUTFIT_NOT_FOUND',
    );

    final controller = container.read(
      editOutfitControllerProvider(scope).notifier,
    );
    final updated = await controller.submit(name: 'Saturday Brunch');

    expect(updated, isNull);
    expect(
      container.read(editOutfitControllerProvider(scope)).errorMessage,
      'Outfit not found.',
    );
  });
}
