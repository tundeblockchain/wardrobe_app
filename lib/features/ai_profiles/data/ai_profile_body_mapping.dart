import '../domain/ai_profile_body_context.dart';

/// WARDROBE-80 pairing-set keys inspected on AI-profile get/list JSON.
///
/// Current Backend `toAiProfile` / `toAiProfileDto` (wardrobe-backend main)
/// returns only `aiProfileId`, `type`, `label`, `referenceImages`, `status`,
/// `createdAt`, `updatedAt`, plus optional `frontImageUrl` /
/// `referenceImageUrls`. There is no PATCH / update AI-profile route and no
/// body fields on create.
///
/// These keys are prepared for WARDROBE-80. They are never added to
/// [CreateAiProfileRequest] and are never POSTed. Unknown extra JSON is
/// ignored. Empty / missing values stay empty and do not block try-on.
const aiProfileBodyContextWireKeys = <String>[
  'height',
  'age',
  'bust',
  'hips',
  'size',
  'weight',
];

/// Reads optional WARDROBE-80 body keys from get/list JSON when present.
AiProfileBodyContext parseAiProfileBodyContext(Map<String, dynamic> json) {
  final size = _readString(json['size']);
  return AiProfileBodyContext(
    height: _readNum(json['height']),
    age: _readInt(json['age']),
    bust: _readNum(json['bust']),
    hips: _readNum(json['hips']),
    size: size,
    weight: _readNum(json['weight']),
  );
}

/// Serializes filled fields only, using WARDROBE-80 wire names.
///
/// Empty context → `{}`. Callers must not invent an endpoint to send this.
Map<String, dynamic> aiProfileBodyContextToJson(AiProfileBodyContext context) {
  return <String, dynamic>{
    if (context.height != null) 'height': _jsonNum(context.height!),
    if (context.age != null) 'age': context.age,
    if (context.bust != null) 'bust': _jsonNum(context.bust!),
    if (context.hips != null) 'hips': _jsonNum(context.hips!),
    if (context.size != null && context.size!.trim().isNotEmpty)
      'size': context.size!.trim(),
    if (context.weight != null) 'weight': _jsonNum(context.weight!),
  };
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
