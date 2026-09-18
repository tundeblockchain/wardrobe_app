import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/coaches/data/coach_preferences.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';
import 'package:wardrobe_app/features/coaches/presentation/feature_coach_overlay.dart';
import 'package:wardrobe_app/features/coaches/presentation/screen_coach_host.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfits_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/try_on/presentation/dressing_room_screen.dart';
import 'package:wardrobe_app/features/try_on/presentation/try_on_screen.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobe_items_provider.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_recommendation_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('each key screen hosts its first-visit coach', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pump(Widget home) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wardrobeRepositoryProvider.overrideWithValue(
              FakeWardrobeRepository(seed: [testWardrobe()]),
            ),
            itemRepositoryProvider.overrideWithValue(
              FakeItemRepository(seed: [testItem()]),
            ),
            outfitRepositoryProvider.overrideWithValue(
              FakeOutfitRepository(seed: [testOutfit()]),
            ),
            recommendationRepositoryProvider.overrideWithValue(
              FakeRecommendationRepository(),
            ),
            aiProfileRepositoryProvider.overrideWithValue(
              FakeAiProfileRepository(),
            ),
            homeClothingCarouselAutoScrollProvider.overrideWithValue(false),
            ...shoppingLinksTestOverrides(),
            ...entitlementTestOverrides(),
            ...itemProcessingPollTestOverrides(),
          ],
          child: MaterialApp(home: home),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump(const WardrobesScreen());
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.home,
    );

    await pump(const WardrobeDetailScreen(wardrobeId: 'wd_abc123'));
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.wardrobe,
    );

    await pump(const OutfitsScreen(wardrobeId: 'wd_abc123'));
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.outfit,
    );

    await pump(
      const ItemDetailScreen(wardrobeId: 'wd_abc123', itemId: 'item_xyz123'),
    );
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.item,
    );

    await pump(const DressingRoomScreen(wardrobeId: 'wd_abc123'));
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.tryOn,
    );

    await pump(
      const TryOnScreen(wardrobeId: 'wd_abc123', outfitId: 'outfit_123'),
    );
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.tryOn,
    );
  });

  testWidgets('Account hosts the profile coach', (tester) async {
    useTallProfileViewport(tester);
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(
      tester.widget<ScreenCoachHost>(find.byType(ScreenCoachHost)).screen,
      CoachScreen.profile,
    );
  });

  testWidgets('wardrobe coach appears after home is dismissed', (tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = InMemoryCoachPreferences();
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
      items: FakeItemRepository(seed: [testItem()]),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [coachPreferencesProvider.overrideWithValue(prefs)],
        child: harness.app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(CoachCopy.home.title), findsOneWidget);
    await tester.tap(find.byKey(FeatureCoachOverlay.gotItKey));
    await tester.pumpAndSettle();

    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.text(CoachCopy.wardrobe.title), findsOneWidget);
    expect(prefs.hasSeen(CoachScreen.home), isTrue);
    expect(prefs.hasSeen(CoachScreen.wardrobe), isFalse);
  });
}
