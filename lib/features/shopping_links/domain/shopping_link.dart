/// Similar product a user can buy. Backend-owned; Flutter never scrapes SERP.
///
/// Locked WARDROBE-96 contract ([wardrobe-backend#47](https://github.com/tundeblockchain/wardrobe-backend/pull/47)
/// squash `aaf46cd` on main). Soft-omit unset optionals — never persist JSON `null`.
class ShoppingLink {
  const ShoppingLink({
    required this.title,
    required this.url,
    this.merchant,
    this.price,
    this.currency,
    this.imageUrl,
  });

  final String title;
  final String url;
  final String? merchant;

  /// Display string from the wire (`"£12.99"` or `"12.99"`).
  final String? price;
  final String? currency;

  /// Optional product thumbnail. Null when missing or not http(s).
  final String? imageUrl;

  /// Price for the card. Appends [currency] when it is not already in [price].
  String? get displayPrice {
    final raw = price;
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final code = currency;
    if (code == null || code.isEmpty) {
      return raw;
    }
    if (raw.contains(code) || _currencySymbol.hasMatch(raw)) {
      return raw;
    }
    return '$raw $code';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShoppingLink &&
            title == other.title &&
            url == other.url &&
            merchant == other.merchant &&
            price == other.price &&
            currency == other.currency &&
            imageUrl == other.imageUrl;
  }

  @override
  int get hashCode =>
      Object.hash(title, url, merchant, price, currency, imageUrl);
}

final _currencySymbol = RegExp(r'[£$€¥₹]');

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

/// Locked WARDROBE-96 warning on a 200 with empty or stale links.
class ShoppingLinksWarning {
  const ShoppingLinksWarning({required this.code, required this.message});

  static const upstreamUnavailable = 'SHOPPING_UPSTREAM_UNAVAILABLE';

  final String code;
  final String message;

  bool get isUpstreamUnavailable => code == upstreamUnavailable;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShoppingLinksWarning &&
            code == other.code &&
            message == other.message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}

/// One clothing item’s shopping section (item detail or a Home row).
class ShoppingLinksItemResult {
  const ShoppingLinksItemResult({
    required this.itemId,
    required this.wardrobeId,
    this.keywords = const [],
    this.cached = false,
    this.links = const [],
    this.warning,
  });

  final String itemId;
  final String wardrobeId;
  final List<String> keywords;
  final bool cached;
  final List<ShoppingLink> links;
  final ShoppingLinksWarning? warning;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShoppingLinksItemResult &&
            itemId == other.itemId &&
            wardrobeId == other.wardrobeId &&
            cached == other.cached &&
            warning == other.warning &&
            _stringListEquals(keywords, other.keywords) &&
            _linkListEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    wardrobeId,
    cached,
    warning,
    Object.hashAll(keywords),
    Object.hashAll(links),
  );
}

/// `GET /shopping-links` envelope.
class HomeShoppingLinks {
  const HomeShoppingLinks({this.items = const []});

  final List<ShoppingLinksItemResult> items;

  List<ShoppingLink> get flattenedLinks => [
    for (final item in items) ...item.links,
  ];

  /// Upstream warning when nothing could be shown.
  ShoppingLinksWarning? get upstreamWarning {
    if (flattenedLinks.isNotEmpty) {
      return null;
    }
    for (final item in items) {
      final warning = item.warning;
      if (warning != null && warning.isUpstreamUnavailable) {
        return warning;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeShoppingLinks && _itemListEquals(items, other.items);
  }

  @override
  int get hashCode => Object.hashAll(items);
}

bool _stringListEquals(List<String> a, List<String> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

bool _linkListEquals(List<ShoppingLink> a, List<ShoppingLink> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

bool _itemListEquals(
  List<ShoppingLinksItemResult> a,
  List<ShoppingLinksItemResult> b,
) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
