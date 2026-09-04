import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/application/create_outfit_controller.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  late FakeOutfitRepository outfits;
  late FakeItemRepository items;
  late ProviderContainer container;

  setUp(() {
    outfits = FakeOutfitRepository();
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

  test('assign replaces a slot and drops the item from other slots', () {
    final controller = container.read(
      createOutfitControllerProvider('wd_abc123').notifier,
    );

    controller.assign(slot: ItemCategory.top, itemId: 'item_top123');
    controller.assign(slot: ItemCategory.bottom, itemId: 'item_top123');

    final state = container.read(createOutfitControllerProvider('wd_abc123'));
    expect(state.items, hasLength(1));
    expect(state.items.single.slot, ItemCategory.bottom);
    expect(state.items.single.itemId, 'item_top123');
  });

  test('submit creates and upserts the list', () async {
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    final controller = container.read(
      createOutfitControllerProvider('wd_abc123').notifier,
    );
    controller.assign(slot: ItemCategory.top, itemId: 'item_top123');

    final created = await controller.submit(name: '  Friday Night  ');

    expect(created?.name, 'Friday Night');
    expect(created?.id, 'outfit_1');
    expect(outfits.createCalls, 1);
    expect(outfits.lastItems, hasLength(1));
    expect(
      container
          .read(outfitsControllerProvider('wd_abc123'))
          .outfits
          .single
          .name,
      'Friday Night',
    );
    expect(
      container.read(createOutfitControllerProvider('wd_abc123')).isSaving,
      isFalse,
    );
  });

  test('submit without items records a validation message', () async {
    final created = await container
        .read(createOutfitControllerProvider('wd_abc123').notifier)
        .submit(name: 'Friday Night');

    expect(created, isNull);
    expect(
      container.read(createOutfitControllerProvider('wd_abc123')).errorMessage,
      'Add at least one item to this outfit.',
    );
    expect(outfits.createCalls, 0);
  });

  test('submit records failure without changing the list', () async {
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    outfits.nextFailure = const ApiException(
      message: 'name is required.',
      code: 'VALIDATION_ERROR',
    );

    final controller = container.read(
      createOutfitControllerProvider('wd_abc123').notifier,
    );
    controller.assign(slot: ItemCategory.top, itemId: 'item_top123');
    final created = await controller.submit(name: 'Friday Night');

    expect(created, isNull);
    expect(
      container.read(createOutfitControllerProvider('wd_abc123')).errorMessage,
      'name is required.',
    );
    expect(
      container.read(outfitsControllerProvider('wd_abc123')).outfits,
      isEmpty,
    );
  });
}
