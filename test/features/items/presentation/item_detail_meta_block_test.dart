import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_detail_meta.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_detail_meta_block.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  Future<void> pumpBlock(
    WidgetTester tester, {
    required Item item,
    List<ItemDetailMetaLink> wardrobes = const [],
    List<ItemDetailMetaLink> outfits = const [],
    ValueChanged<String>? onWardrobeTap,
    ValueChanged<String>? onOutfitTap,
  }) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ItemDetailMetaBlock(
              item: item,
              wardrobes: wardrobes,
              outfits: outfits,
              onWardrobeTap: onWardrobeTap,
              onOutfitTap: onOutfitTap,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('always renders category, subcategory, colours, and brand', (
    tester,
  ) async {
    await pumpBlock(tester, item: testItem());

    expect(find.byType(ItemDetailMetaBlock), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.categoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.subcategoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.coloursRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.brandRowKey), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Subcategory'), findsOneWidget);
    expect(find.text('Colours'), findsOneWidget);
    expect(find.text('Brand'), findsOneWidget);
    expect(find.text('Top'), findsOneWidget);
    expect(find.text('T-shirt'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);
    expect(find.text('Nike'), findsOneWidget);
    expect(find.byType(ProcessingStatusBanner), findsNothing);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Ready'), findsNothing);
    expect(find.text('Failed'), findsNothing);
  });

  testWidgets('keeps empty rows visible with a placeholder', (tester) async {
    await pumpBlock(
      tester,
      item: testItem(subcategory: null, colours: const [], brand: null),
    );

    expect(find.byKey(ItemDetailMetaBlock.categoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.subcategoryRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.coloursRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.brandRowKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.wardrobesSectionKey), findsOneWidget);
    expect(find.byKey(ItemDetailMetaBlock.outfitsSectionKey), findsOneWidget);
    expect(find.text('Top'), findsOneWidget);
    expect(find.text(ItemDetailMeta.emptyPlaceholder), findsNWidgets(5));
  });

  testWidgets('shows AI subcategory and colours when user fields are empty', (
    tester,
  ) async {
    await pumpBlock(
      tester,
      item: testItem(
        subcategory: null,
        colours: const [],
        brand: null,
        ai: const ItemAiMetadata(
          detectedCategory: ItemCategory.top,
          detectedSubcategory: 'HOODIE',
          detectedColours: ['GREY', 'BURGUNDY'],
        ),
      ),
    );

    expect(find.text('Hoodie'), findsOneWidget);
    expect(find.text('Grey'), findsOneWidget);
    expect(find.text('Burgundy'), findsOneWidget);
    expect(find.text(ItemDetailMeta.emptyPlaceholder), findsNWidgets(3));
  });

  testWidgets('shows wardrobe and outfit chips and reports taps', (
    tester,
  ) async {
    String? wardrobeId;
    String? outfitId;
    await pumpBlock(
      tester,
      item: testItem(),
      wardrobes: const [
        ItemDetailMetaLink(id: 'wd_abc123', label: 'Summer Clothes'),
      ],
      outfits: const [
        ItemDetailMetaLink(id: 'outfit_123', label: 'Friday Night'),
      ],
      onWardrobeTap: (id) => wardrobeId = id,
      onOutfitTap: (id) => outfitId = id,
    );

    expect(find.text('Summer Clothes'), findsOneWidget);
    expect(find.text('Friday Night'), findsOneWidget);

    await tester.tap(
      find.byKey(ItemDetailMetaBlock.wardrobeChipKey('wd_abc123')),
    );
    await tester.tap(
      find.byKey(ItemDetailMetaBlock.outfitChipKey('outfit_123')),
    );

    expect(wardrobeId, 'wd_abc123');
    expect(outfitId, 'outfit_123');
  });
}
