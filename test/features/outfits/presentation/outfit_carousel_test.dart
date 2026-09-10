import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_carousel.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_preview.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_tile.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  testWidgets('carousel prefers try-on photo then item photo then hanger', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/outfits',
      routes: [
        GoRoute(
          path: '/outfits',
          builder: (context, state) => Scaffold(
            body: OutfitCarousel(
              wardrobeId: 'wd_abc123',
              outfits: [
                testOutfit(id: 'outfit_render', render: testOutfitRender()),
                testOutfit(id: 'outfit_item'),
                testOutfit(id: 'outfit_hanger', name: 'No photos'),
              ],
              wardrobeItems: [
                testItem(
                  id: 'item_top123',
                  originalImageUrl: 'https://cdn.example.com/top.jpg',
                ),
              ],
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.outfitDetail('wd_abc123', ':outfitId'),
          builder: (context, state) => Scaffold(
            body: Text('detail ${state.pathParameters['outfitId']}'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    );
    await tester.pump();

    expect(find.byKey(OutfitCarousel.carouselKey), findsOneWidget);
    expect(
      find.byKey(OutfitListPreview.imageKey('outfit_render')),
      findsOneWidget,
    );
    expect(
      find.byKey(OutfitListPreview.itemSourceKey('item_top123')),
      findsOneWidget,
    );
    expect(
      find.byKey(OutfitListPreview.hangerKey('outfit_hanger')),
      findsOneWidget,
    );
    expect(
      tester
          .widgetList<Image>(find.byType(Image))
          .every((image) => image.fit == BoxFit.cover),
      isTrue,
    );

    await tester.tap(find.byKey(OutfitCarousel.cardKey('outfit_render')));
    await tester.pumpAndSettle();
    expect(find.text('detail outfit_render'), findsOneWidget);
  });

  testWidgets('carousel delete control uses the shared outfit tile key', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var deleted = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: OutfitCarousel(
            wardrobeId: 'wd_abc123',
            outfits: [testOutfit()],
            onDelete: (_) => deleted++,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(OutfitListTile.deleteKey('outfit_123')), findsOneWidget);
    await tester.tap(find.byKey(OutfitListTile.deleteKey('outfit_123')));
    expect(deleted, 1);
  });
}
