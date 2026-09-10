import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_detail_meta.dart';
import 'package:wardrobe_app/core/widgets/enlarged_image_popup.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_detail_meta_block.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  Future<void> pumpDetail(
    WidgetTester tester, {
    FakeItemRepository? repository,
    FakeWardrobeRepository? wardrobes,
    FakeOutfitRepository? outfits,
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
            wardrobes ?? FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          outfitRepositoryProvider.overrideWithValue(
            outfits ?? FakeOutfitRepository(),
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

  testWidgets('hides FAILED status and processingError while keeping delete', (
    tester,
  ) async {
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

    expect(find.byType(ProcessingStatusBanner), findsNothing);
    expect(find.text('Failed'), findsNothing);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Processed'), findsNothing);
    expect(find.text('Background removal failed.'), findsNothing);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
    expect(find.byKey(ItemBrowseImage.imageKey('item_xyz123')), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.deleteButtonKey), findsOneWidget);
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
    expect(find.text(ItemDetailMeta.emptyPlaceholder), findsNWidgets(4));
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
}
