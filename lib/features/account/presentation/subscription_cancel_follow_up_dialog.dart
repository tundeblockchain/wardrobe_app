import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../application/account_controller.dart';
import '../application/account_state.dart';
import '../domain/account_subscription_copy.dart';

/// Retry / Continue when account wipe succeeded but store cancel did not.
class SubscriptionCancelFollowUpDialog extends ConsumerWidget {
  const SubscriptionCancelFollowUpDialog({super.key});

  static const dialogKey = Key('account_subscription_follow_up');
  static const retryButtonKey = Key('account_subscription_retry');
  static const continueButtonKey = Key('account_subscription_continue');
  static const messageKey = Key('account_subscription_follow_up_message');

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SubscriptionCancelFollowUpDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountControllerProvider);
    final info = account.subscriptionFollowUpInfo;
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final showRetry =
        account.subscriptionFollowUp ==
        AccountSubscriptionFollowUp.cancelFailed;
    final reduced = AppMotion.reduce(context);
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AccountSubscriptionCopy.followUpMessage(info), key: messageKey),
        const SizedBox(height: AppSpacing.md),
        Text(
          AccountSubscriptionCopy.storeManageHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (account.isBusy) ...[
          const SizedBox(height: AppSpacing.lg),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );

    return AlertDialog(
      key: dialogKey,
      title: Text(AccountSubscriptionCopy.followUpTitle(info)),
      content: reduced ? body : AppFadeIn(key: AppFadeIn.fadeKey, child: body),
      actions: [
        if (showRetry)
          TextButton(
            key: retryButtonKey,
            onPressed: account.isBusy ? null : () => _retry(context, ref),
            child: const Text(AccountSubscriptionCopy.retryLabel),
          ),
        FilledButton(
          key: continueButtonKey,
          style: FilledButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: account.isBusy ? null : () => _continue(context, ref),
          child: const Text(AccountSubscriptionCopy.continueLabel),
        ),
      ],
    );
  }

  Future<void> _retry(BuildContext context, WidgetRef ref) async {
    await ref
        .read(accountControllerProvider.notifier)
        .retrySubscriptionCancel();
    if (!context.mounted) {
      return;
    }
    final next = ref.read(accountControllerProvider);
    if (!next.needsSubscriptionFollowUp) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    await ref
        .read(accountControllerProvider.notifier)
        .acknowledgeOrphanedBilling();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
