/// Provisional `DELETE /me` subscription fields (WARDROBE-102 / WARDROBE-103).
///
/// Soft-stub until Backend posts the locked DTO + error codes. Missing keys
/// must not fail parse. Prefer [subscription] (WARDROBE-103); also accept
/// [subscriptionCancel] / [subscriptionCancelFailed] from the Flutter sketch.
abstract final class AccountDeleteWire {
  static const deleted = 'deleted';
  static const entitlementRevoked = 'entitlementRevoked';
  static const subscription = 'subscription';
  static const subscriptionCancel = 'subscriptionCancel';
  static const subscriptionCancelFailed = 'subscriptionCancelFailed';
  static const code = 'code';
  static const message = 'message';

  static const status = 'status';
  static const cancelMode = 'cancelMode';
  static const store = 'store';
  static const expiresAt = 'expiresAt';
  static const retryInStore = 'retryInStore';

  static const statusNone = 'NONE';
  static const statusCanceled = 'CANCELED';
  static const statusCancelAtPeriodEnd = 'CANCEL_AT_PERIOD_END';
  static const statusCancelFailed = 'CANCEL_FAILED';
  static const statusSucceeded = 'SUCCEEDED';
  static const statusSkipped = 'SKIPPED';
  static const statusFailed = 'FAILED';

  static const subscriptionCancelFailedCode = 'SUBSCRIPTION_CANCEL_FAILED';
}
