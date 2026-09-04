/// Abstraction for fetching a Firebase ID token at request time.
///
/// Implementations must not cache or persist tokens in app state.
library;

/// Supplies a short-lived ID token for outbound HTTP calls.
abstract interface class IdTokenSource {
  /// Returns the current user's ID token, or `null` when signed out.
  ///
  /// Call this on every request. Do not store the result.
  Future<String?> getIdToken({bool forceRefresh = false});
}

/// No-op source used when Firebase is not initialized (CI / unit tests).
class EmptyIdTokenSource implements IdTokenSource {
  const EmptyIdTokenSource();

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => null;
}
