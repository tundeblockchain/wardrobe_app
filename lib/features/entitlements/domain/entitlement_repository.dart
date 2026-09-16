import 'entitlement.dart';

/// Reads the current user's entitlement snapshot.
///
/// Production talks to `GET /me/entitlements` (WARDROBE-91). Tests override.
abstract class EntitlementRepository {
  Future<Entitlement> fetchEntitlements();
}
