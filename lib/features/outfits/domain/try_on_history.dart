import '../../../core/network/api_exception.dart';
import 'outfit_render.dart';

/// Status / codes that mean WARDROBE-85 is missing or this outfit has no rows.
bool isTryOnHistoryGap(ApiException error) {
  final status = error.statusCode;
  if (status == 404 || status == 405 || status == 501) {
    return true;
  }
  const codes = {
    'NOT_FOUND',
    'RENDER_NOT_FOUND',
    'RENDER_HISTORY_NOT_FOUND',
    'NOT_IMPLEMENTED',
  };
  return codes.contains(error.code);
}

/// One persisted try-on from the expected WARDROBE-85 history collection.
///
/// Reuses [OutfitRender] fields (`status`, `aiProfileId`, `imageKey`,
/// `imageUrl`, `error`). Optional [id] / [createdAt] are read when Backend
/// sends them; they are not written onto [Outfit] or [OutfitRender].
class TryOnHistoryEntry {
  const TryOnHistoryEntry({required this.render, this.id, this.createdAt});

  final OutfitRender render;
  final String? id;
  final DateTime? createdAt;

  bool get hasDisplayImage => render.hasDisplayImage;

  String? get imageUrl {
    if (!hasDisplayImage) {
      return null;
    }
    return render.imageUrl?.trim();
  }
}

/// Newest-first http(s) try-on URLs: history first, then the outfit's latest
/// `render.imageUrl` when it is not already in that list.
List<String> tryOnDisplayUrls({
  OutfitRender? latestRender,
  Iterable<TryOnHistoryEntry> history = const [],
}) {
  final urls = <String>[];
  void add(String? url) {
    final trimmed = url?.trim();
    if (trimmed == null || trimmed.isEmpty || urls.contains(trimmed)) {
      return;
    }
    urls.add(trimmed);
  }

  for (final entry in history) {
    add(entry.imageUrl);
  }
  if (latestRender?.hasDisplayImage == true) {
    add(latestRender!.imageUrl);
  }
  return urls;
}

/// Hero photo: session pick, else first history/latest URL, else null.
String? outfitHeroImageUrl({
  OutfitRender? latestRender,
  Iterable<TryOnHistoryEntry> history = const [],
  String? selectedUrl,
}) {
  final urls = tryOnDisplayUrls(latestRender: latestRender, history: history);
  final selected = selectedUrl?.trim();
  if (selected != null && selected.isNotEmpty && urls.contains(selected)) {
    return selected;
  }
  if (urls.isNotEmpty) {
    return urls.first;
  }
  return null;
}
