import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wardrobe_app/app.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/features/account/data/dio_account_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import 'fake_account_repository.dart';
import 'fake_ai_profile_repository.dart';
import 'fake_app_reviewer.dart';
import 'fake_auth_repository.dart';
import 'fake_device_context.dart';
import 'fake_item_image_picker.dart';
import 'fake_item_repository.dart';
import 'fake_outfit_repository.dart';
import 'fake_recommendation_repository.dart';
import 'fake_support_repository.dart';
import 'fake_upload_repository.dart';
import 'fake_wardrobe_repository.dart';
import 'item_processing_poll_overrides.dart';

/// Signed-in [WardrobeApp] with in-memory repositories for widget tests.
class TestAppHarness {
  TestAppHarness({
    FakeAuthRepository? auth,
    FakeWardrobeRepository? wardrobes,
    FakeItemRepository? items,
    FakeOutfitRepository? outfits,
    FakeAccountRepository? account,
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
       account = account ?? FakeAccountRepository();

  final FakeAuthRepository auth;
  final FakeWardrobeRepository wardrobes;
  final FakeItemRepository items;
  final FakeOutfitRepository outfits;
  final FakeAccountRepository account;
  final sessionStore = InMemorySessionLocalStore();
  final sessionImages = RecordingSessionImageCache();
  final recommendations = FakeRecommendationRepository();
  final uploads = FakeUploadRepository();
  final picker = FakeItemImagePicker();
  final reviewer = FakeAppReviewer();
  final support = FakeSupportRepository();
  final aiProfiles = FakeAiProfileRepository();

  Widget app() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
        itemRepositoryProvider.overrideWithValue(items),
        outfitRepositoryProvider.overrideWithValue(outfits),
        recommendationRepositoryProvider.overrideWithValue(recommendations),
        uploadRepositoryProvider.overrideWithValue(uploads),
        itemImagePickerProvider.overrideWithValue(picker),
        accountRepositoryProvider.overrideWithValue(account),
        appReviewerProvider.overrideWithValue(reviewer),
        supportRepositoryProvider.overrideWithValue(support),
        aiProfileRepositoryProvider.overrideWithValue(aiProfiles),
        deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
        sessionLocalStoreProvider.overrideWithValue(sessionStore),
        sessionImageCacheProvider.overrideWithValue(sessionImages),
        ...itemProcessingPollTestOverrides(),
      ],
      child: const WardrobeApp(),
    );
  }

  void dispose() {
    auth.dispose();
  }
}
