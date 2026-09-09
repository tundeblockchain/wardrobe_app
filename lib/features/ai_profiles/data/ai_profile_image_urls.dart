import '../domain/ai_profile_preview.dart';

/// Dedicated URL fields inspected on AI-profile get/list JSON.
///
/// Backend `wardrobe-backend` main @ `840b921` (WARDROBE-43/45 `toAiProfile`)
/// currently returns only:
/// `aiProfileId`, `type`, `label`, `referenceImages`, `status`, `createdAt`,
/// `updatedAt`.
///
/// `referenceImages` is S3 object keys (generic
/// `shared/ai-profiles/generic/{slug}/front.jpg`, personal
/// `users/{uid}/ai-profiles/{aiProfileId}/{id}.ext`) — not GET URLs.
/// PERSONAL get/list has no `imageUrl`, `referenceImageUrls`, or
/// `frontImageUrl`. WARDROBE-72 may start returning http(s) values; those are
/// used when present. S3 keys are never turned into fabricated URLs.
const aiProfileDedicatedImageUrlFields = <String>[
  'frontImageUrl',
  'previewImageUrl',
  'referenceImageUrl',
  'imageUrl',
];

/// List aliases inspected if Backend adds them on get/list.
const aiProfileImageUrlListFields = <String>[
  'referenceImageUrls',
  'previewImageUrls',
  'imageUrls',
];

/// First http(s) picker URL on [json], preferring a frontal reference.
String? extractAiProfileImageUrl(Map<String, dynamic> json) {
  return pickFrontalHttpUrl([
    ..._listValues(json, aiProfileImageUrlListFields),
    ..._valuesAt(json, aiProfileDedicatedImageUrlFields),
    ..._referenceImageCandidates(json['referenceImages']),
    ..._valuesAt(_nestedImage(json), aiProfileDedicatedImageUrlFields),
    ..._listValues(_nestedImage(json), aiProfileImageUrlListFields),
  ]);
}

/// Object keys from `referenceImages` (strings or `{ objectKey|key }`).
List<String> parseReferenceImageKeys(dynamic value) {
  if (value is! List) {
    return const [];
  }
  final keys = <String>[];
  for (final entry in value) {
    if (entry is String) {
      final trimmed = entry.trim();
      if (trimmed.isNotEmpty) {
        keys.add(trimmed);
      }
      continue;
    }
    if (entry is Map) {
      final key = entry['objectKey'] ?? entry['key'] ?? entry['imageKey'];
      if (key is String && key.trim().isNotEmpty) {
        keys.add(key.trim());
      }
    }
  }
  return keys;
}

Iterable<String?> _referenceImageCandidates(dynamic value) sync* {
  if (value is! List) {
    return;
  }
  for (final entry in value) {
    if (entry is String) {
      yield entry;
      continue;
    }
    if (entry is Map) {
      final map = Map<String, dynamic>.from(entry);
      yield map['url']?.toString();
      yield map['imageUrl']?.toString();
      yield map['frontImageUrl']?.toString();
      yield map['objectKey']?.toString();
      yield map['key']?.toString();
    }
  }
}

Iterable<String?> _listValues(
  Map<String, dynamic> json,
  List<String> keys,
) sync* {
  for (final key in keys) {
    final value = json[key];
    if (value is List) {
      for (final entry in value) {
        if (entry is String) {
          yield entry;
        } else if (entry is Map) {
          yield entry['url']?.toString();
          yield entry['imageUrl']?.toString();
        }
      }
    }
  }
}

Iterable<String?> _valuesAt(Map<String, dynamic> json, List<String> keys) {
  return [for (final key in keys) json[key]?.toString()];
}

Map<String, dynamic> _nestedImage(Map<String, dynamic> json) {
  final image = json['image'];
  if (image is Map) {
    return Map<String, dynamic>.from(image);
  }
  return const {};
}
