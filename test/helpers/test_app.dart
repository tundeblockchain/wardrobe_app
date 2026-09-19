import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/app.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/features/account/data/dio_account_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/coaches/data/coach_preferences.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/data/paywall_gateway_provider.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobe_items_provider.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import 'fake_account_repository.dart';
import 'fake_ai_profile_repository.dart';
import 'fake_app_reviewer.dart';
import 'fake_auth_repository.dart';
import 'fake_device_context.dart';
import 'fake_entitlements.dart';
import 'fake_item_image_picker.dart';
import 'fake_item_repository.dart';
import 'fake_outfit_repository.dart';
import 'fake_recommendation_repository.dart';
import 'fake_shopping_link_opener.dart';
import 'fake_shopping_links_repository.dart';
import 'fake_support_repository.dart';
import 'fake_upload_repository.dart';
import 'fake_job_event_repository.dart';
import 'fake_wardrobe_repository.dart';
import 'fake_worn_on_repository.dart';
import 'inbox_test_overrides.dart';
import 'item_processing_poll_overrides.dart';
import 'share_test_overrides.dart';
import 'worn_on_test_overrides.dart';

/// Empty shopping-links so item detail never hits live Dio in tests.
List<Override> shoppingLinksTestOverrides({
  FakeShoppingLinksRepository? repository,
  FakeShoppingLinkOpener? opener,
}) {
  return [
    shoppingLinksRepositoryProvider.overrideWithValue(
      repository ?? FakeShoppingLinksRepository(),
    ),
    shoppingLinkOpenerProvider.overrideWithValue(
      opener ?? FakeShoppingLinkOpener(),
    ),
  ];
}

/// Premium entitlements + fake Superwall so existing flows stay unlocked.
List<Override> entitlementTestOverrides({
  Entitlement? entitlement,
  FakeEntitlementRepository? repository,
  FakePaywallGateway? paywall,
}) {
  final entitlements =
      repository ??
      FakeEntitlementRepository(seed: entitlement ?? Entitlement.premium);
  return [
    entitlementRepositoryProvider.overrideWithValue(entitlements),
    paywallGatewayProvider.overrideWithValue(paywall ?? FakePaywallGateway()),
  ];
}

/// Signed-in [WardrobeApp] with in-memory repositories for widget tests.
class TestAppHarness {
  TestAppHarness({
    FakeAuthRepository? auth,
    FakeWardrobeRepository? wardrobes,
    FakeItemRepository? items,
    FakeOutfitRepository? outfits,
    FakeAccountRepository? account,
    FakeShoppingLinksRepository? shoppingLinks,
    FakeWornOnRepository? wornOn,
    Entitlement? entitlement,
    CoachPreferences? coaches,
    FakeJobEventRepository? inbox,
  }) : auth =
           auth ??
           FakeAuthRepository(
             initialUser: const AppUser(
               uid: 'uid-1',
               email: 'user@example.com',
             ),
           ),
       wardrobes = wardrobes ?? FakeWardrobeRepository(seed: [testWardrobe()]),
       items = items ?? FakeItemRepository(seed: [testItem()]),
       outfits = outfits ?? FakeOutfitRepository(),
       account = account ?? FakeAccountRepository(),
       shoppingLinks = shoppingLinks ?? FakeShoppingLinksRepository(),
       wornOn = wornOn ?? FakeWornOnRepository(),
       entitlements = FakeEntitlementRepository(
         seed: entitlement ?? Entitlement.premium,
       ),
       coaches =
           coaches ?? InMemoryCoachPreferences(seen: {...CoachScreen.values}),
       inbox = inbox ?? FakeJobEventRepository();

  final FakeAuthRepository auth;
  final FakeWardrobeRepository wardrobes;
  final FakeItemRepository items;
  final FakeOutfitRepository outfits;
  final FakeAccountRepository account;
  final FakeShoppingLinksRepository shoppingLinks;
  final FakeWornOnRepository wornOn;
  final FakeEntitlementRepository entitlements;
  final CoachPreferences coaches;
  final FakeJobEventRepository inbox;
  final paywall = FakePaywallGateway();
  final sessionStore = InMemorySessionLocalStore();
  final sessionImages = RecordingSessionImageCache();
  final recommendations = FakeRecommendationRepository();
  final uploads = FakeUploadRepository();
  final picker = FakeItemImagePicker();
  final reviewer = FakeAppReviewer();
  final support = FakeSupportRepository();
  final aiProfiles = FakeAiProfileRepository();
  final shoppingOpener = FakeShoppingLinkOpener();

  Widget app() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
        itemRepositoryProvider.overrideWithValue(items),
        outfitRepositoryProvider.overrideWithValue(outfits),
        recommendationRepositoryProvider.overrideWithValue(recommendations),
        ...shoppingLinksTestOverrides(
          repository: shoppingLinks,
          opener: shoppingOpener,
        ),
        ...wornOnTestOverrides(repository: wornOn),
        ...shareTestOverrides(),
        uploadRepositoryProvider.overrideWithValue(uploads),
        itemImagePickerProvider.overrideWithValue(picker),
        accountRepositoryProvider.overrideWithValue(account),
        appReviewerProvider.overrideWithValue(reviewer),
        supportRepositoryProvider.overrideWithValue(support),
        aiProfileRepositoryProvider.overrideWithValue(aiProfiles),
        deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
        sessionLocalStoreProvider.overrideWithValue(sessionStore),
        sessionImageCacheProvider.overrideWithValue(sessionImages),
        homeClothingCarouselAutoScrollProvider.overrideWithValue(false),
        entitlementRepositoryProvider.overrideWithValue(entitlements),
        paywallGatewayProvider.overrideWithValue(paywall),
        coachPreferencesProvider.overrideWithValue(coaches),
        ...itemProcessingPollTestOverrides(),
        ...inboxTestOverrides(events: inbox),
      ],
      child: const WardrobeApp(),
    );
  }

  void dispose() {
    auth.dispose();
  }
}

/// Default test surface is 800×600, which clips Account after Plan/Restore.
void useTallProfileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Scrolls until [finder] can receive a tap (center on-screen).
Future<void> tapInScrollView(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 80);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

Future<void> tapHomeWardrobeCard(
  WidgetTester tester, {
  String wardrobeId = 'wd_abc123',
}) async {
  final finder = find.byKey(Key('wardrobe_tile_$wardrobeId'));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}
