import '../domain/shopping_link.dart';

/// Normalizes Backend `price` which may be a string, number, or null.
String? shoppingPriceFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is num) {
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
  final fallback = value.toString().trim();
  return fallback.isEmpty ? null : fallback;
}

String? _optionalString(Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _firstString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _optionalString(json[key]);
    if (value != null) {
      return value;
    }
  }
  return null;
}

/// Maps one link object. Invalid title/url entries return null (soft-skip).
ShoppingLink? shoppingLinkFromJson(Map<String, dynamic> json) {
  final title = _firstString(json, const ['title', 'name']);
  final url = _firstString(json, const ['url', 'link', 'href']);
  if (title == null || url == null) {
    return null;
  }
  final parsedUrl = tryParseShoppingUrl(url);
  if (parsedUrl == null) {
    return null;
  }
  final rawImage = _firstString(json, const [
    'imageUrl',
    'image_url',
    'image',
    'thumbnail',
  ]);
  final imageUri = tryParseShoppingUrl(rawImage);
  return ShoppingLink(
    title: title,
    url: parsedUrl.toString(),
    price: shoppingPriceFromJson(json['price']),
    merchant: _firstString(json, const ['merchant', 'store', 'seller']),
    imageUrl: imageUri?.toString(),
  );
}

List<dynamic>? _listFromEnvelope(Map<String, dynamic> json) {
  for (final key in const [
    'links',
    'shoppingLinks',
    'shopping_links',
    'results',
    'items',
  ]) {
    final value = json[key];
    if (value is List) {
      return value;
    }
  }
  return null;
}

/// Parses `{ "links": [...] }`, aliases, a bare array, or null → empty.
///
/// Unusable payloads become an empty list so Home / item detail never crash.
List<ShoppingLink> parseShoppingLinkList(dynamic data) {
  if (data == null) {
    return const [];
  }
  if (data is List) {
    return _mapLinkList(data);
  }
  if (data is Map) {
    final json = Map<String, dynamic>.from(data);
    final nested = _listFromEnvelope(json);
    if (nested != null) {
      return _mapLinkList(nested);
    }
    final single = shoppingLinkFromJson(json);
    return single == null ? const [] : [single];
  }
  return const [];
}

List<ShoppingLink> _mapLinkList(List<dynamic> raw) {
  final links = <ShoppingLink>[];
  for (final entry in raw) {
    if (entry is! Map) {
      continue;
    }
    final link = shoppingLinkFromJson(Map<String, dynamic>.from(entry));
    if (link != null) {
      links.add(link);
    }
  }
  return links;
}
