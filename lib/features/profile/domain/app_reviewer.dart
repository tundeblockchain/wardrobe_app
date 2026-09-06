/// Store review prompt. Implementations use `in_app_review` and/or a store URL.
///
/// Override in tests so widget tests never hit the native review plugin.
abstract interface class AppReviewer {
  /// Requests an in-app review, falling back to the platform store listing.
  Future<void> requestReview();
}
