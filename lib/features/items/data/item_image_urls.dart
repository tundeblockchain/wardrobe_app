/// HTTP(S) clothing-item photo URLs that may appear on create/list/get payloads.
///
/// Backend `ClothingItem` today only serializes `image.originalKey` /
/// `image.processedKey` (S3 object keys) plus `processingStatus`. These helpers
/// still inspect common URL aliases so a later contract addition works without
/// another Flutter mapper change. `uploadUrl` is a PUT presign from `POST /uploads`
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
