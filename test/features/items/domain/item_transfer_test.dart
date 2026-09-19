import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_transfer.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  test('canTransferItem is true only for READY and FAILED', () {
    expect(canTransferItem(testItem()), isTrue);
    expect(
      canTransferItem(testItem(processingStatus: ItemProcessingStatus.failed)),
      isTrue,
    );
    expect(
      canTransferItem(testItem(processingStatus: ItemProcessingStatus.pending)),
      isFalse,
    );
    expect(
      canTransferItem(
        testItem(processingStatus: ItemProcessingStatus.processing),
      ),
      isFalse,
    );
  });

  test('destinationsExcluding hides the source wardrobe', () {
    final source = testWardrobe();
    final other = testWardrobe(id: 'wd_other12ab', name: 'Winter');
    expect(
      destinationsExcluding([
        source,
        other,
      ], (wardrobe) => wardrobe.id == source.id).single.id,
      'wd_other12ab',
    );
  });

  test('extractOutfitId reads the Backend outfit token', () {
    expect(
      extractOutfitId(
        'Cannot move an item that is used in an outfit (outfit_friday1). '
        'Remove it from outfits in the source wardrobe first.',
      ),
      'outfit_friday1',
    );
    expect(extractOutfitId('No outfit here.'), isNull);
  });

  test('maps 400 processing and outfit gates', () {
    expect(
      mapItemTransferError(
        const ApiException(
          message: 'Item is still processing. Wait until READY or FAILED before moving or copying.',
          code: 'VALIDATION_ERROR',
          statusCode: 400,
        ),
        kind: ItemTransferKind.move,
      ),
      ItemTransferMessages.processing,
    );
    expect(
      mapItemTransferError(
        const ApiException(
          message:
              'Cannot move an item that is used in an outfit (outfit_friday1).',
          code: 'VALIDATION_ERROR',
          statusCode: 400,
        ),
        kind: ItemTransferKind.move,
      ),
      ItemTransferMessages.outfitBlockWithId('outfit_friday1'),
    );
    expect(
      mapItemTransferError(
        const ApiException(
          message:
              'targetWardrobeId must be a different wardrobe than the source.',
          code: 'VALIDATION_ERROR',
          statusCode: 400,
        ),
        kind: ItemTransferKind.copy,
      ),
      ItemTransferMessages.sameWardrobe,
    );
  });

  test('maps 404 / 401 / 403 codes', () {
    expect(
      mapItemTransferError(
        const ApiException(
          message: 'Wardrobe not found.',
          code: 'WARDROBE_NOT_FOUND',
          statusCode: 404,
        ),
        kind: ItemTransferKind.move,
      ),
      ItemTransferMessages.wardrobeNotFound,
    );
    expect(
      mapItemTransferError(
        const ApiException(
          message: 'Item not found.',
          code: 'ITEM_NOT_FOUND',
          statusCode: 404,
        ),
        kind: ItemTransferKind.copy,
      ),
      ItemTransferMessages.itemNotFound,
    );
    expect(
      mapItemTransferError(
        const ApiException(
          message: 'Missing token.',
          code: 'UNAUTHENTICATED',
          statusCode: 401,
        ),
        kind: ItemTransferKind.move,
      ),
      ItemTransferMessages.unauthenticated,
    );
    expect(
      mapItemTransferError(
        const ApiException(
          message: 'Free includes 5 clothing items.',
          code: 'ENTITLEMENT_ITEM_LIMIT',
          statusCode: 403,
        ),
        kind: ItemTransferKind.copy,
      ),
      ItemTransferMessages.itemLimitUpgrade,
    );
  });

  test(
    '403 ENTITLEMENT_ITEM_LIMIT maps to the existing item-limit paywall',
    () {
      expect(
        itemTransferPaywallPlacement(
          const ApiException(
            message: 'Free includes 5 clothing items.',
            code: 'ENTITLEMENT_ITEM_LIMIT',
            statusCode: 403,
          ),
        ),
        PaywallPlacement.itemLimit,
      );
      expect(
        itemTransferPaywallPlacement(
          const ApiException(message: 'Upgrade required.', statusCode: 403),
        ),
        PaywallPlacement.itemLimit,
      );
    },
  );
}
