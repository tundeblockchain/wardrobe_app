/// Locked WARDROBE-91 wire keys (wardrobe-backend#46, merged `a837463`).
///
/// Flutter reads `GET /me` only. Superwall webhook is Backend-side.
abstract final class EntitlementWire {
  static const mePath = '/me';

  static const userId = 'userId';
  static const tier = 'tier';
  static const status = 'status';
  static const features = 'features';
  static const limits = 'limits';
  static const usage = 'usage';
  static const productId = 'productId';
  static const store = 'store';
  static const period = 'period';
  static const expiresAt = 'expiresAt';
  static const updatedAt = 'updatedAt';

  static const unlimitedCatalog = 'unlimitedCatalog';
  static const aiTryOn = 'aiTryOn';
  static const otherAi = 'otherAi';

  static const wardrobes = 'wardrobes';
  static const items = 'items';
  static const outfits = 'outfits';

  static const free = 'FREE';
  static const basic = 'BASIC';
  static const premium = 'PREMIUM';

  static const statusNone = 'NONE';
  static const statusActive = 'ACTIVE';
  static const statusCanceled = 'CANCELED';
  static const statusBillingIssue = 'BILLING_ISSUE';
  static const statusPaused = 'PAUSED';
  static const statusExpired = 'EXPIRED';

  static const storeAppStore = 'APP_STORE';
  static const storePlayStore = 'PLAY_STORE';
  static const storeStripe = 'STRIPE';
  static const storeUnknown = 'UNKNOWN';

  static const periodMonthly = 'MONTHLY';
  static const periodYearly = 'YEARLY';
  static const periodUnknown = 'UNKNOWN';
}
