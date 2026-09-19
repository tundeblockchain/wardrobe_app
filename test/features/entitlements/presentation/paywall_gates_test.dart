import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/ai_try_on_screen.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/entitlements/presentation/paywall_sheet.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/create_wardrobe_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('paywall sheet uses burgundy theme and skips fade when reduced', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: PaywallSheet(placement: PaywallPlacement.wardrobeLimit),
          ),
        ),
      ),
    );

    expect(find.byKey(PaywallSheet.sheetKey), findsOneWidget);
    expect(find.text("You've reached the Free wardrobe limit"), findsOneWidget);
    expect(find.textContaining('Upgrade to Basic'), findsWidgets);
    expect(find.textContaining('£5/mo'), findsWidgets);
    expect(find.byKey(PaywallSheet.upgradeButtonKey), findsOneWidget);
    expect(find.byKey(PaywallSheet.seePlansButtonKey), findsOneWidget);
    expect(find.byKey(PaywallSheet.restoreButtonKey), findsOneWidget);
    expect(find.byKey(PaywallSheet.restoreHintKey), findsOneWidget);
    expect(find.byType(AppFadeIn), findsNothing);
  });

  testWidgets('see plans expands Free/Basic/Premium and restore reports', (
    tester,
  ) async {
    var restores = 0;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: PaywallSheet(
              placement: PaywallPlacement.itemLimit,
              onRestore: () async {
                restores++;
                return RestorePurchasesResult.unavailable;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(PaywallSheet.plansSectionKey), findsNothing);

    await tester.tap(find.byKey(PaywallSheet.restoreButtonKey));
    await tester.pumpAndSettle();
    expect(restores, 1);
    expect(find.text('Restore is unavailable in this build.'), findsOneWidget);

    await tester.tap(find.byKey(PaywallSheet.seePlansButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(PaywallSheet.plansSectionKey), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Basic'), findsWidgets);
    expect(find.text('Premium'), findsOneWidget);
  });

  testWidgets('Free wardrobe limit presents Superwall toward Basic', (
    tester,
  ) async {
    final harness = TestAppHarness(
      entitlement: Entitlement.free,
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobesScreen.createButtonKey));
    await tester.pumpAndSettle();

    expect(harness.paywall.presented, [PaywallPlacement.wardrobeLimit]);
    expect(find.byType(CreateWardrobeScreen), findsNothing);
  });

  testWidgets('Premium can create another wardrobe without a paywall', (
    tester,
  ) async {
    final harness = TestAppHarness(entitlement: Entitlement.premium);
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobesScreen.createButtonKey));
    await tester.pumpAndSettle();

    expect(harness.paywall.presented, isEmpty);
    expect(find.byType(CreateWardrobeScreen), findsOneWidget);
  });

  testWidgets('Account restore purchases hits Superwall and refreshes', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(ProfileScreen.planTileKey), findsOneWidget);
    expect(find.textContaining('Premium'), findsWidgets);
    expect(find.textContaining('reinstall'), findsOneWidget);

    final restoresBefore = harness.paywall.restoreCount;
    await tester.scrollUntilVisible(
      find.byKey(ProfileScreen.restorePurchasesTileKey),
      80,
    );
    await tester.tap(find.byKey(ProfileScreen.restorePurchasesTileKey));
    await tester.pumpAndSettle();

    expect(harness.paywall.restoreCount, greaterThan(restoresBefore));
    expect(harness.entitlements.fetchCount, greaterThan(1));
  });

  testWidgets('Free Account AI try-on opens profile setup without Superwall', (
    tester,
  ) async {
    final harness = TestAppHarness(entitlement: Entitlement.free);
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(ProfileScreen.aiTryOnTileKey),
      80,
    );
    await tester.tap(find.byKey(ProfileScreen.aiTryOnTileKey));
    await tester.pumpAndSettle();

    expect(harness.paywall.presented, isEmpty);
    expect(find.byType(AiTryOnScreen), findsOneWidget);
  });
}
