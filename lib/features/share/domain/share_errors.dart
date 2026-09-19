import '../../../core/network/api_exception.dart';

/// User-facing copy for share create / revoke (WARDROBE-128).
abstract final class ShareErrors {
  static const missingLandingBase =
      'Sharing is not configured. Set SHARE_LANDING_BASE_URL in local dart-defines.';
  static const unavailable =
      'Sharing is not available yet. Please try again later.';
  static const unauthenticated = 'Sign in again to share this look.';
  static const itemNotFound = 'This item could not be found.';
  static const outfitNotFound = 'This outfit could not be found.';
  static const wardrobeNotFound = 'This wardrobe could not be found.';
  static const generic = 'Could not create a share link. Please try again.';
  static const sheetFailed =
      'Could not open the share sheet. Please try again.';
  static const invalidUrl =
      'Could not build a share link. Check SHARE_LANDING_BASE_URL.';
  static const invalidResponse = 'Unexpected share response.';

  static const unauthenticatedCode = 'UNAUTHENTICATED';
  static const wardrobeNotFoundCode = 'WARDROBE_NOT_FOUND';
  static const itemNotFoundCode = 'ITEM_NOT_FOUND';
  static const outfitNotFoundCode = 'OUTFIT_NOT_FOUND';
  static const shareNotFoundCode = 'SHARE_NOT_FOUND';
  static const shareGoneCode = 'SHARE_GONE';

  static String messageFor(ApiException error) {
    switch (error.code) {
      case unauthenticatedCode:
        return unauthenticated;
      case wardrobeNotFoundCode:
        return wardrobeNotFound;
      case itemNotFoundCode:
        return itemNotFound;
      case outfitNotFoundCode:
        return outfitNotFound;
      case shareNotFoundCode:
      case shareGoneCode:
        return unavailable;
    }
    if (error.statusCode == 401) {
      return unauthenticated;
    }
    if (isUndeployedRoute(error)) {
      return unavailable;
    }
    final fallback = error.message.trim();
    return fallback.isEmpty ? generic : fallback;
  }

  /// Create 404 without a known ownership code — route not live yet.
  static bool isUndeployedRoute(ApiException error) {
    if (error.statusCode != 404) {
      return false;
    }
    return error.code != wardrobeNotFoundCode &&
        error.code != itemNotFoundCode &&
        error.code != outfitNotFoundCode &&
        error.code != shareNotFoundCode;
  }
}
