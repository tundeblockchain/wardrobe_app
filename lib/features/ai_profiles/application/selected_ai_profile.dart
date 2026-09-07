import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../domain/ai_profile.dart';

/// In-memory try-on selection used by the dressing room (WARDROBE-51).
class SelectedAiProfileController extends Notifier<AiProfile?> {
  @override
  AiProfile? build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return null;
  }

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
