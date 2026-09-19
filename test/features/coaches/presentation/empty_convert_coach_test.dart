import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_colors.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/core/widgets/app_gloss.dart';
import 'package:wardrobe_app/features/coaches/domain/empty_convert_copy.dart';
import 'package:wardrobe_app/features/coaches/presentation/empty_convert_coach.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('shows convert copy and both CTAs', (tester) async {
    var primary = 0;
    var secondary = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: EmptyConvertCoach(
            key: EmptyConvertCoach.coachKey,
            icon: Icons.add_a_photo_outlined,
            title: EmptyConvertCopy.wardrobeTitle,
            message: EmptyConvertCopy.wardrobeBody,
            primaryLabel: EmptyConvertCopy.wardrobePrimary,
            secondaryLabel: EmptyConvertCopy.wardrobeSecondary,
            onPrimary: () => primary++,
            onSecondary: () => secondary++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(EmptyConvertCoach.coachKey), findsOneWidget);
    expect(find.byKey(EmptyConvertCoach.cardKey), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobeTitle), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobeBody), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobePrimary), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobeSecondary), findsOneWidget);
    expect(find.byType(AppGloss), findsWidgets);

    await tester.tap(find.byKey(EmptyConvertCoach.primaryActionKey));
    await tester.tap(find.byKey(EmptyConvertCoach.secondaryActionKey));
    expect(primary, 1);
    expect(secondary, 1);
  });

  testWidgets('uses burgundy/plum surface tokens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: EmptyConvertCoach(
            icon: Icons.checkroom_outlined,
            title: EmptyConvertCopy.homeTitle,
            message: EmptyConvertCopy.homeBody,
            primaryLabel: EmptyConvertCopy.homeAction,
            onPrimary: _noop,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final card = tester.widget<Material>(find.byKey(EmptyConvertCoach.cardKey));
    expect(card.color, AppColors.lightSurfaceContainerHigh);
  });

  testWidgets('reduced motion skips the fade animation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          );
        },
        home: const Scaffold(
          body: EmptyConvertCoach(
            icon: Icons.checkroom_outlined,
            title: EmptyConvertCopy.homeTitle,
            message: EmptyConvertCopy.homeBody,
            primaryLabel: EmptyConvertCopy.homeAction,
            onPrimary: _noop,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppFadeIn), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    final context = tester.element(find.byKey(EmptyConvertCoach.cardKey));
    expect(AppMotion.reduce(context), isTrue);
  });

  testWidgets('home empty state hosts the convert coach', (tester) async {
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(),
      items: FakeItemRepository(),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.byKey(WardrobesScreen.emptyStateKey), findsOneWidget);
    expect(find.byType(EmptyConvertCoach), findsOneWidget);
    expect(find.text(EmptyConvertCopy.homeTitle), findsOneWidget);
    expect(find.text(EmptyConvertCopy.homeAction), findsOneWidget);
  });

  testWidgets('wardrobe empty state hosts gallery and camera CTAs', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness(items: FakeItemRepository());
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobeTitle), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobePrimary), findsOneWidget);
    expect(find.text(EmptyConvertCopy.wardrobeSecondary), findsOneWidget);
  });
}

void _noop() {}
