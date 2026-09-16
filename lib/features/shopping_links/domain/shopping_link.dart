/// Similar product a user can buy. Backend-owned; Flutter never scrapes SERP.
class ShoppingLink {
  const ShoppingLink({
    required this.title,
    required this.url,
    this.price,
    this.merchant,
    this.imageUrl,
  });

  final String title;

  /// Display-ready price (`"£24.99"` or `"24.99"`). Null when unknown.
  final String? price;
  final String? merchant;

  /// External http(s) product URL.
  final String url;

  /// Optional product thumbnail. Null when missing or not http(s).
  final String? imageUrl;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShoppingLink &&
            title == other.title &&
            price == other.price &&
            merchant == other.merchant &&
            url == other.url &&
            imageUrl == other.imageUrl;
  }

  @override
  int get hashCode => Object.hash(title, price, merchant, url, imageUrl);
}

/// Parses an external product URL. Non-http(s) schemes are rejected.
Uri? tryParseShoppingUrl(String? raw) {
  if (raw == null) {
    return null;
  }
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.host.isEmpty) {
    return null;
  }
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') {
    return null;
  }
  return uri;
}
