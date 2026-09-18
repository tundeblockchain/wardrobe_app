import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/coaches/domain/coach_screen.dart';

void main() {
  test('every screen has a unique preference key, title, and body', () {
    final keys = <String>{};
    final titles = <String>{};
    final bodies = <String>{};

    for (final screen in CoachScreen.values) {
      final copy = CoachCopy.of(screen);
      expect(screen.preferenceKey, 'coach_seen_${screen.name}');
      expect(copy.title, isNotEmpty);
      expect(copy.body, isNotEmpty);
      expect(copy.title.length, lessThan(40));
      expect(copy.body.length, lessThan(240));
      expect(keys.add(screen.preferenceKey), isTrue);
      expect(titles.add(copy.title), isTrue);
      expect(bodies.add(copy.body), isTrue);
    }

    expect(CoachScreen.values, hasLength(6));
  });

  test(
    'home copy still mentions shopping finds (WARDROBE-100 is separate)',
    () {
      expect(CoachCopy.home.body.toLowerCase(), contains('shopping'));
    },
  );
}
