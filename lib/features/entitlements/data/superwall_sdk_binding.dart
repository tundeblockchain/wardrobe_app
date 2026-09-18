import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import '../domain/paywall_gateway.dart';
import 'superwall_paywall_gateway.dart';

/// Binds the Superwall Flutter SDK to [SuperwallPaywallGateway] hooks.
///
/// Called once from `main` when a dart-defined API key is present.
void bindProductionSuperwallSdk() {
  bindSuperwallSdk(
    configure: ({required apiKey, required productIds}) async {
      final options = SuperwallOptions();
      options.logging.level = LogLevel.warn;
      Superwall.configure(apiKey, options: options);
      // Product IDs are operator-owned; pass them as Superwall user attributes
      // so dashboard paywalls can reference placeholder IDs before stores exist.
      await Superwall.shared.setUserAttributes(<String, Object>{
        'product_basic_monthly': productIds['basic_monthly'] ?? '',
        'product_basic_yearly': productIds['basic_yearly'] ?? '',
        'product_premium_monthly': productIds['premium_monthly'] ?? '',
        'product_premium_yearly': productIds['premium_yearly'] ?? '',
      });
    },
    identify: (userId) async {
      // Firebase UID only — Backend webhook maps originalAppUserId and
      // userAttributes.firebaseUid onto USER#{uid}. No Superwall aliases.
      await Superwall.shared.identify(userId);
      await Superwall.shared.setUserAttributes(<String, Object>{
        'firebaseUid': userId,
      });
    },
    reset: Superwall.shared.reset,
    registerPlacement: (placement, {params}) {
      return Superwall.shared.registerPlacement(placement, params: params);
    },
    restorePurchases: () async {
      final result = await Superwall.shared.restorePurchases();
      return result is RestorationResultRestored;
    },
    // Superwall Flutter has no store-cancel API. Backend DELETE /me
    // (WARDROBE-103) cancels/revokes; this hook stays skipped until the SDK
    // grows a cancel surface. Tests inject throws via [bindSuperwallSdk].
    cancelSubscription: () async => CancelSubscriptionResult.skipped,
  );
}
