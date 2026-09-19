import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/widgets/enlarged_image_popup.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/data/paywall_gateway_provider.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_detail_meta.dart';
import 'package:wardrobe_app/features/items/domain/item_transfer.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_detail_meta_block.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_transfer_sheet.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/presentation/widgets/related_shopping_links_section.dart';
import 'package:wardrobe_app/features/shopping_links/presentation/widgets/shopping_product_card.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_entitlements.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_shopping_link_opener.dart';
import '../../../helpers/fake_shopping_links_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  Future<void> pumpDetail(
    WidgetTester tester, {
    FakeItemRepository? repository,
    FakeWardrobeRepository? wardrobes,
    FakeOutfitRepository? outfits,
    FakeShoppingLinksRepository? shoppingLinks,
    FakeShoppingLinkOpener? shoppingOpener,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemRepositoryProvider.overrideWithValue(
            repository ?? FakeItemRepository(seed: [testItem()]),
          ),
          wardrobeRepositoryProvider.overrideWithValue(
            wardrobes ??
                FakeWardrobeRepository(
                  seed: [
                    testWardrobe(),
                    testWardrobe(id: 'wd_other12ab', name: 'Winter'),
                  ],
                ),
          ),
          entitlementRepositoryProvider.overrideWithValue(
            FakeEntitlementRepository(),
          ),
          paywallGatewayProvider.overrideWithValue(FakePaywallGateway()),
          outfitRepositoryProvider.overrideWithValue(
            outfits ?? FakeOutfitRepository(),
          ),
          shoppingLinksRepositoryProvider.overrideWithValue(
            shoppingLinks ?? FakeShoppingLinksRepository(),
          ),
          shoppingLinkOpenerProvider.overrideWithValue(
            shoppingOpener ?? FakeShoppingLinkOpener(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: const MaterialApp(
          home: ItemDetailScreen(
            wardrobeId: 'wd_abc123',
            itemId: 'item_xyz123',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('item detail does not show Added or Updated datestamps', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(ItemDetailScreen), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
    expect(find.text('Top'), findsWidgets);
    expect(find.text('Nike'), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.imageKey('item_xyz123')), findsOneWidget);
    expect(find.byType(ProcessingStatusBanner), findsNothing);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Processed'), findsNothing);
    expect(find.text('Ready'), findsNothing);
    expect(find.text('Failed'), findsNothing);
    expect(find.byKey(ItemDetailScreen.editButtonKey), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.deleteButtonKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets('shows FAILED processingError and a retry CTA', (tester) async {
    await pumpDetail(
      tester,
      repository: FakeItemRepository(
        seed: [
          testItem(
            processingStatus: ItemProcessingStatus.failed,
            processingError: 'Background removal failed.',
          ),
        ],
      ),
    );

    expect(find.byType(ProcessingStatusBanner), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Background removal failed.'), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.reprocessButtonKey), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Ready'), findsNothing);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
    expect(find.byKey(ItemBrowseImage.imageKey('item_xyz123')), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.deleteButtonKey), findsOneWidget);
  });

  testWidgets('reprocess 400 shows a snackbar and keeps retry', (tester) async {
    final repository = FakeItemRepository(
      seed: [testItem(processingStatus: ItemProcessingStatus.failed)],
    );
    await pumpDetail(tester, repository: repository);
    repository.nextFailure = const ApiException(
      message: 'Item has no original image to reprocess.',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );

    await tester.tap(find.byKey(ItemDetailScreen.reprocessButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.text('Item has no original image to reprocess.'),
      findsOneWidget,
    );
    expect(find.byKey(ItemDetailScreen.reprocessButtonKey), findsOneWidget);
    expect(repository.reprocessCalls, 1);
  });

  testWidgets('retry applies PENDING and hides the failed CTA', (tester) async {
    final repository = FakeItemRepository(
      seed: [
        testItem(
          processingStatus: ItemProcessingStatus.failed,
          processingError: 'Background removal failed.',
        ),
      ],
    );
    await pumpDetail(tester, repository: repository);

    await tester.tap(find.byKey(ItemDetailScreen.reprocessButtonKey));
    await tester.pumpAndSettle();

    expect(repository.reprocessCalls, 1);
    expect(find.text('Failed'), findsNothing);
    expect(find.text('Background removal failed.'), findsNothing);
    expect(find.byKey(ItemDetailScreen.reprocessButtonKey), findsNothing);
    expect(find.text('Pending'), findsNothing);
  });

  testWidgets('shows meta block with wardrobe membership and outfit usage', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      outfits: FakeOutfitRepository(
        seed: [
          testOutfit().copyWith(
            items: const [
              OutfitItem(itemId: 'item_xyz123', slot: ItemCategory.top),
            ],
          ),
          testOutfit(id: 'outfit_other', name: 'Office'),
        ],
      ),
    );

    expect(find.byType(ItemDetailMetaBlock), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Subcategory'), findsOneWidget);
    expect(find.text('Colours'), findsOneWidget);
    expect(find.text('Brand'), findsOneWidget);
    expect(find.text('Acquired'), findsOneWidget);
    expect(find.text('T-shirt'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(find.text('Summer Clothes'), findsOneWidget);
    expect(find.text('Friday Night'), findsOneWidget);
    expect(find.text('Office'), findsNothing);
    expect(find.byType(ProcessingStatusBanner), findsNothing);
  });

  testWidgets('keeps empty meta rows visible as placeholders', (tester) async {
    await pumpDetail(
      tester,
      repository: FakeItemRepository(
        seed: [testItem(subcategory: null, colours: const [], brand: null)],
      ),
    );

    expect(find.byKey(ItemDetailMetaBlock.categoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.subcategoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.coloursRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.brandRowKey), findsOneWidget);
    expect(find.text(ItemDetailMeta.emptyPlaceholder), findsNWidgets(5));
    expect(find.text('Summer Clothes'), findsOneWidget);
  });

  testWidgets('tapping the item image card opens an enlarged popup', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.tap(find.byKey(ItemDetailScreen.imageTapKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EnlargedImagePopup.dialogKey), findsOneWidget);
    expect(find.byKey(EnlargedImagePopup.closeKey), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.imageKey('item_xyz123')), findsWidgets);

    await tester.tap(find.byKey(EnlargedImagePopup.closeKey));
    await tester.pumpAndSettle();
    expect(find.byKey(EnlargedImagePopup.dialogKey), findsNothing);
  });

  testWidgets('item detail shows empty related shopping links', (tester) async {
    await pumpDetail(tester);

    expect(find.byKey(RelatedShoppingLinksSection.sectionKey), findsOneWidget);
    expect(find.text('Related shopping links'), findsOneWidget);
    expect(find.text('No similar products to shop yet.'), findsOneWidget);
    expect(find.byType(ShoppingProductCard), findsNothing);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
  });

  testWidgets('item detail shopping cards open externally', (tester) async {
    final opener = FakeShoppingLinkOpener();
    final link = testShoppingLink();
    await pumpDetail(
      tester,
      shoppingOpener: opener,
      shoppingLinks: FakeShoppingLinksRepository(
        byItem: {
          'item_xyz123': [link],
        },
      ),
    );

    expect(find.byType(ShoppingProductCard), findsOneWidget);
    expect(find.text('Black cotton tee'), findsOneWidget);
    await tester.tap(find.byKey(ShoppingProductCard.cardKey(link.url)));
    await tester.pump();
    expect(opener.opened, [Uri.parse(link.url)]);
  });

  testWidgets('overflow Move / Copy opens a picker that hides this wardrobe', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byKey(ItemDetailScreen.overflowMenuKey), findsOneWidget);
    await tester.tap(find.byKey(ItemDetailScreen.overflowMenuKey));
    await tester.pumpAndSettle();
    expect(find.byKey(ItemDetailScreen.moveMenuKey), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.copyMenuKey), findsOneWidget);

    await tester.tap(find.byKey(ItemDetailScreen.copyMenuKey));
    await tester.pumpAndSettle();

    expect(find.byKey(ItemTransferSheet.sheetKey), findsOneWidget);
    expect(find.text('Copy to another wardrobe'), findsOneWidget);
    expect(find.text('Winter'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(ItemTransferSheet.sheetKey),
        matching: find.text('Summer Clothes'),
      ),
      findsNothing,
    );
    expect(
      find.byKey(ItemTransferSheet.destinationKey('wd_abc123')),
      findsNothing,
    );
  });

  testWidgets('copy confirm shows a success snackbar and keeps the item', (
    tester,
  ) async {
    final items = FakeItemRepository(seed: [testItem()]);
    await pumpDetail(tester, repository: items);

    await tester.tap(find.byKey(ItemDetailScreen.overflowMenuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemDetailScreen.copyMenuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Winter'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemTransferSheet.confirmKey));
    await tester.pumpAndSettle();

    expect(items.copyCalls, 1);
    expect(items.lastTargetWardrobeId, 'wd_other12ab');
    expect(find.text('Copied to Winter.'), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
  });

  testWidgets('move while the item is on an outfit shows a clear block', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      outfits: FakeOutfitRepository(
        seed: [
          testOutfit().copyWith(
            items: const [
              OutfitItem(itemId: 'item_xyz123', slot: ItemCategory.top),
            ],
          ),
        ],
      ),
    );

    await tester.tap(find.byKey(ItemDetailScreen.overflowMenuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemDetailScreen.moveMenuKey));
    await tester.pumpAndSettle();

    expect(find.text(ItemTransferMessages.outfitBlock), findsOneWidget);
    expect(find.byKey(ItemTransferSheet.sheetKey), findsNothing);
  });

  testWidgets('copy 403 surfaces an upgrade CTA instead of a raw code', (
    tester,
  ) async {
    final items = FakeItemRepository(seed: [testItem()]);
    await pumpDetail(tester, repository: items);
    items.nextFailure = const ApiException(
      message: 'Free includes 5 clothing items.',
      code: 'ENTITLEMENT_ITEM_LIMIT',
      statusCode: 403,
    );

    await tester.tap(find.byKey(ItemDetailScreen.overflowMenuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemDetailScreen.copyMenuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Winter'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemTransferSheet.confirmKey));
    await tester.pumpAndSettle();

    expect(find.text(ItemTransferMessages.itemLimitUpgrade), findsWidgets);
    expect(find.textContaining('ENTITLEMENT_ITEM_LIMIT'), findsNothing);
  });
}
