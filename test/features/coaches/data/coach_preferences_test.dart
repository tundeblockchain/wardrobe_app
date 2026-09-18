import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_app/features/coaches/data/coach_preferences.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';

void main() {
  group('SharedPreferencesCoachStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('defaults to unseen when no key is stored', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharedPreferencesCoachStore(prefs);
      for (final screen in CoachScreen.values) {
        expect(store.hasSeen(screen), isFalse);
      }
    });

    test(
      'persists seen flags per screen across a new store instance',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final store = SharedPreferencesCoachStore(prefs);

        await store.markSeen(CoachScreen.home);
        expect(store.hasSeen(CoachScreen.home), isTrue);
        expect(store.hasSeen(CoachScreen.wardrobe), isFalse);
        expect(prefs.getBool(CoachScreen.home.preferenceKey), isTrue);

        final restarted = SharedPreferencesCoachStore(
          await SharedPreferences.getInstance(),
        );
        expect(restarted.hasSeen(CoachScreen.home), isTrue);
        expect(restarted.hasSeen(CoachScreen.profile), isFalse);

        await restarted.markSeen(CoachScreen.profile);
        expect(
          SharedPreferencesCoachStore(await SharedPreferences.getInstance())
              .hasSeen(CoachScreen.profile),
          isTrue,
        );
        expect(
          SharedPreferencesCoachStore(await SharedPreferences.getInstance())
              .hasSeen(CoachScreen.item),
          isFalse,
        );
      },
    );
  });

  test('InMemoryCoachPreferences writes stay in memory', () async {
    final store = InMemoryCoachPreferences();
    expect(store.hasSeen(CoachScreen.outfit), isFalse);
    await store.markSeen(CoachScreen.outfit);
    expect(store.hasSeen(CoachScreen.outfit), isTrue);
    expect(store.hasSeen(CoachScreen.tryOn), isFalse);
    expect(store.writeCount, 1);
  });

  test('default provider store treats every screen as already seen', () {
    final store = InMemoryCoachPreferences(seen: {...CoachScreen.values});
    for (final screen in CoachScreen.values) {
      expect(store.hasSeen(screen), isTrue);
    }
  });
}
