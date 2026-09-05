import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/item_detail_controller.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  const scope = ItemScope(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

  late FakeItemRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeItemRepository(seed: [testItem()]);
    container = ProviderContainer.test(
      overrides: [itemRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads item detail by id', () async {
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final state = container.read(itemDetailControllerProvider(scope));
    expect(state.item?.id, 'item_xyz123');
    expect(state.item?.name, 'Black Nike T-Shirt');
    expect(state.isLoading, isFalse);
    expect(repository.getCalls, 1);
  });

  test('delete removes the item from the list', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final ok = await container
        .read(itemDetailControllerProvider(scope).notifier)
        .delete();

    expect(ok, isTrue);
    expect(
      container.read(itemDetailControllerProvider(scope)).isDeleted,
      isTrue,
    );
    expect(container.read(itemsControllerProvider('wd_abc123')).items, isEmpty);
  });

  test('load failure surfaces ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Item not found.',
      code: 'ITEM_NOT_FOUND',
    );

    const missing = ItemScope(wardrobeId: 'wd_abc123', itemId: 'missing');
    container.read(itemDetailControllerProvider(missing));
    await settle();

    expect(
      container.read(itemDetailControllerProvider(missing)).errorMessage,
      'Item not found.',
    );
  });

  test('app resume refetches item detail', () async {
    container.read(itemDetailControllerProvider(scope));
    await settle();
    expect(repository.getCalls, 1);

    container.read(appLifecycleTickProvider.notifier).bump();
    await settle();

    expect(repository.getCalls, 2);
  });
}
