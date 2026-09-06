import 'item.dart';

/// Which clothing-item photo the browse UI should show.
///
/// Prefers the processed (background-removed) key when present, otherwise the
/// original upload. HTTP(S) values are treated as network URLs so cards can
/// render photos from the existing item payload without a new backend API.
class ItemImageSource {
  const ItemImageSource({this.key, this.networkUrl});

  /// Preferred object key or URL after processed-vs-original resolution.
  final String? key;

  /// [key] when it is already an `http(s)` URL.
  final String? networkUrl;

  bool get hasImage => key != null && key!.isNotEmpty;

  bool get isNetwork => networkUrl != null;

  factory ItemImageSource.fromItem(Item item) {
    final preferred =
        _nonEmpty(item.processedImageKey) ?? _nonEmpty(item.originalImageKey);
    return ItemImageSource(key: preferred, networkUrl: _asHttpUrl(preferred));
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
