/// Locked `DELETE /me` fields (WARDROBE-103, wardrobe-backend#49 `3f9b38a`).
///
/// Soft-omit unset optionals so a pre-103 wipe body still parses.
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

  static const internalError = 'INTERNAL_ERROR';
}
