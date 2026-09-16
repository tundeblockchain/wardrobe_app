import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/paywall_placement.dart';

/// One-shot Superwall request from a Backend 402/403 entitlement error.
class PendingPaywall extends Notifier<PaywallPlacement?> {
  @override
  PaywallPlacement? build() => null;

  void queue(PaywallPlacement placement) => state = placement;

  void clear() => state = null;
}

final pendingPaywallProvider =
    NotifierProvider<PendingPaywall, PaywallPlacement?>(PendingPaywall.new);
