import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/share/application/share_controller.dart';
import 'package:wardrobe_app/features/share/domain/share.dart';
import 'package:wardrobe_app/features/share/domain/share_errors.dart';

import '../../../helpers/fake_share_repository.dart';
import '../../../helpers/fake_share_sheet.dart';
import '../../../helpers/share_test_overrides.dart';

void main() {
  late FakeShareRepository repository;
  late FakeShareSheet sheet;
  late FakeShareImageDownloader images;
  late ProviderContainer container;

  setUp(() {
    repository = FakeShareRepository();
    sheet = FakeShareSheet();
    images = FakeShareImageDownloader(path: '/tmp/share.jpg');
    container = ProviderContainer.test(
      overrides: shareTestOverrides(
        repository: repository,
        sheet: sheet,
        images: images,
      ),
    );
  });

  tearDown(() => container.dispose());

  test(
    'shareItem creates a token and opens the sheet with URL + image',
    () async {
      container.read(shareControllerProvider);

      final ok = await container
          .read(shareControllerProvider.notifier)
          .shareItem(
            wardrobeId: 'wd_abc123',
            itemId: 'item_xyz123',
            title: 'Black Nike T-Shirt',
            imageUrl: 'https://cdn.example.com/item.jpg',
          );

      expect(ok, isTrue);
      expect(repository.createItemCalls, 1);
      expect(images.calls, ['https://cdn.example.com/item.jpg']);
      expect(sheet.payloads, hasLength(1));
      expect(sheet.payloads.single.title, 'Black Nike T-Shirt');
      expect(
        sheet.payloads.single.url,
        'https://share.example.com/share/shr_abc123xyz',
      );
      expect(sheet.payloads.single.imagePath, '/tmp/share.jpg');
      expect(container.read(shareControllerProvider).isSharing, isFalse);
    },
  );

  test(
    'shareOutfit creates a token and shares title + URL without image',
    () async {
      repository.nextShare = testShare(
        resourceType: ShareResourceType.outfit,
        outfitId: 'outfit_123',
        sharePath: '/share/shr_outfit',
      );

      final ok = await container
          .read(shareControllerProvider.notifier)
          .shareOutfit(
            wardrobeId: 'wd_abc123',
            outfitId: 'outfit_123',
            title: 'Friday Night',
          );

      expect(ok, isTrue);
      expect(repository.createOutfitCalls, 1);
      expect(images.calls, isEmpty);
      expect(
        sheet.payloads.single.url,
        'https://share.example.com/share/shr_outfit',
      );
      expect(sheet.payloads.single.imagePath, isNull);
    },
  );

  test('missing landing base snacks and skips the API', () async {
    container.dispose();
    container = ProviderContainer.test(
      overrides: shareTestOverrides(
        repository: repository,
        sheet: sheet,
        landingBaseUrl: '',
      ),
    );

    final ok = await container
        .read(shareControllerProvider.notifier)
        .shareItem(
          wardrobeId: 'wd_abc123',
          itemId: 'item_xyz123',
          title: 'Black Nike T-Shirt',
        );

    expect(ok, isFalse);
    expect(repository.createItemCalls, 0);
    expect(sheet.payloads, isEmpty);
    expect(
      container.read(shareControllerProvider).snackMessage,
      ShareErrors.missingLandingBase,
    );
  });

  test('API 404 snacks without opening the sheet', () async {
    repository.nextFailure = const ApiException(
      message: 'Item not found.',
      code: 'ITEM_NOT_FOUND',
      statusCode: 404,
    );

    final ok = await container
        .read(shareControllerProvider.notifier)
        .shareItem(
          wardrobeId: 'wd_abc123',
          itemId: 'item_missing',
          title: 'Gone',
        );

    expect(ok, isFalse);
    expect(sheet.payloads, isEmpty);
    expect(
      container.read(shareControllerProvider).snackMessage,
      ShareErrors.itemNotFound,
    );
  });

  test('undeployed create route snacks unavailable', () async {
    repository.nextFailure = const ApiException(
      message: 'Not Found',
      statusCode: 404,
    );

    final ok = await container
        .read(shareControllerProvider.notifier)
        .shareOutfit(
          wardrobeId: 'wd_abc123',
          outfitId: 'outfit_123',
          title: 'Friday Night',
        );

    expect(ok, isFalse);
    expect(
      container.read(shareControllerProvider).snackMessage,
      ShareErrors.unavailable,
    );
  });

  test('share sheet failure snacks without crashing', () async {
    sheet.nextFailure = StateError('sheet unavailable');

    final ok = await container
        .read(shareControllerProvider.notifier)
        .shareItem(
          wardrobeId: 'wd_abc123',
          itemId: 'item_xyz123',
          title: 'Black Nike T-Shirt',
        );

    expect(ok, isFalse);
    expect(
      container.read(shareControllerProvider).snackMessage,
      ShareErrors.sheetFailed,
    );
  });
}
