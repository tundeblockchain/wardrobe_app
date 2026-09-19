import '../../../core/network/api_exception.dart';

/// User-facing copy for worn-on 400 / 401 / 404 (WARDROBE-121).
abstract final class WornOnErrors {
  static const unauthenticated = 'Sign in again to log what you wore.';
  static const wardrobeNotFound = 'This wardrobe could not be found.';
  static const outfitNotFound = 'This outfit could not be found.';
  static const validation = 'Enter a valid calendar date (YYYY-MM-DD).';
  static const generic = 'Could not update the worn-on log. Try again.';
  static const range = 'Start date must be on or before the end date.';

  static const unauthenticatedCode = 'UNAUTHENTICATED';
  static const wardrobeNotFoundCode = 'WARDROBE_NOT_FOUND';
  static const outfitNotFoundCode = 'OUTFIT_NOT_FOUND';
  static const validationCode = 'VALIDATION_ERROR';

  static String messageFor(ApiException error) {
    switch (error.code) {
      case unauthenticatedCode:
        return unauthenticated;
      case wardrobeNotFoundCode:
        return wardrobeNotFound;
      case outfitNotFoundCode:
        return outfitNotFound;
      case validationCode:
        final backend = error.message.trim();
        return backend.isEmpty ? validation : backend;
    }
    if (error.statusCode == 401) {
      return unauthenticated;
    }
    if (error.statusCode == 400) {
      final backend = error.message.trim();
      return backend.isEmpty ? validation : backend;
    }
    if (error.statusCode == 404) {
      return generic;
    }
    final fallback = error.message.trim();
    return fallback.isEmpty ? generic : fallback;
  }

  /// GET list/calendar 404 without a known ownership code — route not live yet.
  static bool isUndeployedRoute(ApiException error) {
    if (error.statusCode != 404) {
      return false;
    }
    return error.code != wardrobeNotFoundCode &&
        error.code != outfitNotFoundCode;
  }

  static ApiException validationException([String? message]) {
    return ApiException(
      message: message ?? validation,
      code: validationCode,
      statusCode: 400,
    );
  }
}
