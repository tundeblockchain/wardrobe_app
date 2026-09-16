import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/entitlements_controller.dart';
import '../application/pending_paywall.dart';
import '../data/paywall_gateway_provider.dart';
import '../domain/paywall_placement.dart';

/// Presents Superwall when a mutation returns a Backend 403 entitlement
/// error. Sits under [MaterialApp] so a navigator overlay is available.
class EntitlementPaywallBinder extends ConsumerWidget {
  const EntitlementPaywallBinder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(entitlementsControllerProvider);
    ref.listen(pendingPaywallProvider, (previous, next) {
      if (next == null || !context.mounted) {
        return;
      }
      ref.read(pendingPaywallProvider.notifier).clear();
      unawaited(_present(context, ref, next));
    });
    return child;
  }

  Future<void> _present(
    BuildContext context,
    WidgetRef ref,
    PaywallPlacement placement,
  ) async {
    await ref
        .read(paywallGatewayProvider)
        .present(placement: placement, context: context);
    if (!context.mounted) {
      return;
    }
    await ref.read(entitlementsControllerProvider.notifier).refresh();
  }
}
