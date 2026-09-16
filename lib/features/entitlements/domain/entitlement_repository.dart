import 'entitlement.dart';

/// Reads `GET /me` (WARDROBE-91 / wardrobe-backend#46 `a837463`). Tests override.
abstract class EntitlementRepository {
  Future<Entitlement> fetchEntitlements();
}
