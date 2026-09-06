import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/application/edit_item_controller.dart';
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

void main() {
  const scope = ItemScope(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

  late FakeItemRepository items;
  late FakeUploadRepository uploads;
  late FakeItemImagePicker picker;
  late ProviderContainer container;

  setUp(() {
    items = FakeItemRepository(seed: [testItem()]);
    uploads = FakeUploadRepository();
    picker = FakeItemImagePicker(image: FakeItemImagePicker.sample());
    container = ProviderContainer.test(
      overrides: [
        itemRepositoryProvider.overrideWithValue(items),
        uploadRepositoryProvider.overrideWithValue(uploads),
        itemImagePickerProvider.overrideWithValue(picker),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('submit updates metadata without uploading when no new photo', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(itemDetailControllerProvider(scope));
    await settle();

    final updated = await container
        .read(editItemControllerProvider(scope).notifier)
        .submit(name: 'Navy Tee', category: ItemCategory.top);

    expect(updated?.name, 'Navy Tee');
    expect(uploads.createCalls, 0);
    expect(items.updateCalls, 1);
    expect(
      container.read(itemsControllerProvider('wd_abc123')).items.single.name,
      'Navy Tee',
    );
  });

  test('submit uploads a replacement photo when one is picked', () async {
    container.read(itemsControllerProvider('wd_abc123'));
    container.read(itemDetailControllerProvider(scope));
    await settle();

    await container
        .read(editItemControllerProvider(scope).notifier)
        .pickFromGallery();

    final updated = await container
        .read(editItemControllerProvider(scope).notifier)
        .submit(name: 'Navy Tee', category: ItemCategory.top);

    expect(updated, isNotNull);
    expect(uploads.createCalls, 1);
    expect(uploads.uploadCalls, 1);
    expect(items.lastImageKey, 'users/uid/uploads/uuid.jpg');
    expect(
      container.read(itemLocalPreviewCacheProvider)[updated!.id],
      picker.image!.bytes,
    );
  });
}
