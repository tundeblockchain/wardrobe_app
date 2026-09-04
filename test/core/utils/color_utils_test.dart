import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/utils/color_utils.dart';

void main() {
  group('RgbColor', () {
    test('equals returns true for same RGB values', () {
      const color1 = RgbColor(255, 128, 64);
      const color2 = RgbColor(255, 128, 64);
      expect(color1, equals(color2));
    });

    test('equals returns false for different RGB values', () {
      const color1 = RgbColor(255, 128, 64);
      const color2 = RgbColor(255, 128, 65);
      expect(color1, isNot(equals(color2)));
    });

    test('hashCode is consistent for equal objects', () {
      const color1 = RgbColor(100, 150, 200);
      const color2 = RgbColor(100, 150, 200);
      expect(color1.hashCode, equals(color2.hashCode));
    });

    test('toString returns readable format', () {
      const color = RgbColor(255, 128, 64);
      expect(color.toString(), equals('RgbColor(255, 128, 64)'));
    });
  });

  group('parseHexColor', () {
    test('parses 6-digit hex with hash', () {
      final color = parseHexColor('#FF8040');
      expect(color, equals(const RgbColor(255, 128, 64)));
    });

    test('parses 6-digit hex without hash', () {
      final color = parseHexColor('FF8040');
      expect(color, equals(const RgbColor(255, 128, 64)));
    });

    test('parses 3-digit hex with hash', () {
      final color = parseHexColor('#F84');
      expect(color, equals(const RgbColor(255, 136, 68)));
    });

    test('parses 3-digit hex without hash', () {
      final color = parseHexColor('F84');
      expect(color, equals(const RgbColor(255, 136, 68)));
    });

    test('parses lowercase hex', () {
      final color = parseHexColor('#ff8040');
      expect(color, equals(const RgbColor(255, 128, 64)));
    });

    test('parses black', () {
      final color = parseHexColor('#000000');
      expect(color, equals(const RgbColor(0, 0, 0)));
    });

    test('parses white', () {
      final color = parseHexColor('#FFFFFF');
      expect(color, equals(const RgbColor(255, 255, 255)));
    });

    test('returns null for invalid length', () {
      expect(parseHexColor('#FFFF'), isNull);
    });

    test('returns null for invalid characters', () {
      expect(parseHexColor('#GGGGGG'), isNull);
    });

    test('returns null for empty string', () {
      expect(parseHexColor(''), isNull);
    });
  });

  group('rgbToHex', () {
    test('converts RGB to hex string', () {
      expect(rgbToHex(255, 128, 64), equals('#FF8040'));
    });

    test('converts black', () {
      expect(rgbToHex(0, 0, 0), equals('#000000'));
    });

    test('converts white', () {
      expect(rgbToHex(255, 255, 255), equals('#FFFFFF'));
    });

    test('pads single digit values', () {
      expect(rgbToHex(0, 10, 15), equals('#000A0F'));
    });

    test('throws for red value above 255', () {
      expect(() => rgbToHex(256, 0, 0), throwsArgumentError);
    });

    test('throws for negative value', () {
      expect(() => rgbToHex(-1, 0, 0), throwsArgumentError);
    });

    test('throws for green value above 255', () {
      expect(() => rgbToHex(0, 256, 0), throwsArgumentError);
    });

    test('throws for blue value above 255', () {
      expect(() => rgbToHex(0, 0, 256), throwsArgumentError);
    });
  });

  group('categorizeColor', () {
    test('categorizes gray as neutral', () {
      const gray = RgbColor(128, 128, 128);
      expect(categorizeColor(gray), equals(ColorCategory.neutral));
    });

    test('categorizes pure white as neutral', () {
      const white = RgbColor(255, 255, 255);
      expect(categorizeColor(white), equals(ColorCategory.neutral));
    });

    test('categorizes pure black as neutral', () {
      const black = RgbColor(0, 0, 0);
      expect(categorizeColor(black), equals(ColorCategory.neutral));
    });

    test('categorizes pure red as warm', () {
      const red = RgbColor(255, 0, 0);
      expect(categorizeColor(red), equals(ColorCategory.warm));
    });

    test('categorizes pure blue as cool', () {
      const blue = RgbColor(0, 0, 255);
      expect(categorizeColor(blue), equals(ColorCategory.cool));
    });

    test('categorizes light pink as pastel', () {
      const lightPink = RgbColor(255, 200, 210);
      expect(categorizeColor(lightPink), equals(ColorCategory.pastel));
    });

    test('categorizes brown/orange as earth', () {
      const brown = RgbColor(180, 120, 60);
      expect(categorizeColor(brown), equals(ColorCategory.earth));
    });

    test('categorizes bright yellow as bright', () {
      const brightYellow = RgbColor(255, 255, 0);
      expect(categorizeColor(brightYellow), equals(ColorCategory.bright));
    });
  });
}
