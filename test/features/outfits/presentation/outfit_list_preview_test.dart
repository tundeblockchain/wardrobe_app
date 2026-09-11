import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_preview.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  Future<void> pumpPreview(WidgetTester tester, {required Widget child}) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
    await tester.pump();
  }

  test('outfitPreviewImageUrl uses render.imageUrl and ignores empty', () {
    expect(outfitPreviewImageUrl(testOutfit()), isNull);
    expect(
      outfitPreviewImageUrl(testOutfit(render: testOutfitRender())),
      'https://cdn.example.com/try-on/outfit_123.png',
    );
    expect(
      outfitPreviewImageUrl(
        testOutfit(render: testOutfitRender(imageUrl: '   ')),
      ),
      isNull,
    );
  });

  testWidgets('shows hanger when the outfit has no preview URL', (
    tester,
  ) async {
    final outfit = testOutfit();

    await pumpPreview(tester, child: OutfitListPreview(outfit: outfit));

    expect(find.byKey(OutfitListPreview.hangerKey(outfit.id)), findsOneWidget);
    expect(find.byKey(OutfitListPreview.imageKey(outfit.id)), findsNothing);
    expect(find.byIcon(Icons.checkroom_outlined), findsOneWidget);
  });

  testWidgets('shows the render imageUrl with cover framing', (tester) async {
    final outfit = testOutfit(render: testOutfitRender());
    const url = 'https://cdn.example.com/try-on/outfit_123.png';

    await pumpPreview(tester, child: OutfitListPreview(outfit: outfit));

    expect(find.byKey(OutfitListPreview.imageKey(outfit.id)), findsOneWidget);
    expect(find.byKey(OutfitListPreview.urlKey(url)), findsOneWidget);
    expect(find.byKey(OutfitListPreview.hangerKey(outfit.id)), findsNothing);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);
  });

  testWidgets('falls back to an assigned item photo when there is no render', (
    tester,
  ) async {
    final outfit = testOutfit();
    final item = testItem(
      id: 'item_top123',
      originalImageUrl: 'https://cdn.example.com/top.jpg',
    );

    await pumpPreview(
      tester,
      child: OutfitListPreview(outfit: outfit, wardrobeItems: [item]),
    );

    expect(find.byKey(OutfitListPreview.imageKey(outfit.id)), findsOneWidget);
    expect(
      find.byKey(OutfitListPreview.itemSourceKey(item.id)),
      findsOneWidget,
    );
    expect(find.byKey(OutfitListPreview.hangerKey(outfit.id)), findsNothing);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);
  });

  testWidgets('heroImageUrl wins over the outfit render', (tester) async {
    const hero = 'https://cdn.example.com/try-on/picked.png';
    final outfit = testOutfit(render: testOutfitRender());

    await pumpPreview(
      tester,
      child: OutfitListPreview(outfit: outfit, heroImageUrl: hero),
    );

    expect(find.byKey(OutfitListPreview.urlKey(hero)), findsOneWidget);
    expect(
      find.byKey(
        OutfitListPreview.urlKey(
          'https://cdn.example.com/try-on/outfit_123.png',
        ),
      ),
      findsNothing,
    );
  });
}
