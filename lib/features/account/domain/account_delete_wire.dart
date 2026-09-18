/// Locked `DELETE /me` fields (WARDROBE-103).
///
/// Production lock is wardrobe-backend#49 merge SHA `3f9b38a`, not the
/// pre-merge `e312d55` tip. `subscription` optionals are omitted when unset.
/// `DELETE /me/content` does not send this envelope.
abstract final class AccountDeleteWire {
  static const deleted = 'deleted';
  static const keepAccount = 'keepAccount';
  static const entitlementRevoked = 'entitlementRevoked';
  static const subscription = 'subscription';

  static const status = 'status';
  static const cancelMode = 'cancelMode';
  static const store = 'store';
  static const expiresAt = 'expiresAt';
  static const retryInStore = 'retryInStore';

  static const statusNone = 'NONE';
  static const statusCanceled = 'CANCELED';
  static const statusCancelAtPeriodEnd = 'CANCEL_AT_PERIOD_END';
  static const statusCancelFailed = 'CANCEL_FAILED';

  static const cancelModeImmediate = 'IMMEDIATE';
  static const cancelModePeriodEnd = 'PERIOD_END';

  static const unauthenticated = 'UNAUTHENTICATED';
  static const internalError = 'INTERNAL_ERROR';
  static const invalidResponse = 'INVALID_RESPONSE';
}
