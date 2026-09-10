import '../domain/ai_profile_body_context.dart';

/// WARDROBE-80 body/context keys on AI-profile create/get/list/PATCH JSON.
const aiProfileBodyContextWireKeys = <String>[
  'heightCm',
  'weightKg',
  'bustCm',
  'hipsCm',
  'clothingSize',
  'ageYears',
  'bodyType',
  'gender',
];

/// Reads optional WARDROBE-80 body keys from get/list JSON when present.
///
/// Missing / null / blank values are soft-omitted. Empty context does not
/// block try-on. Unknown extra JSON is ignored.
AiProfileBodyContext parseAiProfileBodyContext(Map<String, dynamic> json) {
  return AiProfileBodyContext(
    heightCm: _readNum(json['heightCm']),
    weightKg: _readNum(json['weightKg']),
    bustCm: _readNum(json['bustCm']),
    hipsCm: _readNum(json['hipsCm']),
    clothingSize: _readString(json['clothingSize']),
    ageYears: _readInt(json['ageYears']),
    bodyType: _readString(json['bodyType']),
    gender: _readString(json['gender']),
  );
}

/// Create / POST body: filled WARDROBE-80 fields only (soft-omit empties).
Map<String, dynamic> aiProfileBodyContextToJson(AiProfileBodyContext context) {
  return <String, dynamic>{
    if (context.heightCm != null) 'heightCm': _jsonNum(context.heightCm!),
    if (context.weightKg != null) 'weightKg': _jsonNum(context.weightKg!),
    if (context.bustCm != null) 'bustCm': _jsonNum(context.bustCm!),
    if (context.hipsCm != null) 'hipsCm': _jsonNum(context.hipsCm!),
    if (context.clothingSize != null && context.clothingSize!.trim().isNotEmpty)
      'clothingSize': context.clothingSize!.trim(),
    if (context.ageYears != null) 'ageYears': context.ageYears,
    if (context.bodyType != null && context.bodyType!.trim().isNotEmpty)
      'bodyType': context.bodyType!.trim(),
    if (context.gender != null && context.gender!.trim().isNotEmpty)
      'gender': context.gender!.trim(),
  };
}

/// PATCH body: every WARDROBE-80 key, with `null` to clear a stored field.
Map<String, dynamic> aiProfileBodyContextToPatchJson(
  AiProfileBodyContext context,
) {
  return <String, dynamic>{
    'heightCm': context.heightCm == null ? null : _jsonNum(context.heightCm!),
    'weightKg': context.weightKg == null ? null : _jsonNum(context.weightKg!),
    'bustCm': context.bustCm == null ? null : _jsonNum(context.bustCm!),
    'hipsCm': context.hipsCm == null ? null : _jsonNum(context.hipsCm!),
    'clothingSize': _patchString(context.clothingSize),
    'ageYears': context.ageYears,
    'bodyType': _patchString(context.bodyType),
    'gender': _patchString(context.gender),
  };
}

String? _patchString(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

num? _readNum(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value;
  }
  if (value is String) {
    return num.tryParse(value.trim());
  }
  return null;
}

int? _readInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    if (value != value.roundToDouble()) {
      return null;
    }
    return value.round();
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

String? _readString(dynamic value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

Object _jsonNum(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.round();
  }
  return value;
}
