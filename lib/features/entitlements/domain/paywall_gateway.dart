import 'package:flutter/widgets.dart';

import 'paywall_placement.dart';

/// Result of presenting a Superwall (or themed fallback) paywall.
class PaywallPresentation {
  const PaywallPresentation({this.shown = true});

  final bool shown;
}

/// Store restore outcome. Superwall owns the native restore; Backend then
/// refreshes entitlements.
enum RestorePurchasesResult { restored, failed, unavailable }

/// Client Superwall cancel during account delete (WARDROBE-102).
///
/// The Flutter SDK has no store-cancel API today, so production returns
/// [skipped] and Backend `DELETE /me` is the source of truth. Tests and a
/// future SDK hook can return [canceled] / [failed].
enum CancelSubscriptionResult { canceled, skipped, failed, unavailable }

/// Paywall + restore surface. Superwall implements this; tests fake it.
abstract class PaywallGateway {
  Future<void> configure();

  Future<void> identify(String userId);

  Future<void> reset();

  Future<PaywallPresentation> present({
    required PaywallPlacement placement,
    BuildContext? context,
    Future<RestorePurchasesResult> Function()? onRestore,
  });

  Future<RestorePurchasesResult> restorePurchases();

  /// Best-effort client cancel before / with Backend account delete.
  Future<CancelSubscriptionResult> cancelSubscription();
}
