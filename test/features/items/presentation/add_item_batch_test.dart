import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/presentation/add_item_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';

import '../../../helpers/fake_item_image_picker.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('gallery multi-pick shows a batch form and saves each item', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness();
    harness.picker.images = [
      FakeItemImagePicker.sample(fileName: 'shirt.jpg'),
      FakeItemImagePicker.sample(bytes: const [4, 5, 6], fileName: 'jeans.jpg'),
    ];
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobeDetailScreen.addItemButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(AddItemScreen.galleryButtonKey));
    await tester.pumpAndSettle();

    expect(harness.picker.multiGalleryCalls, 1);
    expect(find.byKey(AddItemScreen.batchStripKey), findsOneWidget);
    expect(find.byKey(AddItemScreen.batchNameFieldKey(0)), findsOneWidget);
    expect(find.byKey(AddItemScreen.batchNameFieldKey(1)), findsOneWidget);
    expect(find.text('Save 2 items'), findsOneWidget);

    await tester.tap(find.byKey(AddItemScreen.categoryFieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Top').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddItemScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(harness.uploads.createCalls, 2);
    expect(harness.items.createCalls, 2);
    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.byType(AddItemScreen), findsNothing);
  });

  testWidgets('partial batch failure keeps successes and lists each result', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness();
    harness.picker.images = [
      FakeItemImagePicker.sample(fileName: 'ok.jpg'),
      FakeItemImagePicker.sample(bytes: const [9], fileName: 'bad.jpg'),
    ];
    harness.items.failOnCreateCall = 2;
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobeDetailScreen.addItemButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddItemScreen.galleryButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(AddItemScreen.categoryFieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Top').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddItemScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemScreen), findsOneWidget);
    expect(find.byKey(AddItemScreen.batchResultKey), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Could not save this item.'), findsOneWidget);
    expect(find.text('1 saved. 1 failed.'), findsOneWidget);
    expect(find.byKey(AddItemScreen.doneButtonKey), findsOneWidget);
    expect(find.text('Retry failed'), findsOneWidget);
    expect(harness.items.createCalls, 2);
  });

  testWidgets('empty wardrobe gallery CTA auto-opens multi-pick', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness(items: FakeItemRepository());
    harness.picker.images = [
      FakeItemImagePicker.sample(fileName: 'coat.jpg'),
      FakeItemImagePicker.sample(bytes: const [7], fileName: 'hat.jpg'),
    ];
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add from gallery'));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemScreen), findsOneWidget);
    expect(harness.picker.multiGalleryCalls, 1);
    expect(find.byKey(AddItemScreen.batchStripKey), findsOneWidget);
    expect(find.text('Save 2 items'), findsOneWidget);
  });
}
