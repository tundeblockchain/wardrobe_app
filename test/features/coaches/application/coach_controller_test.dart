import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/core/session/user_session_reset.dart';
import 'package:wardrobe_app/features/coaches/application/coach_controller.dart';
import 'package:wardrobe_app/features/coaches/data/coach_preferences.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';

void main() {
  test('controller loads stored flags and persists dismiss', () async {
    final store = InMemoryCoachPreferences();
    final container = ProviderContainer.test(
      overrides: [coachPreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    expect(container.read(coachControllerProvider), isEmpty);

    await container
        .read(coachControllerProvider.notifier)
        .dismiss(CoachScreen.home);
    expect(container.read(coachControllerProvider), {CoachScreen.home});
    expect(store.hasSeen(CoachScreen.home), isTrue);
    expect(store.hasSeen(CoachScreen.wardrobe), isFalse);
    expect(store.writeCount, 1);

    final restarted = ProviderContainer.test(
      overrides: [coachPreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(restarted.dispose);
    expect(restarted.read(coachControllerProvider), {CoachScreen.home});
  });

  test('dismiss is a no-op when the screen is already seen', () async {
    final store = InMemoryCoachPreferences(seen: {CoachScreen.item});
    final container = ProviderContainer.test(
      overrides: [coachPreferencesProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container
        .read(coachControllerProvider.notifier)
        .dismiss(CoachScreen.item);
    expect(store.writeCount, 0);
  });

  test('session reset does not clear device coach flags', () async {
    final store = InMemoryCoachPreferences(seen: {CoachScreen.profile});
    final session = InMemorySessionLocalStore(
      preferences: {'lastWardrobe': 'wd_1'},
    );
    final container = ProviderContainer.test(
      overrides: [
        coachPreferencesProvider.overrideWithValue(store),
        sessionLocalStoreProvider.overrideWithValue(session),
        sessionImageCacheProvider.overrideWithValue(
          RecordingSessionImageCache(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(userSessionResetProvider).clear();

    expect(store.hasSeen(CoachScreen.profile), isTrue);
    expect(container.read(coachControllerProvider), {CoachScreen.profile});
    expect(session.preferences, isEmpty);
  });
}
