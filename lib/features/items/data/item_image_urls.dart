/// HTTP(S) clothing-item photo URLs on create / list / get / PATCH.
///
/// Backend WARDROBE-54 locks top-level `originalImageUrl` (presigned GET,
/// TTL 900s, whenever `image.originalKey` exists) and `processedImageUrl`
/// (whenever `image.processedKey` exists). S3 keys stay on `image`. Extra
/// aliases remain as fallbacks. `uploadUrl` from `POST /uploads` is PUT-only
/// and is never treated as a display GET.
const itemOriginalImageUrlFields = <String>[
  'originalImageUrl',
  'rawImageUrl',
  'originalUrl',
];

const itemProcessedImageUrlFields = <String>[
  'processedImageUrl',
  'processedUrl',
];

const itemGenericImageUrlFields = <String>['imageUrl', 'url'];

/// First http(s) original-photo URL on [json], including a nested `image` map.
String? extractOriginalImageUrl(Map<String, dynamic> json) {
  final nested = _nestedImage(json);
  return firstHttpUrl([
    ..._valuesAt(json, itemOriginalImageUrlFields),
    ..._valuesAt(nested, itemOriginalImageUrlFields),
    ..._valuesAt(json, itemGenericImageUrlFields),
    ..._valuesAt(nested, itemGenericImageUrlFields),
  ]);
}

/// First http(s) processed-photo URL on [json], including a nested `image` map.
String? extractProcessedImageUrl(Map<String, dynamic> json) {
  final nested = _nestedImage(json);
  return firstHttpUrl([
    ..._valuesAt(json, itemProcessedImageUrlFields),
    ..._valuesAt(nested, itemProcessedImageUrlFields),
  ]);
}

String? firstHttpUrl(Iterable<String?> candidates) {
  for (final candidate in candidates) {
    final url = asHttpUrl(candidate);
    if (url != null) {
      return url;
    }
  }
  return null;
}

String? asHttpUrl(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    return null;
  }
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    return null;
  }
  return trimmed;
}

Map<String, dynamic> _nestedImage(Map<String, dynamic> json) {
  final image = json['image'];
  if (image is Map) {
    return Map<String, dynamic>.from(image);
  }
  return const {};
}

Iterable<String?> _valuesAt(Map<String, dynamic> json, List<String> keys) {
  return [for (final key in keys) json[key]?.toString()];
}
