import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_gloss.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/widgets/home_clothing_carousel.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  ScrollableState carouselScroll(WidgetTester tester) {
    return tester.state<ScrollableState>(
      find.descendant(
        of: find.byKey(HomeClothingCarousel.carouselKey),
        matching: find.byType(Scrollable),
      ),
    );
  }

  testWidgets('shows clothing from every wardrobe without auto-scroll', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => Scaffold(
            body: HomeClothingCarousel(
              autoScroll: false,
              items: [
                testItem(),
                testItem(
                  id: 'item_coat',
                  wardrobeId: 'wd_winter',
                  name: 'Wool coat',
                  category: ItemCategory.outerwear,
                ),
              ],
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.itemDetail(':wardrobeId', ':itemId'),
          builder: (context, state) => Scaffold(
            body: Text(
              'item ${state.pathParameters['itemId']} '
              '${state.pathParameters['wardrobeId']}',
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(HomeClothingCarousel.carouselKey), findsOneWidget);
    expect(
      find.byKey(HomeClothingCarousel.cardKey('item_xyz123')),
      findsOneWidget,
    );
    expect(
      find.byKey(HomeClothingCarousel.cardKey('item_coat')),
      findsOneWidget,
    );

    expect(find.byType(AppGloss), findsWidgets);
    expect(find.byKey(AppGlossOverlay.overlayKey), findsWidgets);

    await tester.tap(find.byKey(HomeClothingCarousel.cardKey('item_coat')));
    await tester.pumpAndSettle();
    expect(find.text('item item_coat wd_winter'), findsOneWidget);
  });

  testWidgets('auto-scrolls until the user drags', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: HomeClothingCarousel(
            items: [
              testItem(),
              testItem(id: 'item_jeans', name: 'Blue jeans'),
              testItem(id: 'item_hat', name: 'Hat'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final start = carouselScroll(tester).position.pixels;
    await tester.pump(const Duration(milliseconds: 500));
    final afterAuto = carouselScroll(tester).position.pixels;
    expect(afterAuto, greaterThan(start));

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(HomeClothingCarousel.carouselKey)),
    );
    await tester.pump();
    final pausedAt = carouselScroll(tester).position.pixels;
    await tester.pump(const Duration(milliseconds: 500));
    expect(carouselScroll(tester).position.pixels, pausedAt);
    await gesture.moveBy(const Offset(-24, 0));
    await gesture.up();
  });

  testWidgets('reduced motion skips auto-scroll and keeps cards tappable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          );
        },
        home: Scaffold(
          body: HomeClothingCarousel(
            items: [
              testItem(),
              testItem(id: 'item_jeans', name: 'Blue jeans'),
              testItem(id: 'item_hat', name: 'Hat'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final start = carouselScroll(tester).position.pixels;
    await tester.pump(const Duration(milliseconds: 500));
    expect(carouselScroll(tester).position.pixels, start);
    expect(find.byType(AppGloss), findsWidgets);
  });
}
