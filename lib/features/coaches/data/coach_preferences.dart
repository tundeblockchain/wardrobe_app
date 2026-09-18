import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/coach_screen.dart';

/// Persisted first-visit coach flags (WARDROBE-99). Device-scoped, not account
/// data — not cleared on sign-out.
abstract class CoachPreferences {
  bool hasSeen(CoachScreen screen);

  Future<void> markSeen(CoachScreen screen);
}

/// SharedPreferences-backed store used in production.
class SharedPreferencesCoachStore implements CoachPreferences {
  SharedPreferencesCoachStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  bool hasSeen(CoachScreen screen) {
    return _prefs.getBool(screen.preferenceKey) ?? false;
  }

  @override
  Future<void> markSeen(CoachScreen screen) {
    return _prefs.setBool(screen.preferenceKey, true);
  }
}

/// In-memory store for tests. Empty [seen] means first visit for every screen.
class InMemoryCoachPreferences implements CoachPreferences {
  InMemoryCoachPreferences({Set<CoachScreen>? seen})
    : seen = seen ?? <CoachScreen>{};

  final Set<CoachScreen> seen;
  int writeCount = 0;

  @override
  bool hasSeen(CoachScreen screen) => seen.contains(screen);

  @override
  Future<void> markSeen(CoachScreen screen) async {
    writeCount++;
    seen.add(screen);
  }
}

/// Defaults to every screen already seen so widget tests do not get overlays.
/// Production [main] overrides this with [SharedPreferencesCoachStore].
final coachPreferencesProvider = Provider<CoachPreferences>((ref) {
  return InMemoryCoachPreferences(seen: {...CoachScreen.values});
});
