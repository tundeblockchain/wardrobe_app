/// Compose the public share URL from a client landing origin + relative path.
///
/// Never invents a host. [sharePath] must stay relative (`/share/{token}`).
abstract final class ShareLandingUrl {
  /// `{landingBaseUrl}{sharePath}` when both sides are usable http(s).
  static String? resolve({
    required String landingBaseUrl,
    required String sharePath,
  }) {
    final base = normalizeBase(landingBaseUrl);
    final path = normalizePath(sharePath);
    if (base == null || path == null) {
      return null;
    }
    return '$base$path';
  }

  /// http(s) origin without a trailing slash. Empty / junk → null.
  static String? normalizeBase(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final withoutSlash = trimmed.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(withoutSlash);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return null;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return null;
    }
    return withoutSlash;
  }

  /// Relative path only. Absolute http(s) values are rejected.
  static String? normalizePath(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (trimmed.contains('://')) {
      return null;
    }
    final path = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    final uri = Uri.tryParse(path);
    if (uri == null || uri.hasScheme || uri.hasAuthority) {
      return null;
    }
    return path;
  }
}
