import 'ai_profile_body_context.dart';

/// Light range checks aligned with Backend WARDROBE-80.
///
/// Empty / whitespace values are always valid so try-on is never blocked.
abstract final class AiProfileBodyValidators {
  static const minHeightCm = 50;
  static const maxHeightCm = 250;
  static const minWeightKg = 15;
  static const maxWeightKg = 400;
  static const minBustCm = 40;
  static const maxBustCm = 200;
  static const minHipsCm = 40;
  static const maxHipsCm = 200;
  static const minAgeYears = 1;
  static const maxAgeYears = 120;
  static const maxClothingSizeLength = 32;
  static const maxTokenLength = 32;

  static String? heightCm(String? value) {
    return _optionalNumber(
      value,
      min: minHeightCm,
      max: maxHeightCm,
      label: 'Height',
      unit: 'cm',
    );
  }

  static String? weightKg(String? value) {
    return _optionalNumber(
      value,
      min: minWeightKg,
      max: maxWeightKg,
      label: 'Weight',
      unit: 'kg',
    );
  }

  static String? bustCm(String? value) {
    return _optionalNumber(
      value,
      min: minBustCm,
      max: maxBustCm,
      label: 'Bust',
      unit: 'cm',
    );
  }

  static String? hipsCm(String? value) {
    return _optionalNumber(
      value,
      min: minHipsCm,
      max: maxHipsCm,
      label: 'Hips',
      unit: 'cm',
    );
  }

  static String? ageYears(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a whole number for age.';
    }
    if (parsed < minAgeYears || parsed > maxAgeYears) {
      return 'Age must be between $minAgeYears and $maxAgeYears years.';
    }
    return null;
  }

  static String? clothingSize(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > maxClothingSizeLength) {
      return 'Clothing size must be $maxClothingSizeLength characters or fewer.';
    }
    return null;
  }

  static String? bodyType(String? value) => _optionalToken(value, 'Body type');

  static String? gender(String? value) => _optionalToken(value, 'Gender');

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

  static String? parseToken(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static AiProfileBodyContext parseForm({
    required String heightCm,
    required String weightKg,
    required String bustCm,
    required String hipsCm,
    required String clothingSize,
    required String ageYears,
    String? bodyType,
    String? gender,
  }) {
    return AiProfileBodyContext(
      heightCm: parseNumber(heightCm),
      weightKg: parseNumber(weightKg),
      bustCm: parseNumber(bustCm),
      hipsCm: parseNumber(hipsCm),
      clothingSize: parseToken(clothingSize),
      ageYears: parseInt(ageYears),
      bodyType: parseToken(bodyType),
      gender: parseToken(gender),
    );
  }

  static String? _optionalToken(String? value, String label) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    if (trimmed.length > maxTokenLength) {
      return '$label must be $maxTokenLength characters or fewer.';
    }
    return null;
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
