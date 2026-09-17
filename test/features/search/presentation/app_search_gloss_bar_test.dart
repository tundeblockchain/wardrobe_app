import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfit_detail_screen.dart';
import 'package:wardrobe_app/features/search/domain/app_search.dart';
import 'package:wardrobe_app/features/search/presentation/app_search_gloss_bar.dart';
import 'package:wardrobe_app/features/search/presentation/app_search_hit_thumbnail.dart';
import 'package:wardrobe_app/features/search/presentation/app_search_results.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  Future<TestAppHarness> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
      items: FakeItemRepository(seed: [testItem()]),
      outfits: FakeOutfitRepository(seed: [testOutfit()]),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> openSearch(WidgetTester tester, String query) async {
    await tester.tap(find.byKey(AppSearchGlossBar.searchButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(AppSearchGlossBar.fieldKey), query);
    await tester.pumpAndSettle();
  }

  testWidgets('header search is on the home gloss bar', (tester) async {
    await pumpHome(tester);

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.byKey(AppSearchGlossBar.searchButtonKey), findsOneWidget);
    expect(find.byKey(AppSearchResultsPanel.panelKey), findsNothing);
  });

  testWidgets('empty query keeps the results panel closed', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(AppSearchGlossBar.searchButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(AppSearchGlossBar.fieldKey), findsOneWidget);
    expect(find.byKey(AppSearchResultsPanel.panelKey), findsNothing);

    await tester.enterText(find.byKey(AppSearchGlossBar.fieldKey), '   ');
    await tester.pumpAndSettle();
    expect(find.byKey(AppSearchResultsPanel.panelKey), findsNothing);
  });

  testWidgets('query matches item, outfit, and wardrobe and navigates', (
    tester,
  ) async {
    await pumpHome(tester);

    await openSearch(tester, 'Black');
    expect(find.byKey(AppSearchResultsPanel.panelKey), findsOneWidget);
    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, 'item_xyz123'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        AppSearchHitThumbnail.placeholderKey(
          AppSearchHitKind.item,
          'item_xyz123',
        ),
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(AppSearchGlossBar.fieldKey), 'Friday');
    await tester.pumpAndSettle();
    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.outfit, 'outfit_123'),
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(AppSearchGlossBar.fieldKey), 'Summer');
    await tester.pumpAndSettle();
    final wardrobeTile = find.byKey(
      AppSearchResultsPanel.tileKey(AppSearchHitKind.wardrobe, 'wd_abc123'),
    );
    expect(wardrobeTile, findsOneWidget);

    await tester.tap(wardrobeTile);
    await tester.pumpAndSettle();
    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
  });

  testWidgets('tapping an item hit opens item detail', (tester) async {
    await pumpHome(tester);
    await openSearch(tester, 'Nike');
    await tester.tap(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, 'item_xyz123'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ItemDetailScreen), findsOneWidget);
  });

  testWidgets('tapping an outfit hit opens outfit detail', (tester) async {
    await pumpHome(tester);
    await openSearch(tester, 'Friday');
    await tester.tap(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.outfit, 'outfit_123'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OutfitDetailScreen), findsOneWidget);
  });

  testWidgets('reduced motion still shows results without a fade', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
      items: FakeItemRepository(seed: [testItem()]),
      outfits: FakeOutfitRepository(seed: [testOutfit()]),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          disableAnimations: true,
          size: Size(400, 1400),
        ),
        child: harness.app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      AppMotion.reduce(tester.element(find.byType(WardrobesScreen))),
      isTrue,
    );

    await openSearch(tester, 'Nike');
    expect(find.byKey(AppSearchResultsPanel.panelKey), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, 'item_xyz123'),
      ),
      findsOneWidget,
    );
  });
}
