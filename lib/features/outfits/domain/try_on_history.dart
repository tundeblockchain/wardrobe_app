import 'outfit_render.dart';

/// One successful try-on from Backend `renderHistory[]` (WARDROBE-85).
///
/// [imageKey] is storage-only. Display uses [imageUrl] when Backend presigned
/// it. A missing URL is omitted from the gallery — never built from the key.
class TryOnHistoryEntry {
  const TryOnHistoryEntry({
    required this.imageKey,
    required this.createdAt,
    required this.aiProfileId,
    this.imageUrl,
  });

  final String imageKey;
  final DateTime createdAt;
  final String aiProfileId;
  final String? imageUrl;

  bool get hasDisplayImage {
    return presignedTryOnUrl(imageUrl) != null;
  }
}

/// Short-lived http(s) GET only. S3 keys and other non-URLs are dropped.
String? presignedTryOnUrl(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    return null;
  }
  if (uri.host.isEmpty) {
    return null;
  }
  return trimmed;
}

/// Newest-first gallery URLs: `renderImageUrls`, then history, then `render`.
List<String> tryOnDisplayUrls({
  OutfitRender? latestRender,
  Iterable<String> renderImageUrls = const [],
  Iterable<TryOnHistoryEntry> history = const [],
}) {
  final urls = <String>[];
  void add(String? url) {
    final signed = presignedTryOnUrl(url);
    if (signed == null || urls.contains(signed)) {
      return;
    }
    urls.add(signed);
  }

  for (final url in renderImageUrls) {
    add(url);
  }
  for (final entry in history) {
    add(entry.imageUrl);
  }
  if (latestRender?.hasDisplayImage == true) {
    add(latestRender!.imageUrl);
  }
  return urls;
}

/// Hero photo: session pick, else `renderImageUrls[0]` / latest render URL.
String? outfitHeroImageUrl({
  OutfitRender? latestRender,
  Iterable<String> renderImageUrls = const [],
  Iterable<TryOnHistoryEntry> history = const [],
  String? selectedUrl,
}) {
  final urls = tryOnDisplayUrls(
    latestRender: latestRender,
    renderImageUrls: renderImageUrls,
    history: history,
  );
  final selected = presignedTryOnUrl(selectedUrl);
  if (selected != null && urls.contains(selected)) {
    return selected;
  }
  if (urls.isNotEmpty) {
    return urls.first;
  }
  return null;
}
