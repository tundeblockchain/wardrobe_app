import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/wardrobes/domain/wardrobe_validators.dart';

void main() {
  group('WardrobeValidators.name', () {
    test('rejects empty and whitespace', () {
      expect(WardrobeValidators.name(''), isNotNull);
      expect(WardrobeValidators.name('   '), isNotNull);
    });

    test('rejects names longer than 100 characters', () {
      expect(WardrobeValidators.name('a' * 101), isNotNull);
    });

    test('accepts trimmed names', () {
      expect(WardrobeValidators.name('  Home  '), isNull);
    });
  });
}
