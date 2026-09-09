/// HTTP(S) URL whose path looks like `front.png` / `front.jpg`, else the first.
String? pickFrontalHttpUrl(Iterable<String?> candidates) {
  final urls = <String>[];
  for (final candidate in candidates) {
    final url = asPreviewHttpUrl(candidate);
    if (url != null && !urls.contains(url)) {
      urls.add(url);
    }
  }
  if (urls.isEmpty) {
    return null;
  }
  for (final url in urls) {
    if (isFrontalReferencePath(url)) {
      return url;
    }
  }
  return urls.first;
}

/// True when [value] looks like the seeded frontal reference (`front.png`).
bool isFrontalReferencePath(String value) {
  final path = (Uri.tryParse(value)?.path ?? value).toLowerCase();
  return RegExp(r'(^|/)front\.(png|jpe?g|webp|heic)$').hasMatch(path) ||
      RegExp(r'(^|/)front$').hasMatch(path);
}

/// Same http(s) guard as clothing-item display URLs. S3 keys return null.
String? asPreviewHttpUrl(String? value) {
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
