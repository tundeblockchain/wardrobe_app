import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  late FakeItemRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeItemRepository();
    container = ProviderContainer.test(
      overrides: [itemRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads items for the wardrobe', () async {
    repository.items.add(testItem());

    final first = container.read(itemsControllerProvider('wd_abc123'));
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(itemsControllerProvider('wd_abc123'));
    expect(state.isLoading, isFalse);
    expect(state.items, hasLength(1));
    expect(state.items.single.id, 'item_xyz123');
    expect(repository.listCalls, 1);
  });

  test('refresh records ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    expect(
      container.read(itemsControllerProvider('wd_abc123')).errorMessage,
      contains('connection'),
    );
  });

  test('setFilters refetches with query filters', () async {
    repository.items.add(testItem());
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    expect(repository.listCalls, 1);

    await container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .setFilters(
          const ItemListFilters(
            category: ItemCategory.top,
            colour: ItemColour.black,
            subcategory: ItemSubcategory.tshirt,
          ),
        );

    expect(repository.listCalls, 2);
    expect(
      repository.lastListFilters,
      const ItemListFilters(
        category: ItemCategory.top,
        colour: ItemColour.black,
        subcategory: ItemSubcategory.tshirt,
      ),
    );
    expect(
      container.read(itemsControllerProvider('wd_abc123')).filters.category,
      ItemCategory.top,
    );
  });

  test('app resume refetches the current filters', () async {
    repository.items.add(testItem());
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    await container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .setFilters(const ItemListFilters(category: ItemCategory.bottom));
    expect(repository.listCalls, 2);

    container.read(appLifecycleTickProvider.notifier).bump();
    await settle();

    expect(repository.listCalls, 3);
    expect(
      repository.lastListFilters,
      const ItemListFilters(category: ItemCategory.bottom),
    );
  });
}
