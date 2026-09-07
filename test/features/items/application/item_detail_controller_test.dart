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

  Future<void> flushPoll() async {
    for (var i = 0; i < 8; i++) {
      await settle();
    }
  }

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

  test('polls get until FAILED and then stops', () async {
    final processing = testItem(
      processingStatus: ItemProcessingStatus.processing,
      originalImageUrl: 'https://cdn.example.com/original.jpg',
    );
    repository.items
      ..clear()
      ..add(processing);

    container.read(itemDetailControllerProvider(scope));
    await flushPoll();

    expect(
      container
          .read(itemDetailControllerProvider(scope))
          .item
          ?.processingStatus,
      ItemProcessingStatus.processing,
    );
    final getsWhileProcessing = repository.getCalls;

    repository.items[0] = processing.copyWith(
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Background removal failed.',
    );
    await flushPoll();

    final item = container.read(itemDetailControllerProvider(scope)).item;
    expect(item?.processingStatus, ItemProcessingStatus.failed);
    expect(item?.processingStatus.isInProgress, isFalse);
    expect(item?.processingError, 'Background removal failed.');
    expect(item?.originalImageKey, 'https://cdn.example.com/original.jpg');
    expect(repository.getCalls, greaterThan(getsWhileProcessing));

    final getsAfterFailed = repository.getCalls;
    await flushPoll();
    expect(repository.getCalls, getsAfterFailed);
    expect(
      container
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .single
          .processingStatus,
      ItemProcessingStatus.failed,
    );
  });
}
