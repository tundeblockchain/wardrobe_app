import 'item.dart';

/// Which clothing-item photo the browse UI should show.
///
/// Prefers a processed HTTP(S) URL when the worker has finished, otherwise the
/// original upload URL. A processed *object key* never hides an original URL
/// while status is still PENDING / PROCESSING (or whenever no processed GET
/// exists yet). HTTP(S) values are treated as network URLs so cards can render
/// photos from the existing item payload without inventing a backend API.
class ItemImageSource {
  const ItemImageSource({this.key, this.networkUrl});

  /// Preferred object key or URL after processed-vs-original resolution.
  final String? key;

  /// First usable `http(s)` photo among processed, then original.
  final String? networkUrl;

  bool get hasImage => key != null && key!.isNotEmpty;

  bool get isNetwork => networkUrl != null;

  factory ItemImageSource.fromItem(Item item) {
    final processed = _nonEmpty(item.processedImageKey);
    final original = _nonEmpty(item.originalImageKey);
    final preferredUrl = _asHttpUrl(processed) ?? _asHttpUrl(original);
    final preferredKey = preferredUrl ?? processed ?? original;
    return ItemImageSource(key: preferredKey, networkUrl: preferredUrl);
  }
}

String? _nonEmpty(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

String? _asHttpUrl(String? value) {
  if (value == null) {
    return null;
  }
  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    return null;
  }
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    return null;
  }
  return value;
}
