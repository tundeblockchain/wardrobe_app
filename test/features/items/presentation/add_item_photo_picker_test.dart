import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/presentation/add_item_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('add-item gallery pick uses the picker and keeps camera', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobeDetailScreen.addItemButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemScreen), findsOneWidget);
    expect(find.byKey(AddItemScreen.galleryButtonKey), findsOneWidget);
    expect(find.byKey(AddItemScreen.cameraButtonKey), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);

    await tester.tap(find.byKey(AddItemScreen.galleryButtonKey));
    await tester.pumpAndSettle();

    expect(harness.picker.galleryCalls, 1);
    expect(harness.picker.cameraCalls, 0);
    expect(find.byType(AddItemScreen), findsOneWidget);
  });
}
