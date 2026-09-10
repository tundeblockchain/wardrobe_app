/// Optional body/context measurements for Gemini try-on (WARDROBE-81).
///
/// Wire names follow the Backend WARDROBE-80 pairing set: `height`, `age`,
/// `bust`, `hips`, `size`, `weight`. Gender / body-type are omitted because
/// they are not on the current Flutter or Backend AI-profile schema.
///
/// Missing or empty values must never block try-on.
class AiProfileBodyContext {
  const AiProfileBodyContext({
    this.height,
    this.age,
    this.bust,
    this.hips,
    this.size,
    this.weight,
  });

  static const empty = AiProfileBodyContext();

  /// Height in centimetres. Wire key `height`.
  final num? height;

  /// Age in years. Wire key `age`.
  final int? age;

  /// Bust measurement in centimetres. Wire key `bust`.
  final num? bust;

  /// Hip measurement in centimetres. Wire key `hips`.
  final num? hips;

  /// Clothing size label. Wire key `size`.
  final String? size;

  /// Weight in kilograms. Wire key `weight`.
  final num? weight;

  bool get isEmpty {
    final trimmedSize = size?.trim();
    return height == null &&
        age == null &&
        bust == null &&
        hips == null &&
        (trimmedSize == null || trimmedSize.isEmpty) &&
        weight == null;
  }

  bool get isNotEmpty => !isEmpty;

  /// Short card line, or null when every field is empty.
  String? get summary {
    final parts = <String>[
      if (height != null) '${formatBodyNumber(height!)} cm',
      if (age != null) 'age $age',
      if (bust != null) 'bust ${formatBodyNumber(bust!)} cm',
      if (hips != null) 'hips ${formatBodyNumber(hips!)} cm',
      if (size != null && size!.trim().isNotEmpty) 'size ${size!.trim()}',
      if (weight != null) '${formatBodyNumber(weight!)} kg',
    ];
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' · ');
  }

  AiProfileBodyContext copyWith({
    num? height,
    int? age,
    num? bust,
    num? hips,
    String? size,
    num? weight,
    bool clearHeight = false,
    bool clearAge = false,
    bool clearBust = false,
    bool clearHips = false,
    bool clearSize = false,
    bool clearWeight = false,
  }) {
    return AiProfileBodyContext(
      height: clearHeight ? null : (height ?? this.height),
      age: clearAge ? null : (age ?? this.age),
      bust: clearBust ? null : (bust ?? this.bust),
      hips: clearHips ? null : (hips ?? this.hips),
      size: clearSize ? null : (size ?? this.size),
      weight: clearWeight ? null : (weight ?? this.weight),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AiProfileBodyContext &&
            other.height == height &&
            other.age == age &&
            other.bust == bust &&
            other.hips == hips &&
            other.size == size &&
            other.weight == weight;
  }

  @override
  int get hashCode => Object.hash(height, age, bust, hips, size, weight);

  @override
  String toString() {
    return 'AiProfileBodyContext(height: $height, age: $age, bust: $bust, '
        'hips: $hips, size: $size, weight: $weight)';
  }
}

/// Formats a measurement without a trailing `.0`.
String formatBodyNumber(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.round().toString();
  }
  return value.toString();
}
