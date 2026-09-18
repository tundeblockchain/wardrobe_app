import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_colors.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_gloss.dart';
import 'package:wardrobe_app/features/coaches/data/coach_preferences.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';
import 'package:wardrobe_app/features/coaches/presentation/feature_coach_overlay.dart';
import 'package:wardrobe_app/features/coaches/presentation/screen_coach_host.dart';
import 'package:wardrobe_app/features/shopping_links/presentation/widgets/related_shopping_links_section.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_shopping_links_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

Future<void> pumpHost(
  WidgetTester tester, {
  required CoachPreferences prefs,
  CoachScreen screen = CoachScreen.home,
  bool reduceMotion = false,
  ThemeData? theme,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [coachPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        theme: theme ?? AppTheme.light(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: reduceMotion),
            child: child!,
          );
        },
        home: ScreenCoachHost(
          screen: screen,
          child: const Scaffold(body: Text('Screen body')),
        ),
      ),
    ),
  );
  await tester.pump();
  if (!reduceMotion) {
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('first visit shows copy, Got it, and a spotlight card', (
    tester,
  ) async {
    final prefs = InMemoryCoachPreferences();
    await pumpHost(tester, prefs: prefs);

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsOneWidget);
    expect(find.byKey(FeatureCoachOverlay.cardKey), findsOneWidget);
    expect(find.byKey(FeatureCoachOverlay.spotlightKey), findsOneWidget);
    expect(find.text(CoachCopy.home.title), findsOneWidget);
    expect(find.text(CoachCopy.home.body), findsOneWidget);
    expect(find.byKey(FeatureCoachOverlay.gotItKey), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);
    expect(find.text('Screen body'), findsOneWidget);
    expect(find.byType(AppGloss), findsWidgets);
  });

  testWidgets('Got it dismisses and persists so the coach does not return', (
    tester,
  ) async {
    final prefs = InMemoryCoachPreferences();
    await pumpHost(tester, prefs: prefs);

    await tester.tap(find.byKey(FeatureCoachOverlay.gotItKey));
    await tester.pumpAndSettle();

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsNothing);
    expect(prefs.hasSeen(CoachScreen.home), isTrue);
    expect(prefs.hasSeen(CoachScreen.wardrobe), isFalse);
    expect(find.text('Screen body'), findsOneWidget);

    await pumpHost(tester, prefs: prefs);
    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsNothing);
  });

  testWidgets('tap outside the card dismisses the coach', (tester) async {
    final prefs = InMemoryCoachPreferences();
    await pumpHost(tester, prefs: prefs);

    await tester.tap(find.byKey(FeatureCoachOverlay.scrimKey));
    await tester.pumpAndSettle();

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsNothing);
    expect(prefs.hasSeen(CoachScreen.home), isTrue);
  });

  testWidgets('tap on the card does not dismiss', (tester) async {
    final prefs = InMemoryCoachPreferences();
    await pumpHost(tester, prefs: prefs);

    await tester.tap(find.text(CoachCopy.home.title));
    await tester.pumpAndSettle();

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsOneWidget);
    expect(prefs.hasSeen(CoachScreen.home), isFalse);
  });

  testWidgets('already-seen screens do not show a coach', (tester) async {
    final prefs = InMemoryCoachPreferences(seen: {CoachScreen.home});
    await pumpHost(tester, prefs: prefs);

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsNothing);
    expect(find.text('Screen body'), findsOneWidget);
  });

  testWidgets('each listed screen has its own first-visit copy', (
    tester,
  ) async {
    for (final screen in CoachScreen.values) {
      final prefs = InMemoryCoachPreferences();
      await pumpHost(tester, prefs: prefs, screen: screen);
      final copy = CoachCopy.of(screen);
      expect(find.text(copy.title), findsOneWidget);
      expect(find.text(copy.body), findsOneWidget);
      await tester.tap(find.byKey(FeatureCoachOverlay.gotItKey));
      await tester.pumpAndSettle();
      expect(prefs.hasSeen(screen), isTrue);
    }
  });

  testWidgets('reduced motion skips the coach fade animation', (tester) async {
    await pumpHost(
      tester,
      prefs: InMemoryCoachPreferences(),
      reduceMotion: true,
    );

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsOneWidget);
    expect(find.text(CoachCopy.home.title), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

    final overlayContext = tester.element(
      find.byKey(FeatureCoachOverlay.overlayKey),
    );
    expect(AppMotion.reduce(overlayContext), isTrue);
  });

  testWidgets('coach card uses burgundy/plum surface tokens', (tester) async {
    await pumpHost(
      tester,
      prefs: InMemoryCoachPreferences(),
      theme: AppTheme.light(),
    );

    final card = tester.widget<Material>(
      find.byKey(FeatureCoachOverlay.cardKey),
    );
    expect(card.color, AppColors.lightSurfaceContainerHigh);

    final gotIt = tester.widget<FilledButton>(
      find.byKey(FeatureCoachOverlay.gotItKey),
    );
    expect(gotIt.onPressed, isNotNull);
  });

  testWidgets('home coach leaves shopping links in the tree', (tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = InMemoryCoachPreferences();
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
      shoppingLinks: FakeShoppingLinksRepository(home: [testShoppingLink()]),
      coaches: prefs,
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsOneWidget);
    expect(find.text(CoachCopy.home.title), findsOneWidget);
    expect(find.byKey(RelatedShoppingLinksSection.sectionKey), findsOneWidget);

    await tester.tap(find.byKey(FeatureCoachOverlay.gotItKey));
    await tester.pumpAndSettle();

    expect(find.byKey(FeatureCoachOverlay.overlayKey), findsNothing);
    expect(find.byKey(RelatedShoppingLinksSection.sectionKey), findsOneWidget);
    expect(find.text('Related shopping links'), findsOneWidget);
    expect(prefs.hasSeen(CoachScreen.home), isTrue);
  });
}
