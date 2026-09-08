import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/item_detail_controller.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  const scope = ItemScope(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

  late FakeItemRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeItemRepository(seed: [testItem()]);
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repository),
        ...itemProcessingPollTestOverrides(),
      ],
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

  test(
    'delete failure surfaces ApiException without removing the list row',
    () async {
      container.read(itemsControllerProvider('wd_abc123'));
      container.read(itemDetailControllerProvider(scope));
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Item not found.',
        code: 'ITEM_NOT_FOUND',
      );

      final ok = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .delete();

      expect(ok, isFalse);
      expect(
        container.read(itemDetailControllerProvider(scope)).errorMessage,
        'Item not found.',
      );
      expect(
        container.read(itemDetailControllerProvider(scope)).isDeleted,
        isFalse,
      );
      expect(
        container.read(itemsControllerProvider('wd_abc123')).items,
        hasLength(1),
      );
    },
  );

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

  test('seeds detail from the list cache before get completes', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    final created = testItem(
      processingStatus: ItemProcessingStatus.processing,
      originalImageUrl: 'https://cdn.example.com/original.jpg',
    );
    container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .upsert(created);

    final state = container.read(itemDetailControllerProvider(scope));
    expect(state.item?.name, 'Black Nike T-Shirt');
    expect(state.item?.category, ItemCategory.top);
    expect(state.item?.brand, 'Nike');
    expect(
      state.item?.originalImageKey,
      'https://cdn.example.com/original.jpg',
    );
    expect(state.isLoading, isFalse);
    expect(repository.getCalls, 0);
  });

  test('replace shows saved fields without waiting on processingStatus', () {
    final created = testItem(
      processingStatus: ItemProcessingStatus.pending,
      originalImageKey: 'users/uid/uploads/uuid.jpg',
    );

    container
        .read(itemDetailControllerProvider(scope).notifier)
        .replace(created);

    final state = container.read(itemDetailControllerProvider(scope));
    expect(state.item?.name, created.name);
    expect(state.item?.category, created.category);
    expect(state.item?.colours, created.colours);
    expect(state.item?.brand, created.brand);
    expect(state.item?.originalImageKey, created.originalImageKey);
    expect(state.isLoading, isFalse);
  });

  test('refresh can apply later AI fields without requiring a poll', () async {
    final processing = testItem(
      processingStatus: ItemProcessingStatus.processing,
      originalImageUrl: 'https://cdn.example.com/original.jpg',
    );
    repository.items
      ..clear()
      ..add(processing);

    container.read(itemDetailControllerProvider(scope));
    await settle();
    expect(repository.getCalls, 1);

    repository.items[0] = processing.copyWith(
      processingStatus: ItemProcessingStatus.ready,
      processedImageKey: 'https://cdn.example.com/processed.png',
      category: ItemCategory.top,
    );
    await container
        .read(itemDetailControllerProvider(scope).notifier)
        .refresh();

    final item = container.read(itemDetailControllerProvider(scope)).item;
    expect(item?.processedImageKey, 'https://cdn.example.com/processed.png');
    expect(item?.originalImageKey, 'https://cdn.example.com/original.jpg');
    expect(repository.getCalls, 2);

    await settle();
    expect(repository.getCalls, 2);
  });
}
