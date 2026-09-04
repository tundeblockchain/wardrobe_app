import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/utils/string_utils.dart';

void main() {
  group('capitalize', () {
    test('capitalizes first letter of lowercase string', () {
      expect(capitalize('shirt'), equals('Shirt'));
    });

    test('handles already capitalized string', () {
      expect(capitalize('Jacket'), equals('Jacket'));
    });

    test('handles single character', () {
      expect(capitalize('a'), equals('A'));
    });

    test('returns empty string for empty input', () {
      expect(capitalize(''), equals(''));
    });

    test('handles string starting with number', () {
      expect(capitalize('3piece suit'), equals('3piece suit'));
    });
  });

  group('toTitleCase', () {
    test('converts multi-word string to title case', () {
      expect(toTitleCase('blue denim jacket'), equals('Blue Denim Jacket'));
    });

    test('handles single word', () {
      expect(toTitleCase('pants'), equals('Pants'));
    });

    test('handles already title cased string', () {
      expect(toTitleCase('Red Shirt'), equals('Red Shirt'));
    });

    test('returns empty string for empty input', () {
      expect(toTitleCase(''), equals(''));
    });

    test('handles multiple spaces between words', () {
      expect(toTitleCase('blue  jacket'), equals('Blue  Jacket'));
    });
  });

  group('truncate', () {
    test('truncates long string with ellipsis', () {
      expect(truncate('A very long item name', 10), equals('A very...'));
    });

    test('returns original string if shorter than max length', () {
      expect(truncate('Short', 10), equals('Short'));
    });

    test('returns original string if equal to max length', () {
      expect(truncate('Exactly10!', 10), equals('Exactly10!'));
    });

    test('throws if maxLength is less than 4', () {
      expect(() => truncate('test', 3), throwsArgumentError);
    });

    test('handles minimum maxLength of 4', () {
      expect(truncate('Hello World', 4), equals('H...'));
    });
  });

  group('isValidItemName', () {
    test('accepts valid alphanumeric name', () {
      expect(isValidItemName('Blue Shirt'), isTrue);
    });

    test('accepts name with hyphen', () {
      expect(isValidItemName('T-Shirt'), isTrue);
    });

    test('accepts name with numbers', () {
      expect(isValidItemName('3 Piece Suit'), isTrue);
    });

    test('rejects empty string', () {
      expect(isValidItemName(''), isFalse);
    });

    test('rejects whitespace only', () {
      expect(isValidItemName('   '), isFalse);
    });

    test('rejects single character', () {
      expect(isValidItemName('A'), isFalse);
    });

    test('rejects name with special characters', () {
      expect(isValidItemName('Shirt!'), isFalse);
    });

    test('accepts two character name', () {
      expect(isValidItemName('AB'), isTrue);
    });
  });

  group('toSlug', () {
    test('converts spaced string to hyphenated slug', () {
      expect(toSlug('Blue Denim Jacket'), equals('blue-denim-jacket'));
    });

    test('removes special characters', () {
      expect(toSlug('Shirt (Cotton)!'), equals('shirt-cotton'));
    });

    test('collapses multiple spaces to single hyphen', () {
      expect(toSlug('blue   jacket'), equals('blue-jacket'));
    });

    test('collapses multiple hyphens', () {
      expect(toSlug('blue--jacket'), equals('blue-jacket'));
    });

    test('handles empty string', () {
      expect(toSlug(''), equals(''));
    });

    test('trims whitespace', () {
      expect(toSlug('  shirt  '), equals('shirt'));
    });

    test('preserves numbers', () {
      expect(toSlug('Size 42 Pants'), equals('size-42-pants'));
    });
  });
}
