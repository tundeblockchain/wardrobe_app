import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_item_slider.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  testWidgets('shows cropped image cards for assigned items', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final top = testItem(
      id: 'item_top123',
      name: 'Black tee',
      originalImageUrl: 'https://cdn.example.com/top.jpg',
    );
    final tapped = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: OutfitItemSlider(
            assignments: const [
              OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
              OutfitItem(itemId: 'item_missing', slot: ItemCategory.bottom),
            ],
            wardrobeItems: [top],
            onItemTap: tapped.add,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(OutfitItemSlider.sliderKey), findsOneWidget);
    expect(find.byKey(OutfitItemSlider.cardKey('item_top123')), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.imageKey(top.id)), findsOneWidget);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);
    expect(find.text('Black tee'), findsOneWidget);
    expect(
      find.byKey(OutfitItemSlider.cardKey('item_missing')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(OutfitItemSlider.cardKey('item_top123')));
    expect(tapped, ['item_top123']);
  });
}
