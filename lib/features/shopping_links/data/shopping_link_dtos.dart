import '../domain/shopping_link.dart';

String? _optionalString(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}

/// Wire `price` is a string; numbers are stringified as a safety net.
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
  return _optionalString(value.toString());
}

List<String> _stringList(Object? value) {
  if (value is! List) {
    return const [];
  }
  final out = <String>[];
  for (final entry in value) {
    final text = _optionalString(entry is String ? entry : null);
    if (text != null) {
      out.add(text);
    }
  }
  return out;
}

bool _cachedFromJson(Object? value) => value == true;

/// Maps one locked Link object. Invalid title/url entries return null.
ShoppingLink? shoppingLinkFromJson(Map<String, dynamic> json) {
  final title = _optionalString(json['title']);
  final url = _optionalString(json['url']);
  if (title == null || url == null) {
    return null;
  }
  final parsedUrl = tryParseShoppingUrl(url);
  if (parsedUrl == null) {
    return null;
  }
  final imageUri = tryParseShoppingUrl(_optionalString(json['imageUrl']));
  return ShoppingLink(
    title: title,
    url: parsedUrl.toString(),
    merchant: _optionalString(json['merchant']),
    price: shoppingPriceFromJson(json['price']),
    currency: _optionalString(json['currency']),
    imageUrl: imageUri?.toString(),
  );
}

List<ShoppingLink> parseShoppingLinkList(Object? raw) {
  if (raw is! List) {
    return const [];
  }
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

ShoppingLinksWarning? parseShoppingLinksWarning(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final json = Map<String, dynamic>.from(raw);
  final code = _optionalString(json['code']);
  final message = _optionalString(json['message']);
  if (code == null || message == null) {
    return null;
  }
  return ShoppingLinksWarning(code: code, message: message);
}

/// Item 200: `{ itemId, wardrobeId, keywords[], cached, links[], warning? }`.
ShoppingLinksItemResult parseItemShoppingLinks(
  Object? data, {
  String? fallbackItemId,
  String? fallbackWardrobeId,
}) {
  if (data is! Map) {
    return ShoppingLinksItemResult(
      itemId: fallbackItemId ?? '',
      wardrobeId: fallbackWardrobeId ?? '',
    );
  }
  final json = Map<String, dynamic>.from(data);
  return ShoppingLinksItemResult(
    itemId: _optionalString(json['itemId']) ?? fallbackItemId ?? '',
    wardrobeId: _optionalString(json['wardrobeId']) ?? fallbackWardrobeId ?? '',
    keywords: _stringList(json['keywords']),
    cached: _cachedFromJson(json['cached']),
    links: parseShoppingLinkList(json['links']),
    warning: parseShoppingLinksWarning(json['warning']),
  );
}

/// Home 200: `{ items: [ ShoppingLinksItemResult... ] }`.
HomeShoppingLinks parseHomeShoppingLinks(Object? data) {
  if (data is! Map) {
    return const HomeShoppingLinks();
  }
  final json = Map<String, dynamic>.from(data);
  final rawItems = json['items'];
  if (rawItems is! List) {
    return const HomeShoppingLinks();
  }
  final items = <ShoppingLinksItemResult>[];
  for (final entry in rawItems) {
    if (entry is! Map) {
      continue;
    }
    items.add(parseItemShoppingLinks(Map<String, dynamic>.from(entry)));
  }
  return HomeShoppingLinks(items: items);
}
