/// Color utility functions for the Wardrobe app.
///
/// Provides color-related utilities including hex color parsing,
/// color name validation, and color categorization for wardrobe items.
library;

/// A simple color representation using RGB values.
class RgbColor {
  final int red;
  final int green;
  final int blue;

  const RgbColor(this.red, this.green, this.blue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RgbColor &&
          runtimeType == other.runtimeType &&
          red == other.red &&
          green == other.green &&
          blue == other.blue;

  @override
  int get hashCode => Object.hash(red, green, blue);

  @override
  String toString() => 'RgbColor($red, $green, $blue)';
}

/// Parses a hex color string to RGB values.
///
/// Accepts formats: "#RRGGBB", "RRGGBB", "#RGB", "RGB"
/// Returns null if the format is invalid.
RgbColor? parseHexColor(String hex) {
  var cleaned = hex.replaceFirst('#', '').toUpperCase();

  if (cleaned.length == 3) {
    cleaned = cleaned.split('').map((c) => '$c$c').join();
  }

  if (cleaned.length != 6) return null;
  if (!RegExp(r'^[0-9A-F]{6}$').hasMatch(cleaned)) return null;

  final r = int.parse(cleaned.substring(0, 2), radix: 16);
  final g = int.parse(cleaned.substring(2, 4), radix: 16);
  final b = int.parse(cleaned.substring(4, 6), radix: 16);

  return RgbColor(r, g, b);
}

/// Converts RGB values to a hex color string.
///
/// Returns the hex string in "#RRGGBB" format.
/// Throws if any value is outside the 0-255 range.
String rgbToHex(int red, int green, int blue) {
  if (red < 0 ||
      red > 255 ||
      green < 0 ||
      green > 255 ||
      blue < 0 ||
      blue > 255) {
    throw ArgumentError('RGB values must be between 0 and 255');
  }
  final r = red.toRadixString(16).padLeft(2, '0');
  final g = green.toRadixString(16).padLeft(2, '0');
  final b = blue.toRadixString(16).padLeft(2, '0');
  return '#$r$g$b'.toUpperCase();
}

/// Standard color categories for wardrobe items.
enum ColorCategory { neutral, warm, cool, earth, pastel, bright }

/// Categorizes a color based on its RGB values.
///
/// This is a simplified categorization for wardrobe organization.
ColorCategory categorizeColor(RgbColor color) {
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  final max = [r, g, b].reduce((a, b) => a > b ? a : b);
  final min = [r, g, b].reduce((a, b) => a < b ? a : b);
  final saturation = max == 0 ? 0.0 : (max - min) / max;
  final brightness = max / 255;

  if (saturation < 0.15) {
    return ColorCategory.neutral;
  }

  if (brightness > 0.8 && saturation < 0.5) {
    return ColorCategory.pastel;
  }

  if (r > g && r > b) {
    if (g > b * 1.5) return ColorCategory.earth;
    return ColorCategory.warm;
  }

  if (b > r && b > g) {
    return ColorCategory.cool;
  }

  if (g > r && g > b) {
    if (r > b) return ColorCategory.earth;
    return ColorCategory.cool;
  }

  if (brightness > 0.7 && saturation > 0.7) {
    return ColorCategory.bright;
  }

  return ColorCategory.neutral;
}
