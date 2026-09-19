import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/application/pending_paywall.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/data/paywall_gateway_provider.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/items/application/item_detail_controller.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_transfer.dart';

import '../../../helpers/fake_entitlements.dart';
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

  test('moveTo relocates the item and updates both list caches', () async {
    repository.items.add(testItem(id: 'item_keep', wardrobeId: 'wd_other12ab'));
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(itemsControllerProvider('wd_other12ab'));
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final moved = await container
        .read(itemDetailControllerProvider(scope).notifier)
        .moveTo('wd_other12ab');

    expect(moved?.id, 'item_xyz123');
    expect(moved?.wardrobeId, 'wd_other12ab');
    expect(repository.moveCalls, 1);
    expect(repository.lastTargetWardrobeId, 'wd_other12ab');
    expect(
      container
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .any((item) => item.id == 'item_xyz123'),
      isFalse,
    );
    expect(
      container
          .read(itemsControllerProvider('wd_other12ab'))
          .items
          .any((item) => item.id == 'item_xyz123'),
      isTrue,
    );
  });

  test(
    'moveTo maps a 400 outfit block without dropping the source row',
    () async {
      container.read(itemsControllerProvider('wd_abc123'));
      container.read(itemDetailControllerProvider(scope));
      await settle();
      repository.nextFailure = const ApiException(
        message:
            'Cannot move an item that is used in an outfit (outfit_friday1). '
            'Remove it from outfits in the source wardrobe first.',
        code: 'VALIDATION_ERROR',
        statusCode: 400,
      );

      final moved = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .moveTo('wd_other12ab');

      expect(moved, isNull);
      expect(
        container.read(itemDetailControllerProvider(scope)).errorMessage,
        ItemTransferMessages.outfitBlockWithId('outfit_friday1'),
      );
      expect(
        container.read(itemsControllerProvider('wd_abc123')).items,
        hasLength(1),
      );
    },
  );

  test(
    'copyTo upserts the new item and queues item-limit paywall on 403',
    () async {
      final entitlements = FakeEntitlementRepository();
      final paywall = FakePaywallGateway();
      container.dispose();
      container = ProviderContainer.test(
        overrides: [
          itemRepositoryProvider.overrideWithValue(repository),
          entitlementRepositoryProvider.overrideWithValue(entitlements),
          paywallGatewayProvider.overrideWithValue(paywall),
          ...itemProcessingPollTestOverrides(),
        ],
      );
      container.read(itemsControllerProvider('wd_abc123'));
      container.read(itemsControllerProvider('wd_other12ab'));
      container.read(itemDetailControllerProvider(scope));
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Free includes 5 clothing items.',
        code: 'ENTITLEMENT_ITEM_LIMIT',
        statusCode: 403,
      );

      final copied = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .copyTo('wd_other12ab');

      expect(copied, isNull);
      expect(
        container.read(itemDetailControllerProvider(scope)).errorMessage,
        ItemTransferMessages.itemLimitUpgrade,
      );
      expect(
        container.read(pendingPaywallProvider),
        PaywallPlacement.itemLimit,
      );
      expect(
        container.read(itemsControllerProvider('wd_abc123')).items,
        hasLength(1),
      );
    },
  );

  test(
    'copyTo keeps the source item and adds the copy to the target',
    () async {
      final entitlements = FakeEntitlementRepository();
      container.dispose();
      container = ProviderContainer.test(
        overrides: [
          itemRepositoryProvider.overrideWithValue(repository),
          entitlementRepositoryProvider.overrideWithValue(entitlements),
          paywallGatewayProvider.overrideWithValue(FakePaywallGateway()),
          ...itemProcessingPollTestOverrides(),
        ],
      );
      container.read(itemsControllerProvider('wd_abc123'));
      container.read(itemsControllerProvider('wd_other12ab'));
      container.read(itemDetailControllerProvider(scope));
      await settle();

      final copied = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .copyTo('wd_other12ab');

      expect(copied?.id, isNot('item_xyz123'));
      expect(copied?.wardrobeId, 'wd_other12ab');
      expect(repository.copyCalls, 1);
      expect(
        container.read(itemsControllerProvider('wd_abc123')).items.single.id,
        'item_xyz123',
      );
      expect(
        container
            .read(itemsControllerProvider('wd_other12ab'))
            .items
            .any((item) => item.id == copied?.id),
        isTrue,
      );
    },
  );

  test('moveTo rejects the source wardrobe without calling the API', () async {
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final moved = await container
        .read(itemDetailControllerProvider(scope).notifier)
        .moveTo('wd_abc123');

    expect(moved, isNull);
    expect(repository.moveCalls, 0);
    expect(
      container.read(itemDetailControllerProvider(scope)).errorMessage,
      ItemTransferMessages.sameWardrobe,
    );
  });

  test(
    'reprocess applies 202 PENDING and does not auto-retry after timeout',
    () async {
      repository.items
        ..clear()
        ..add(
          testItem(
            processingStatus: ItemProcessingStatus.failed,
            processingError: 'Background removal failed.',
          ),
        );
      container.read(itemDetailControllerProvider(scope));
      await settle();
      final getsBefore = repository.getCalls;

      final ok = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .reprocess();

      final state = container.read(itemDetailControllerProvider(scope));
      expect(ok, isFalse);
      expect(state.item?.processingStatus, ItemProcessingStatus.pending);
      expect(state.item?.processingError, isNull);
      expect(state.isPolling, isFalse);
      expect(state.showProcessingRetry, isFalse);
      expect(repository.reprocessCalls, 1);
      expect(repository.getCalls, getsBefore);
      expect(
        container
            .read(itemsControllerProvider('wd_abc123'))
            .items
            .single
            .processingStatus,
        ItemProcessingStatus.pending,
      );
    },
  );

  test('reprocess polls get until READY', () async {
    final ticks = ItemProcessingPollTicks();
    container.dispose();
    repository = FakeItemRepository(
      seed: [
        testItem(
          processingStatus: ItemProcessingStatus.failed,
          processingError: 'Classifier unavailable.',
        ),
      ],
    );
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repository),
        ...ticks.overrides(),
      ],
    );
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final future = container
        .read(itemDetailControllerProvider(scope).notifier)
        .reprocess();
    await settle();
    expect(
      container
          .read(itemDetailControllerProvider(scope))
          .item
          ?.processingStatus,
      ItemProcessingStatus.pending,
    );
    expect(
      container.read(itemDetailControllerProvider(scope)).isPolling,
      isTrue,
    );

    repository.items[0] = testItem(
      processingStatus: ItemProcessingStatus.ready,
      processedImageKey: 'https://cdn.example.com/processed.png',
    );
    await ticks.tickAll();
    final ok = await future;

    expect(ok, isTrue);
    final item = container.read(itemDetailControllerProvider(scope)).item;
    expect(item?.processingStatus, ItemProcessingStatus.ready);
    expect(item?.processedImageKey, 'https://cdn.example.com/processed.png');
    expect(
      container.read(itemDetailControllerProvider(scope)).isPolling,
      isFalse,
    );
    expect(
      container.read(itemDetailControllerProvider(scope)).showProcessingBanner,
      isFalse,
    );
  });

  test('409 PROCESSING_IN_PROGRESS keeps polling without a snackbar', () async {
    final ticks = ItemProcessingPollTicks();
    container.dispose();
    repository = FakeItemRepository(
      seed: [
        testItem(
          processingStatus: ItemProcessingStatus.failed,
          processingError: 'rembg failed',
        ),
      ],
    );
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repository),
        ...ticks.overrides(),
      ],
    );
    container.read(itemDetailControllerProvider(scope));
    await settle();
    repository.nextFailure = const ApiException(
      message: 'Item is already processing.',
      code: 'PROCESSING_IN_PROGRESS',
      statusCode: 409,
    );
    repository.items[0] = testItem(
      processingStatus: ItemProcessingStatus.pending,
    );

    final future = container
        .read(itemDetailControllerProvider(scope).notifier)
        .reprocess();
    await settle();
    expect(repository.reprocessCalls, 1);
    expect(
      container.read(itemDetailControllerProvider(scope)).snackMessage,
      isNull,
    );
    expect(
      container.read(itemDetailControllerProvider(scope)).isPolling,
      isTrue,
    );

    repository.items[0] = testItem(
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Still failed.',
    );
    await ticks.tickAll();
    await future;

    final state = container.read(itemDetailControllerProvider(scope));
    expect(state.item?.processingStatus, ItemProcessingStatus.failed);
    expect(state.item?.processingError, 'Still failed.');
    expect(state.showProcessingRetry, isTrue);
    expect(state.snackMessage, isNull);
  });

  test('reprocess 403 queues the other-AI paywall and a snackbar', () async {
    repository.items
      ..clear()
      ..add(testItem(processingStatus: ItemProcessingStatus.failed));
    container.read(itemDetailControllerProvider(scope));
    await settle();
    repository.nextFailure = const ApiException(
      message: 'Premium is required for AI processing.',
      code: 'ENTITLEMENT_AI_REQUIRED',
      statusCode: 403,
    );

    final ok = await container
        .read(itemDetailControllerProvider(scope).notifier)
        .reprocess();

    expect(ok, isFalse);
    expect(
      container.read(itemDetailControllerProvider(scope)).snackMessage,
      'Premium is required for AI processing.',
    );
    expect(container.read(pendingPaywallProvider), PaywallPlacement.otherAi);
    expect(
      container
          .read(itemDetailControllerProvider(scope))
          .item
          ?.processingStatus,
      ItemProcessingStatus.failed,
    );
  });

  test(
    'reprocess 500 surfaces a snackbar and leaves FAILED retryable',
    () async {
      repository.items
        ..clear()
        ..add(testItem(processingStatus: ItemProcessingStatus.failed));
      container.read(itemDetailControllerProvider(scope));
      await settle();
      repository.nextFailure = const ApiException(
        message: 'Could not enqueue processing.',
        code: 'INTERNAL_ERROR',
        statusCode: 500,
      );

      final ok = await container
          .read(itemDetailControllerProvider(scope).notifier)
          .reprocess();

      expect(ok, isFalse);
      expect(
        container.read(itemDetailControllerProvider(scope)).snackMessage,
        'Could not enqueue processing.',
      );
      expect(
        container.read(itemDetailControllerProvider(scope)).showProcessingRetry,
        isTrue,
      );
    },
  );

  test('does not reprocess PENDING or READY items', () async {
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final ok = await container
        .read(itemDetailControllerProvider(scope).notifier)
        .reprocess();

    expect(ok, isFalse);
    expect(repository.reprocessCalls, 0);
  });
}
