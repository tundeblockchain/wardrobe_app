import 'entitlement.dart';

/// Reads the current user's entitlement snapshot.
///
/// Production talks to `GET /me` (WARDROBE-91), then `GET /me/entitlement` if
/// `/me` is 404. Tests override [entitlementRepositoryProvider].
abstract class EntitlementRepository {
  Future<Entitlement> fetchEntitlements();
}
