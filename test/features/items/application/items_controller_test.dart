import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/item_local_preview_cache.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  late FakeItemRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeItemRepository();
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repository),
        ...itemProcessingPollTestOverrides(),
      ],
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

  test('upsert keeps a PROCESSING item and swaps in the READY photo', () async {
    final processing = testItem(
      processingStatus: ItemProcessingStatus.processing,
    );
    repository.items.add(processing);
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    final ready = processing.copyWith(
      processingStatus: ItemProcessingStatus.ready,
      processedImageKey: 'https://cdn.example.com/processed.png',
    );
    container.read(itemsControllerProvider('wd_abc123').notifier).upsert(ready);

    final items = container.read(itemsControllerProvider('wd_abc123')).items;
    expect(items, hasLength(1));
    expect(items.single.id, processing.id);
    expect(items.single.processingStatus, ItemProcessingStatus.ready);
    expect(
      items.single.processedImageKey,
      'https://cdn.example.com/processed.png',
    );
  });

  test('deleteItem calls DELETE and removes READY and FAILED rows', () async {
    final ready = testItem();
    final failed = testItem(
      id: 'item_failed',
      name: 'Failed blouse',
      processingStatus: ItemProcessingStatus.failed,
    );
    repository.items.addAll([ready, failed]);
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    final removedReady = await container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .deleteItem(ready.id);
    expect(removedReady, isTrue);
    expect(repository.deleteCalls, 1);
    expect(
      container.read(itemsControllerProvider('wd_abc123')).items.single.id,
      failed.id,
    );

    final removedFailed = await container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .deleteItem(failed.id);
    expect(removedFailed, isTrue);
    expect(repository.deleteCalls, 2);
    expect(container.read(itemsControllerProvider('wd_abc123')).items, isEmpty);
  });

  test(
    'deleteItem failure surfaces ApiException without removing the row',
    () async {
      repository.items.add(testItem());
      container.read(itemsControllerProvider('wd_abc123'));
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Item not found.',
        code: 'ITEM_NOT_FOUND',
      );

      final ok = await container
          .read(itemsControllerProvider('wd_abc123').notifier)
          .deleteItem('item_xyz123');

      expect(ok, isFalse);
      expect(
        container.read(itemsControllerProvider('wd_abc123')).errorMessage,
        'Item not found.',
      );
      expect(
        container.read(itemsControllerProvider('wd_abc123')).items,
        hasLength(1),
      );
    },
  );

  test('polls list until FAILED and then stops', () async {
    final ticks = ItemProcessingPollTicks();
    final polling = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repository),
        ...ticks.overrides(),
      ],
    );
    addTearDown(polling.dispose);

    final processing = testItem(
      processingStatus: ItemProcessingStatus.processing,
      originalImageUrl: 'https://cdn.example.com/original.jpg',
    );
    repository.items.add(processing);
    polling.read(itemsControllerProvider('wd_abc123'));
    await settle();

    expect(
      polling
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .single
          .processingStatus,
      ItemProcessingStatus.processing,
    );
    expect(ticks.waiting, 1);
    final callsWhileProcessing = repository.listCalls;

    repository.items[0] = processing.copyWith(
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Background removal failed.',
    );
    await ticks.tickAll();

    final items = polling.read(itemsControllerProvider('wd_abc123')).items;
    expect(items.single.processingStatus, ItemProcessingStatus.failed);
    expect(items.single.processingStatus.isInProgress, isFalse);
    expect(items.single.processingStatus.isTerminal, isTrue);
    expect(items.single.processingError, 'Background removal failed.');
    expect(
      items.single.originalImageKey,
      'https://cdn.example.com/original.jpg',
    );
    expect(repository.listCalls, greaterThan(callsWhileProcessing));
    expect(ticks.waiting, 0);

    final callsAfterFailed = repository.listCalls;
    await ticks.tickAll();
    expect(repository.listCalls, callsAfterFailed);
  });

  test('refresh picks up FAILED without restarting a poll loop', () async {
    repository.items.add(
      testItem(processingStatus: ItemProcessingStatus.processing),
    );
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    repository.items[0] = testItem(
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Classifier unavailable.',
    );
    await container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .refresh();
    await settle();

    final item = container
        .read(itemsControllerProvider('wd_abc123'))
        .items
        .single;
    expect(item.processingStatus, ItemProcessingStatus.failed);
    expect(item.processingError, 'Classifier unavailable.');
    final calls = repository.listCalls;
    await settle();
    expect(repository.listCalls, calls);
  });

  test('remove evicts the local upload preview', () async {
    repository.items.add(testItem());
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    container
        .read(itemLocalPreviewCacheProvider.notifier)
        .store('item_xyz123', Uint8List.fromList(const [1, 2, 3]));

    container
        .read(itemsControllerProvider('wd_abc123').notifier)
        .remove('item_xyz123');

    expect(container.read(itemsControllerProvider('wd_abc123')).items, isEmpty);
    expect(
      container.read(itemLocalPreviewCacheProvider)['item_xyz123'],
      isNull,
    );
  });
}
