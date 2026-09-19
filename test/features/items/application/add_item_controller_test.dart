import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/application/pending_paywall.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_paywall_copy.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/inbox/application/inbox_controller.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';
import 'package:wardrobe_app/features/items/application/add_item_controller.dart';
import 'package:wardrobe_app/features/items/application/item_detail_controller.dart';
import 'package:wardrobe_app/features/items/application/item_local_preview_cache.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/items/application/items_controller.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';

import '../../../helpers/fake_item_image_picker.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_upload_repository.dart';
import '../../../helpers/inbox_test_overrides.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  late FakeItemRepository items;
  late FakeUploadRepository uploads;
  late FakeItemImagePicker picker;
  late ProviderContainer container;

  setUp(() {
    items = FakeItemRepository();
    uploads = FakeUploadRepository();
    picker = FakeItemImagePicker(image: FakeItemImagePicker.sample());
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(items),
        uploadRepositoryProvider.overrideWithValue(uploads),
        itemImagePickerProvider.overrideWithValue(picker),
        ...itemProcessingPollTestOverrides(),
        ...inboxTestOverrides(),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('pickFromGallery stores the image without touching a device', () async {
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    expect(picker.galleryCalls, 1);
    expect(
      container.read(addItemControllerProvider('wd_abc123')).pickedImage,
      picker.image,
    );
  });

  test('submit uploads then creates and upserts the list', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();

    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromCamera();

    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(name: '  Black T-Shirt  ', category: ItemCategory.top);

    expect(created?.name, 'Black T-Shirt');
    expect(created?.id, 'item_1');
    expect(uploads.createCalls, 1);
    expect(uploads.uploadCalls, 1);
    expect(uploads.lastUploadUrl, 'https://s3.example.com/uploads/uuid.jpg');
    expect(items.createCalls, 1);
    expect(items.lastImageKey, 'users/uid/uploads/uuid.jpg');
    expect(
      container.read(itemsControllerProvider('wd_abc123')).items.single.name,
      'Black T-Shirt',
    );
    expect(
      container.read(addItemControllerProvider('wd_abc123')).isSubmitting,
      isFalse,
    );
    expect(created?.processingStatus, ItemProcessingStatus.pending);
    expect(created?.processingStatus.isInProgress, isTrue);
    expect(created?.processingStatus.isTerminal, isFalse);
    expect(
      container.read(itemLocalPreviewCacheProvider)[created!.id],
      picker.image!.bytes,
    );
    final detail = container.read(
      itemDetailControllerProvider(
        ItemScope(wardrobeId: 'wd_abc123', itemId: created.id),
      ),
    );
    expect(detail.isLoading, isFalse);
    expect(detail.item?.id, created.id);
    expect(detail.item?.name, 'Black T-Shirt');
    expect(detail.item?.category, ItemCategory.top);
    expect(detail.item?.originalImageKey, 'users/uid/uploads/uuid.jpg');
    final pending = container.read(inboxControllerProvider).pending;
    expect(pending, hasLength(1));
    expect(pending.single.itemId, created.id);
    expect(pending.single.jobType, JobEventType.processWardrobeItem);
    expect(pending.single.isLocalPending, isTrue);
  });

  test(
    'Free/Basic create maps READY without treating the item as in-progress',
    () async {
      items.createStatus = ItemProcessingStatus.ready;
      container.read(itemsControllerProvider('wd_abc123'));
      await settle();
      await container
          .read(addItemControllerProvider('wd_abc123').notifier)
          .pickFromGallery();

      final created = await container
          .read(addItemControllerProvider('wd_abc123').notifier)
          .submit(name: 'Ready Tee', category: ItemCategory.top);

      expect(created?.processingStatus, ItemProcessingStatus.ready);
      expect(created?.processingStatus.isTerminal, isTrue);
      expect(created?.processingStatus.isInProgress, isFalse);
      expect(
        container
            .read(itemsControllerProvider('wd_abc123'))
            .items
            .single
            .processingStatus,
        ItemProcessingStatus.ready,
      );
      expect(container.read(inboxControllerProvider).pending, isEmpty);
    },
  );

  test('submit omits empty subcategory on create', () async {
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(name: 'Tee', category: ItemCategory.top, subcategory: '   ');

    expect(created?.subcategory, isNull);
    expect(items.lastSubcategoryArg, isNull);
  });

  test('submit omits empty acquiredAt on create', () async {
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(name: 'Tee', category: ItemCategory.top);

    expect(created?.acquiredAt, isNull);
    expect(items.lastAcquiredAtArg, isNull);
  });

  test('submit posts acquiredAt when the form date is set', () async {
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(
          name: 'Tee',
          category: ItemCategory.top,
          acquiredAt: DateTime.utc(2024, 3, 9),
        );

    expect(created?.acquiredAt, DateTime.utc(2024, 3, 9));
    expect(items.lastAcquiredAtArg, DateTime.utc(2024, 3, 9));
  });

  test('submit without a photo records a validation message', () async {
    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(name: 'Tee', category: ItemCategory.top);

    expect(created, isNull);
    expect(
      container.read(addItemControllerProvider('wd_abc123')).errorMessage,
      'Add a photo to continue.',
    );
    expect(uploads.createCalls, 0);
    expect(items.createCalls, 0);
  });

  test('pickFromGallery stores several photos for a batch add', () async {
    picker.images = [
      FakeItemImagePicker.sample(fileName: 'shirt.jpg'),
      FakeItemImagePicker.sample(
        bytes: const [4, 5, 6],
        fileName: 'navy-jeans.png',
      ),
    ];

    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    final state = container.read(addItemControllerProvider('wd_abc123'));
    expect(picker.multiGalleryCalls, 1);
    expect(picker.galleryCalls, 1);
    expect(state.isBatch, isTrue);
    expect(state.pickedImages, hasLength(2));
    expect(state.itemNames, ['shirt', 'navy jeans']);
    expect(state.pickedImage, picker.images!.first);
  });

  test('submitBatch creates each photo and upserts successes', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    picker.images = [
      FakeItemImagePicker.sample(fileName: 'shirt.jpg'),
      FakeItemImagePicker.sample(bytes: const [4, 5, 6], fileName: 'jeans.jpg'),
    ];
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();

    final outcome = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submitBatch(category: ItemCategory.top);

    expect(outcome?.allSucceeded, isTrue);
    expect(outcome?.succeededCount, 2);
    expect(outcome?.summary, '2 items saved.');
    expect(uploads.createCalls, 2);
    expect(uploads.uploadCalls, 2);
    expect(items.createCalls, 2);
    expect(
      container
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .map((i) => i.name),
      ['shirt', 'jeans'],
    );
    expect(
      container.read(addItemControllerProvider('wd_abc123')).isSubmitting,
      isFalse,
    );
    expect(container.read(inboxControllerProvider).pending, hasLength(2));
    expect(
      container.read(inboxControllerProvider).pending.map((e) => e.itemId),
      ['item_1', 'item_2'],
    );
  });

  test('submitBatch keeps successes when a later photo fails', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    picker.images = [
      FakeItemImagePicker.sample(fileName: 'ok.jpg'),
      FakeItemImagePicker.sample(bytes: const [9], fileName: 'bad.jpg'),
      FakeItemImagePicker.sample(bytes: const [8], fileName: 'later.jpg'),
    ];
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();
    items.failOnCreateCall = 2;
    items.createFailure = const ApiException(
      message: 'Could not save this item.',
      code: 'ITEM_CREATE_FAILED',
    );

    final outcome = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submitBatch(category: ItemCategory.bottom);

    expect(outcome?.succeededCount, 2);
    expect(outcome?.failedCount, 1);
    expect(outcome?.summary, '2 saved. 1 failed.');
    expect(items.createCalls, 3);
    expect(
      container
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .map((i) => i.name),
      ['ok', 'later'],
    );
    expect(
      container
          .read(addItemControllerProvider('wd_abc123'))
          .batchResults[1]
          .failed,
      isTrue,
    );
    expect(
      container.read(addItemControllerProvider('wd_abc123')).errorMessage,
      '2 saved. 1 failed.',
    );
  });

  test('submitBatch retry skips items that already saved', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    picker.images = [
      FakeItemImagePicker.sample(fileName: 'first.jpg'),
      FakeItemImagePicker.sample(bytes: const [9], fileName: 'second.jpg'),
    ];
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();
    items.failOnCreateCall = 2;
    items.createFailure = const ApiException(
      message: 'Could not save this item.',
      code: 'ITEM_CREATE_FAILED',
    );

    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submitBatch(category: ItemCategory.top);
    expect(items.createCalls, 2);
    items.failOnCreateCall = null;
    items.createFailure = null;

    final retry = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submitBatch(category: ItemCategory.top);

    expect(retry?.allSucceeded, isTrue);
    expect(retry?.succeededCount, 2);
    expect(items.createCalls, 3);
    expect(
      container
          .read(itemsControllerProvider('wd_abc123'))
          .items
          .map((i) => i.name),
      ['first', 'second'],
    );
  });

  test('submitBatch stops remaining photos after an item-limit 403', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    await settle();
    picker.images = [
      FakeItemImagePicker.sample(fileName: 'one.jpg'),
      FakeItemImagePicker.sample(bytes: const [2], fileName: 'two.jpg'),
      FakeItemImagePicker.sample(bytes: const [3], fileName: 'three.jpg'),
    ];
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();
    items.failOnCreateCall = 2;
    items.createFailure = const ApiException(
      message: 'Item limit reached.',
      code: 'ENTITLEMENT_ITEM_LIMIT',
      statusCode: 403,
    );

    final outcome = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submitBatch(category: ItemCategory.top);

    expect(outcome?.succeededCount, 1);
    expect(outcome?.failedCount, 2);
    expect(items.createCalls, 2);
    expect(
      container.read(itemsControllerProvider('wd_abc123')).items.single.name,
      'one',
    );
    expect(container.read(pendingPaywallProvider), PaywallPlacement.itemLimit);
    expect(
      container
          .read(addItemControllerProvider('wd_abc123'))
          .batchResults
          .where((result) => result.failed)
          .map((result) => result.errorMessage)
          .toSet(),
      {
        EntitlementPaywallCopy.forPlacement(PaywallPlacement.itemLimit)
            .formMessage,
      },
    );
  });

  test('submit records upload failure without creating an item', () async {
    await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .pickFromGallery();
    uploads.nextFailure = const ApiException(
      message: 'purpose must be WARDROBE_ITEM.',
      code: 'UPLOAD_INVALID',
    );

    final created = await container
        .read(addItemControllerProvider('wd_abc123').notifier)
        .submit(name: 'Tee', category: ItemCategory.top);

    expect(created, isNull);
    expect(
      container.read(addItemControllerProvider('wd_abc123')).errorMessage,
      'purpose must be WARDROBE_ITEM.',
    );
    expect(items.createCalls, 0);
  });
}
