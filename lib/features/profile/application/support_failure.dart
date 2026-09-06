import '../../../core/network/api_exception.dart';

/// User-facing copy when a support POST fails.
///
/// WARDROBE-38 may not be live yet. A missing route must not fall back to
/// mailto — show a friendly message instead.
String messageForSupportFailure(Object error) {
  if (error is ApiException) {
    if (error.statusCode == 404 ||
        error.statusCode == 501 ||
        error.statusCode == 503 ||
        error.code == 'NOT_FOUND') {
      return "Support isn't available yet. Please try again later.";
    }
    return error.message;
  }
  return 'Something went wrong. Please try again.';
}
