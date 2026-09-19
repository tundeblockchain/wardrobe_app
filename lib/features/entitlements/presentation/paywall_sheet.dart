import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../../core/widgets/app_gloss.dart';
import '../domain/entitlement_paywall_copy.dart';
import '../domain/paywall_gateway.dart';
import '../domain/paywall_placement.dart';
import '../domain/subscription_catalog.dart';
import '../domain/subscription_tier.dart';

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
    Future<RestorePurchasesResult> Function()? onRestore,
  }) async {
    if (context == null || !context.mounted) {
      return const PaywallPresentation(shown: false);
    }
    await PaywallSheet.show(
      context,
      placement: placement,
      onRestore: onRestore ?? restorePurchases,
    );
    return const PaywallPresentation();
  }

  @override
  Future<RestorePurchasesResult> restorePurchases() async {
    return RestorePurchasesResult.unavailable;
  }

  @override
  Future<CancelSubscriptionResult> cancelSubscription() async {
    return CancelSubscriptionResult.skipped;
  }
}

/// Local paywall sheet used when Superwall keys are unset (CI, tests, stubs).
class PaywallSheet extends StatefulWidget {
  const PaywallSheet({super.key, required this.placement, this.onRestore});

  static const sheetKey = Key('paywall_sheet');
  static const restoreButtonKey = Key('paywall_restore');
  static const dismissButtonKey = Key('paywall_dismiss');
  static const upgradeButtonKey = Key('paywall_upgrade');
  static const seePlansButtonKey = Key('paywall_see_plans');
  static const plansSectionKey = Key('paywall_plans');
  static const restoreHintKey = Key('paywall_restore_hint');

  final PaywallPlacement placement;
  final Future<RestorePurchasesResult> Function()? onRestore;

  static Future<void> show(
    BuildContext context, {
    required PaywallPlacement placement,
    Future<RestorePurchasesResult> Function()? onRestore,
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
  State<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<PaywallSheet> {
  bool _showPlans = false;
  bool _restoring = false;
  String? _restoreMessage;

  EntitlementPaywallCopy get _copy =>
      EntitlementPaywallCopy.forPlacement(widget.placement);

  Future<void> _restore() async {
    setState(() {
      _restoring = true;
      _restoreMessage = null;
    });
    final result = await widget.onRestore?.call();
    if (!mounted) {
      return;
    }
    if (result == RestorePurchasesResult.restored) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _restoring = false;
      _restoreMessage = switch (result) {
        RestorePurchasesResult.unavailable =>
          EntitlementPaywallCopy.restoreUnavailable,
        RestorePurchasesResult.failed => EntitlementPaywallCopy.restoreFailed,
        RestorePurchasesResult.restored => null,
        null => EntitlementPaywallCopy.restoreUnavailable,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduced = AppMotion.reduce(context);
    final copy = _copy;
    final body = Padding(
      padding: AppSpacing.pageInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(copy.headline, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            copy.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            EntitlementPaywallCopy.restoreHint,
            key: PaywallSheet.restoreHintKey,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_showPlans)
            _PlansSection(highlighted: copy.targetTier)
          else
            _PlanCard(
              tier: copy.targetTier,
              highlighted: true,
              price: SubscriptionCatalog.priceSummary(copy.targetTier),
            ),
          if (_restoreMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _restoreMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: PaywallSheet.upgradeButtonKey,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(copy.upgradeCta),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            key: PaywallSheet.seePlansButtonKey,
            onPressed: () {
              setState(() => _showPlans = !_showPlans);
            },
            child: Text(
              _showPlans
                  ? EntitlementPaywallCopy.hidePlansCta
                  : EntitlementPaywallCopy.seePlansCta,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            key: PaywallSheet.restoreButtonKey,
            onPressed: _restoring ? null : _restore,
            child: _restoring
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(EntitlementPaywallCopy.restoreCta),
          ),
          TextButton(
            key: PaywallSheet.dismissButtonKey,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(EntitlementPaywallCopy.dismissCta),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );

    return KeyedSubtree(
      key: PaywallSheet.sheetKey,
      child: SafeArea(
        child: reduced
            ? SingleChildScrollView(child: body)
            : AppFadeIn(child: SingleChildScrollView(child: body)),
      ),
    );
  }
}

class _PlansSection extends StatelessWidget {
  const _PlansSection({required this.highlighted});

  final SubscriptionTier highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: PaywallSheet.plansSectionKey,
      children: [
        for (final tier in SubscriptionTier.values) ...[
          if (tier != SubscriptionTier.values.first)
            const SizedBox(height: AppSpacing.sm),
          _PlanCard(
            tier: tier,
            highlighted: tier == highlighted,
            price: SubscriptionCatalog.priceSummary(tier),
          ),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.tier,
    required this.price,
    this.highlighted = false,
  });

  final SubscriptionTier tier;
  final String price;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      color: highlighted ? scheme.primaryContainer : null,
      child: AppGloss(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: highlighted
                ? scheme.primary
                : scheme.primaryContainer,
            child: Icon(
              Icons.workspace_premium_outlined,
              color: highlighted ? scheme.onPrimary : scheme.onPrimaryContainer,
            ),
          ),
          title: Text(tier.label),
          subtitle: Text(
            '$price · ${EntitlementPaywallCopy.planSummary(tier)}',
          ),
        ),
      ),
    );
  }
}
