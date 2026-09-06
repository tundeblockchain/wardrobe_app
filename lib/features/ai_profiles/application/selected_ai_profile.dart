import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_profile.dart';

/// In-memory try-on prep selection.
///
/// WARDROBE-51 should read [selectedAiProfileIdProvider] (or this notifier)
/// and pass that `aiProfileId` to the try-on API. This ticket only stores
/// the chosen PERSONAL or GENERIC_MODEL profile.
class SelectedAiProfileController extends Notifier<AiProfile?> {
  @override
  AiProfile? build() => null;

  void select(AiProfile profile) {
    state = profile;
  }

  void clear() {
    state = null;
  }
}

final selectedAiProfileProvider =
    NotifierProvider<SelectedAiProfileController, AiProfile?>(
      SelectedAiProfileController.new,
    );

/// Extension point for WARDROBE-51: the selected profile id, or null.
final selectedAiProfileIdProvider = Provider<String?>((ref) {
  return ref.watch(selectedAiProfileProvider)?.id;
});
