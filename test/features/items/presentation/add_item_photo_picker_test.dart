import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/presentation/add_item_screen.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';

import '../../../helpers/fake_item_image_picker.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('add-item gallery pick still uploads and creates the item', (
    tester,
  ) async {
    final harness = TestAppHarness();
    harness.picker.image = FakeItemImagePicker.sample();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('wardrobe_tile_wd_abc123')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobeDetailScreen.addItemButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemScreen), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);

    await tester.tap(find.byKey(AddItemScreen.galleryButtonKey));
    await tester.pumpAndSettle();

    expect(harness.picker.galleryCalls, 1);
    expect(harness.picker.cameraCalls, 0);

    await tester.enterText(find.byKey(AddItemScreen.nameFieldKey), 'Black tee');
    await tester.tap(find.byKey(AddItemScreen.categoryFieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Top').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddItemScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(harness.uploads.createCalls, 1);
    expect(harness.uploads.uploadCalls, 1);
    expect(harness.items.createCalls, 1);
    expect(harness.items.lastImageKey, 'users/uid/uploads/uuid.jpg');
    expect(find.byType(ItemDetailScreen), findsOneWidget);
  });
}
