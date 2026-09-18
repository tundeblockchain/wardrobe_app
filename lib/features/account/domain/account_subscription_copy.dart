import '../../../core/network/api_exception.dart';
import '../../entitlements/domain/subscription_tier.dart';
import 'account_delete_wire.dart';
import 'subscription_cancel_info.dart';

/// Product copy for delete-account Superwall / store cancel follow-up.
abstract final class AccountSubscriptionCopy {
  static const deleteConfirmMessage =
      'This permanently deletes every wardrobe, item, outfit, and photo, '
      'ends your subscription, then removes your sign-in. This cannot be '
      'undone.';

  static const cancelFailedTitle = 'Subscription may still be active';

  static const cancelFailedMessage =
      'Your Wardrobe account was deleted and paid features were revoked, '
      'but the store subscription could not be canceled. Open App Store or '
      'Google Play subscription settings to stop billing, or retry. '
      'Continuing leaves a risk of orphaned billing.';

  static const cancelAtPeriodEndTitle = 'Subscription ends with this period';

  static const cancelAtPeriodEndMessage =
      'Your Wardrobe account was deleted and Premium is already revoked. '
      'The store subscription is set to end when the current period '
      'finishes. Manage it in App Store or Google Play subscription '
      'settings if you need it to stop sooner.';

  static const clientCancelFailedMessage =
      'Your Wardrobe data was deleted, but the store subscription may still '
      'be billing. Open App Store or Google Play subscription settings to '
      'cancel, or retry.';

  static const wipeFailedMessage =
      'Account delete failed on the server. Retry now. Your sign-in is '
      'still active.';

  static const retryLabel = 'Retry';
  static const continueLabel = 'Continue';
  static const retryWipeLabel = 'Retry delete';

  static const storeManageHint =
      'Open App Store or Google Play subscription settings to cancel billing.';

  static String storeManageHintFor(SubscriptionCancelInfo info) {
    switch (info.store) {
      case EntitlementStore.appStore:
        return 'Open App Store subscription settings to cancel billing.';
      case EntitlementStore.playStore:
        return 'Open Google Play subscription settings to cancel billing.';
      case EntitlementStore.stripe:
      case EntitlementStore.unknown:
      case null:
        return storeManageHint;
    }
  }

  static String followUpMessage(SubscriptionCancelInfo info) {
    if (info.isPeriodEnd && !info.isFailed && !info.retryInStore) {
      return cancelAtPeriodEndMessage;
    }
    if (info.status == SubscriptionCancelStatus.unknown) {
      return clientCancelFailedMessage;
    }
    return cancelFailedMessage;
  }

  static String followUpTitle(SubscriptionCancelInfo info) {
    if (info.isPeriodEnd && !info.isFailed && !info.retryInStore) {
      return cancelAtPeriodEndTitle;
    }
    return cancelFailedTitle;
  }

  static bool isRetryableWipeFailure(ApiException error) {
    final code = error.code?.trim().toUpperCase();
    return code == AccountDeleteWire.internalError || error.statusCode == 500;
  }
}
