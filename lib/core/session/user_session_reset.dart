import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ai_profiles/application/generic_models_controller.dart';
import '../../features/ai_profiles/application/personal_ai_profiles_controller.dart';
import '../../features/ai_profiles/application/selected_ai_profile.dart';
import '../../features/items/application/add_item_controller.dart';
import '../../features/items/application/edit_item_controller.dart';
import '../../features/items/application/item_detail_controller.dart';
import '../../features/items/application/item_local_preview_cache.dart';
import '../../features/items/application/items_controller.dart';
import '../../features/outfits/application/create_outfit_controller.dart';
import '../../features/outfits/application/edit_outfit_controller.dart';
import '../../features/outfits/application/outfit_detail_controller.dart';
import '../../features/outfits/application/outfits_controller.dart';
import '../../features/recommendations/application/recommendation_detail_controller.dart';
import '../../features/recommendations/application/recommendations_controller.dart';
import '../../features/try_on/application/try_on_controller.dart';
import '../../features/wardrobes/application/wardrobe_cover_provider.dart';
import '../../features/wardrobes/application/wardrobe_detail_controller.dart';
import '../../features/wardrobes/application/wardrobes_controller.dart';
import 'session_local_store.dart';

/// Drops every in-memory and on-device cache tied to the previous account.
///
/// Does not sign out of Firebase — [AuthController] does that first, then
/// calls [clear] so the next signed-in uid cannot see leftover lists or photos.
class UserSessionReset {
  UserSessionReset(this._ref);

  final Ref _ref;

  Future<void> clear() async {
    await _ref.read(sessionLocalStoreProvider).clear();
    _ref.read(sessionImageCacheProvider).clear();
    invalidateUserScopedProviders(_ref);
  }
}

/// Riverpod caches that hold another user's wardrobes, items, photos, or
/// profile. Safe to call while signed in (e.g. after `DELETE /me/content`).
void invalidateUserScopedProviders(Ref ref) {
  ref.invalidate(wardrobesControllerProvider);
  ref.invalidate(createWardrobeControllerProvider);
  ref.invalidate(wardrobeDetailControllerProvider);
  ref.invalidate(wardrobeCoverProvider);
  ref.invalidate(itemsControllerProvider);
  ref.invalidate(itemDetailControllerProvider);
  ref.invalidate(addItemControllerProvider);
  ref.invalidate(editItemControllerProvider);
  ref.invalidate(itemLocalPreviewCacheProvider);
  ref.invalidate(outfitsControllerProvider);
  ref.invalidate(createOutfitControllerProvider);
  ref.invalidate(editOutfitControllerProvider);
  ref.invalidate(outfitDetailControllerProvider);
  ref.invalidate(recommendationsControllerProvider);
  ref.invalidate(recommendationDetailControllerProvider);
  ref.invalidate(tryOnControllerProvider);
  ref.invalidate(personalAiProfilesControllerProvider);
  ref.invalidate(genericModelsControllerProvider);
  ref.invalidate(selectedAiProfileProvider);
}

final userSessionResetProvider = Provider<UserSessionReset>((ref) {
  return UserSessionReset(ref);
});
