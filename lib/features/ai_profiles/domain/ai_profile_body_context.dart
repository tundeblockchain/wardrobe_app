/// Optional body/context measurements for Gemini try-on (WARDROBE-81/83).
///
/// Wire names match Backend WARDROBE-80 plus WARDROBE-82 `braSize`
/// (`wardrobe-backend` main @ `5ed1375`):
/// `heightCm`, `weightKg`, `bustCm`, `hipsCm`, `clothingSize`, `braSize`,
/// `ageYears`, `bodyType`, `gender`. Missing or empty values must never
/// block try-on. No aliases.
class AiProfileBodyContext {
  const AiProfileBodyContext({
    this.heightCm,
    this.weightKg,
    this.bustCm,
    this.hipsCm,
    this.clothingSize,
    this.braSize,
    this.ageYears,
    this.bodyType,
    this.gender,
  });

  static const empty = AiProfileBodyContext();

  /// Height in centimetres. Wire key `heightCm`.
  final num? heightCm;

  /// Weight in kilograms. Wire key `weightKg`.
  final num? weightKg;

  /// Bust measurement in centimetres. Wire key `bustCm`.
  final num? bustCm;

  /// Hip measurement in centimetres. Wire key `hipsCm`.
  final num? hipsCm;

  /// Clothing size label. Wire key `clothingSize`.
  final String? clothingSize;

  /// Bra size label (e.g. `34B`). Wire key `braSize` (WARDROBE-82).
  final String? braSize;

  /// Age in years. Wire key `ageYears`.
  final int? ageYears;

  /// Body type token. Wire key `bodyType`.
  final String? bodyType;

  /// Gender token. Wire key `gender`.
  final String? gender;

  bool get isEmpty {
    return heightCm == null &&
        weightKg == null &&
        bustCm == null &&
        hipsCm == null &&
        (clothingSize == null || clothingSize!.trim().isEmpty) &&
        (braSize == null || braSize!.trim().isEmpty) &&
        ageYears == null &&
        (bodyType == null || bodyType!.trim().isEmpty) &&
        (gender == null || gender!.trim().isEmpty);
  }

  bool get isNotEmpty => !isEmpty;

  /// Short card line, or null when every field is empty.
  String? get summary {
    final parts = <String>[
      if (heightCm != null) '${formatBodyNumber(heightCm!)} cm',
      if (weightKg != null) '${formatBodyNumber(weightKg!)} kg',
      if (ageYears != null) '$ageYears years',
      if (bustCm != null) 'bust ${formatBodyNumber(bustCm!)} cm',
      if (hipsCm != null) 'hips ${formatBodyNumber(hipsCm!)} cm',
      if (clothingSize != null && clothingSize!.trim().isNotEmpty)
        'size ${clothingSize!.trim()}',
      if (braSize != null && braSize!.trim().isNotEmpty)
        'bra ${braSize!.trim()}',
      if (bodyType != null && bodyType!.trim().isNotEmpty)
        aiProfileTokenLabel(bodyType!),
      if (gender != null && gender!.trim().isNotEmpty)
        aiProfileTokenLabel(gender!),
    ];
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' · ');
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AiProfileBodyContext &&
            other.heightCm == heightCm &&
            other.weightKg == weightKg &&
            other.bustCm == bustCm &&
            other.hipsCm == hipsCm &&
            other.clothingSize == clothingSize &&
            other.braSize == braSize &&
            other.ageYears == ageYears &&
            other.bodyType == bodyType &&
            other.gender == gender;
  }

  @override
  int get hashCode => Object.hash(
    heightCm,
    weightKg,
    bustCm,
    hipsCm,
    clothingSize,
    braSize,
    ageYears,
    bodyType,
    gender,
  );

  @override
  String toString() {
    return 'AiProfileBodyContext(heightCm: $heightCm, weightKg: $weightKg, '
        'bustCm: $bustCm, hipsCm: $hipsCm, clothingSize: $clothingSize, '
        'braSize: $braSize, ageYears: $ageYears, bodyType: $bodyType, '
        'gender: $gender)';
  }
}

/// Recommended `gender` tokens (WARDROBE-80). Other non-empty strings are kept.
const aiProfileGenders = <String>[
  'FEMALE',
  'MALE',
  'NON_BINARY',
  'UNSPECIFIED',
];

/// Recommended `bodyType` tokens (WARDROBE-80). Other non-empty strings are kept.
const aiProfileBodyTypes = <String>[
  'SLIM',
  'AVERAGE',
  'ATHLETIC',
  'CURVY',
  'PLUS',
  'PETITE',
];

/// Formats a measurement without a trailing `.0`.
String formatBodyNumber(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value.toString();
}

/// Human label for a recommended gender / body-type token.
String aiProfileTokenLabel(String value) {
  return switch (value) {
    'FEMALE' => 'Female',
    'MALE' => 'Male',
    'NON_BINARY' => 'Non-binary',
    'UNSPECIFIED' => 'Unspecified',
    'SLIM' => 'Slim',
    'AVERAGE' => 'Average',
    'ATHLETIC' => 'Athletic',
    'CURVY' => 'Curvy',
    'PLUS' => 'Plus',
    'PETITE' => 'Petite',
    _ => value,
  };
}
