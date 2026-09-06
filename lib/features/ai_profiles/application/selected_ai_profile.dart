import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_profile.dart';

/// In-memory try-on selection used by the dressing room (WARDROBE-51).
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

/// Selected profile id passed as `aiProfileId` on POST `/render`.
final selectedAiProfileIdProvider = Provider<String?>((ref) {
  return ref.watch(selectedAiProfileProvider)?.id;
});
