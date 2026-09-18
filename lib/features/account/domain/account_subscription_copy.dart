import 'subscription_cancel_info.dart';

/// Product copy for delete-account Superwall / store cancel follow-up.
abstract final class AccountSubscriptionCopy {
  static const deleteConfirmMessage =
      'This permanently deletes every wardrobe, item, outfit, and photo, '
      'ends your subscription, then removes your sign-in. This cannot be '
      'undone.';

  static const cancelFailedTitle = 'Subscription may still be active';

  static const cancelFailedMessage =
      'Your Wardrobe data was deleted, but the store subscription could not '
      'be canceled. Retry now, or continue and cancel it in App Store or '
      'Google Play. Continuing leaves a risk of orphaned billing.';

  static const cancelAtPeriodEndTitle = 'Subscription ends with this period';

  static const cancelAtPeriodEndMessage =
      'Your Wardrobe data was deleted. The store subscription is set to end '
      'when the current period finishes. Manage it in App Store or Google '
      'Play if you need it to stop sooner.';

  static const clientCancelFailedMessage =
      'Your Wardrobe data was deleted, but Superwall could not end the '
      'store subscription. Retry now, or continue and cancel it in App Store '
      'or Google Play. Continuing leaves a risk of orphaned billing.';

  static const retryLabel = 'Retry';
  static const continueLabel = 'Continue';
  static const manageInStoreLabel = 'Manage in store';

  static const storeManageHint =
      'Open App Store or Google Play → Subscriptions to cancel billing.';

  static String followUpMessage(SubscriptionCancelInfo info) {
    final fromBackend = info.message;
    if (fromBackend != null && fromBackend.isNotEmpty) {
      return fromBackend;
    }
    if (info.isPeriodEnd) {
      return cancelAtPeriodEndMessage;
    }
    return cancelFailedMessage;
  }

  static String followUpTitle(SubscriptionCancelInfo info) {
    if (info.isPeriodEnd && !info.isFailed) {
      return cancelAtPeriodEndTitle;
    }
    return cancelFailedTitle;
  }
}
