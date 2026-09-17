import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/search/application/app_search_providers.dart';
import 'package:wardrobe_app/features/search/domain/app_search.dart';
import 'package:wardrobe_app/features/search/presentation/app_search_hit_thumbnail.dart';
import 'package:wardrobe_app/features/search/presentation/app_search_results.dart';

void main() {
  const itemHit = AppSearchHit(
    kind: AppSearchHitKind.item,
    id: 'item_xyz123',
    wardrobeId: 'wd_abc123',
    title: 'Black Nike T-Shirt',
    subtitle: 'Top',
    imageUrl: 'https://cdn.example.com/processed.png',
  );

  const missingItemHit = AppSearchHit(
    kind: AppSearchHitKind.item,
    id: 'item_plain',
    wardrobeId: 'wd_abc123',
    title: 'Plain tee',
  );

  const outfitHit = AppSearchHit(
    kind: AppSearchHitKind.outfit,
    id: 'outfit_123',
    wardrobeId: 'wd_abc123',
    title: 'Friday Night',
    subtitle: 'Outfit',
    imageUrl: 'https://cdn.example.com/try-on/outfit_123.png',
  );

  const wardrobeHit = AppSearchHit(
    kind: AppSearchHitKind.wardrobe,
    id: 'wd_abc123',
    wardrobeId: 'wd_abc123',
    title: 'Summer',
    subtitle: 'Wardrobe',
  );

  Future<void> pumpResults(
    WidgetTester tester, {
    required AppSearchResults results,
    bool reduceMotion = false,
  }) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Widget child = ProviderScope(
      overrides: [appSearchResultsProvider.overrideWithValue(results)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: AppSearchResultsPanel(onClose: () {})),
      ),
    );
    if (reduceMotion) {
      child = MediaQuery(
        data: const MediaQueryData(
          disableAnimations: true,
          size: Size(400, 800),
        ),
        child: child,
      );
    }

    await tester.pumpWidget(child);
    await tester.pump();
  }

  testWidgets('item hits with a list-DTO URL show a thumbnail', (tester) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(items: [itemHit]),
    );

    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, itemHit.id),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        AppSearchHitThumbnail.thumbnailKey(AppSearchHitKind.item, itemHit.id),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(AppSearchHitThumbnail.imageKey(itemHit.imageUrl!)),
      findsOneWidget,
    );
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);
    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
  });

  testWidgets('missing item photos keep a placeholder and the row', (
    tester,
  ) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(items: [missingItemHit]),
    );

    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, missingItemHit.id),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        AppSearchHitThumbnail.placeholderKey(
          AppSearchHitKind.item,
          missingItemHit.id,
        ),
      ),
      findsOneWidget,
    );
    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.checkroom_outlined), findsOneWidget);
    expect(find.text('Plain tee'), findsOneWidget);
  });

  testWidgets('failed item thumbnails soft-fail to a placeholder', (
    tester,
  ) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(items: [itemHit]),
    );

    expect(
      find.byKey(AppSearchHitThumbnail.imageKey(itemHit.imageUrl!)),
      findsOneWidget,
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, itemHit.id),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        AppSearchHitThumbnail.placeholderKey(AppSearchHitKind.item, itemHit.id),
      ),
      findsOneWidget,
    );
    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
  });

  testWidgets('outfit hits show a cover URL already on the model', (
    tester,
  ) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(outfits: [outfitHit]),
    );

    expect(
      find.byKey(AppSearchHitThumbnail.imageKey(outfitHit.imageUrl!)),
      findsOneWidget,
    );
    expect(find.text('Friday Night'), findsOneWidget);
  });

  testWidgets('wardrobe hits stay on a kind icon when there is no cover', (
    tester,
  ) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(wardrobes: [wardrobeHit]),
    );

    expect(
      find.byKey(
        AppSearchHitThumbnail.placeholderKey(
          AppSearchHitKind.wardrobe,
          wardrobeHit.id,
        ),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.door_sliding_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('reduced motion skips the thumbnail loading spinner', (
    tester,
  ) async {
    await pumpResults(
      tester,
      results: const AppSearchResults(items: [itemHit]),
      reduceMotion: true,
    );

    expect(
      AppMotion.reduce(tester.element(find.byType(AppSearchResultsPanel))),
      isTrue,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      find.byKey(
        AppSearchResultsPanel.tileKey(AppSearchHitKind.item, itemHit.id),
      ),
      findsOneWidget,
    );
  });
}
