import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/coach_preferences.dart';
import '../domain/coach_screen.dart';

/// In-memory set of dismissed coach screens, seeded from [CoachPreferences].
class CoachController extends Notifier<Set<CoachScreen>> {
  @override
  Set<CoachScreen> build() {
    final prefs = ref.watch(coachPreferencesProvider);
    return {
      for (final screen in CoachScreen.values)
        if (prefs.hasSeen(screen)) screen,
    };
  }

  bool hasSeen(CoachScreen screen) => state.contains(screen);

  Future<void> dismiss(CoachScreen screen) async {
    if (state.contains(screen)) {
      return;
    }
    state = {...state, screen};
    await ref.read(coachPreferencesProvider).markSeen(screen);
  }
}

final coachControllerProvider =
    NotifierProvider<CoachController, Set<CoachScreen>>(CoachController.new);
