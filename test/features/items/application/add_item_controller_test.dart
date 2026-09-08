import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
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
