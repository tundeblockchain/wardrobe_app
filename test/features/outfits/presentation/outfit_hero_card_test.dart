import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/enlarged_image_popup.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_hero_card.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_try_on_gallery.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, {required Widget child}) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: ListView(children: [child])),
      ),
    );
    await tester.pump();
  }

  testWidgets('without a try-on URL the card goes to Try On', (tester) async {
    var tryOn = 0;
    await pumpCard(
      tester,
      child: OutfitHeroCard(outfit: testOutfit(), onTryOn: () => tryOn++),
    );

    expect(find.byKey(OutfitHeroCard.cardKey), findsOneWidget);
    expect(find.byKey(OutfitHeroCard.tryOnHintKey), findsOneWidget);
    expect(find.text('Tap to try on'), findsOneWidget);

    await tester.tap(find.byKey(OutfitHeroCard.cardKey));
    expect(tryOn, 1);
  });

  testWidgets('with render.imageUrl the card crops and opens a popup', (
    tester,
  ) async {
    var tryOn = 0;
    const url = 'https://cdn.example.com/try-on/outfit_123.png';
    await pumpCard(
      tester,
      child: OutfitHeroCard(
        outfit: testOutfit(render: testOutfitRender()),
        onTryOn: () => tryOn++,
      ),
    );

    expect(find.byKey(OutfitHeroCard.imageKey), findsOneWidget);
    expect(find.byKey(OutfitHeroCard.urlKey(url)), findsOneWidget);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);

    await tester.tap(find.byKey(OutfitHeroCard.cardKey));
    await tester.pumpAndSettle();

    expect(tryOn, 0);
    expect(find.byKey(EnlargedImagePopup.dialogKey), findsOneWidget);
  });

  testWidgets('multiple history photos become a swipe gallery', (tester) async {
    await pumpCard(
      tester,
      child: OutfitHeroCard(
        outfit: testOutfit(render: testOutfitRender()),
        history: [
          testTryOnHistoryEntry(
            render: testOutfitRender(
              imageUrl: 'https://cdn.example.com/try-on/latest.png',
            ),
          ),
          testTryOnHistoryEntry(
            render: testOutfitRender(
              imageUrl: 'https://cdn.example.com/try-on/older.png',
            ),
          ),
        ],
        onTryOn: () {},
      ),
    );

    expect(find.byKey(OutfitTryOnGallery.galleryKey), findsOneWidget);
    expect(find.byKey(OutfitHeroCard.tryOnHintKey), findsNothing);
  });
}
