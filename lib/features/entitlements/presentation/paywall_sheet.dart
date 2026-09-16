import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../../core/widgets/app_gloss.dart';
import '../domain/paywall_gateway.dart';
import '../domain/paywall_placement.dart';
import '../domain/subscription_catalog.dart';

/// Themed burgundy/plum fallback when Superwall is not configured.
class FallbackPaywallGateway implements PaywallGateway {
  const FallbackPaywallGateway();

  @override
  Future<void> configure() async {}

  @override
  Future<void> identify(String userId) async {}

  @override
  Future<void> reset() async {}

  @override
  Future<PaywallPresentation> present({
    required PaywallPlacement placement,
    BuildContext? context,
  }) async {
    if (context == null || !context.mounted) {
      return const PaywallPresentation(shown: false);
    }
    await PaywallSheet.show(context, placement: placement);
    return const PaywallPresentation();
  }

  @override
  Future<RestorePurchasesResult> restorePurchases() async {
    return RestorePurchasesResult.unavailable;
  }
}

/// Local paywall sheet used when Superwall keys are unset (CI, tests, stubs).
class PaywallSheet extends StatelessWidget {
  const PaywallSheet({super.key, required this.placement, this.onRestore});

  static const sheetKey = Key('paywall_sheet');
  static const restoreButtonKey = Key('paywall_restore');
  static const dismissButtonKey = Key('paywall_dismiss');
  static const upgradeButtonKey = Key('paywall_upgrade');

  final PaywallPlacement placement;
  final Future<void> Function()? onRestore;

  static Future<void> show(
    BuildContext context, {
    required PaywallPlacement placement,
    Future<void> Function()? onRestore,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return PaywallSheet(placement: placement, onRestore: onRestore);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduced = AppMotion.reduce(context);
    final body = Padding(
      padding: AppSpacing.pageInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(placement.headline, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            placement.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _PriceCard(
            title: placement.targetTier.label,
            price: SubscriptionCatalog.priceSummary(placement.targetTier),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: upgradeButtonKey,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue with ${placement.targetTier.label}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            key: restoreButtonKey,
            onPressed: () async {
              await onRestore?.call();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Restore purchases'),
          ),
          TextButton(
            key: dismissButtonKey,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not now'),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );

    return KeyedSubtree(
      key: sheetKey,
      child: SafeArea(child: reduced ? body : AppFadeIn(child: body)),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: AppGloss(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.workspace_premium_outlined,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(title),
          subtitle: Text(price),
        ),
      ),
    );
  }
}
