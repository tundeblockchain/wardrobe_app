import 'ai_profile_body_context.dart';

/// Light range checks for optional AI-profile body fields (WARDROBE-81).
///
/// Empty / whitespace values are always valid so try-on is never blocked.
abstract final class AiProfileBodyValidators {
  static const minHeightCm = 50;
  static const maxHeightCm = 250;
  static const minAge = 1;
  static const maxAge = 120;
  static const minBustCm = 40;
  static const maxBustCm = 200;
  static const minHipsCm = 40;
  static const maxHipsCm = 200;
  static const minWeightKg = 20;
  static const maxWeightKg = 400;
  static const maxSizeLength = 16;

  static String? height(String? value) {
    return _optionalNumber(
      value,
      min: minHeightCm,
      max: maxHeightCm,
      label: 'Height',
      unit: 'cm',
    );
  }

  static String? age(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a whole number for age.';
    }
    if (parsed < minAge || parsed > maxAge) {
      return 'Age must be between $minAge and $maxAge.';
    }
    return null;
  }

  static String? bust(String? value) {
    return _optionalNumber(
      value,
      min: minBustCm,
      max: maxBustCm,
      label: 'Bust',
      unit: 'cm',
    );
  }

  static String? hips(String? value) {
    return _optionalNumber(
      value,
      min: minHipsCm,
      max: maxHipsCm,
      label: 'Hips',
      unit: 'cm',
    );
  }

  static String? size(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > maxSizeLength) {
      return 'Size must be $maxSizeLength characters or fewer.';
    }
    return null;
  }

  static String? weight(String? value) {
    return _optionalNumber(
      value,
      min: minWeightKg,
      max: maxWeightKg,
      label: 'Weight',
      unit: 'kg',
    );
  }

  /// Parses a validated optional number field. Empty → null.
  static num? parseNumber(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return num.tryParse(trimmed);
  }

  /// Parses a validated optional integer field. Empty → null.
  static int? parseInt(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  static String? parseSize(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static AiProfileBodyContext parseForm({
    required String height,
    required String age,
    required String bust,
    required String hips,
    required String size,
    required String weight,
  }) {
    return AiProfileBodyContext(
      height: parseNumber(height),
      age: parseInt(age),
      bust: parseNumber(bust),
      hips: parseNumber(hips),
      size: parseSize(size),
      weight: parseNumber(weight),
    );
  }

  static String? _optionalNumber(
    String? value, {
    required num min,
    required num max,
    required String label,
    required String unit,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = num.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number for ${label.toLowerCase()}.';
    }
    if (parsed < min || parsed > max) {
      return '$label must be between $min and $max $unit.';
    }
    return null;
  }
}
