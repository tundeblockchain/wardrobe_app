import 'package:flutter/widgets.dart';

import '../../../core/config/app_config.dart';
import '../domain/paywall_gateway.dart';
import '../domain/paywall_placement.dart';
import '../presentation/paywall_sheet.dart';

/// Superwall SDK adapter. Falls back to the themed sheet if the SDK is
/// missing, misconfigured, or throws (no secrets are embedded here).
class SuperwallPaywallGateway implements PaywallGateway {
  SuperwallPaywallGateway(this._config);

  final AppConfig _config;
  bool _configured = false;

  @override
  Future<void> configure() async {
    final key = _config.resolvedSuperwallApiKey;
    if (key.isEmpty) {
      return;
    }
    try {
      await configureSuperwallSdk(
        apiKey: key,
        productIds: {
          'basic_monthly': _config.productIds.basicMonthly,
          'basic_yearly': _config.productIds.basicYearly,
          'premium_monthly': _config.productIds.premiumMonthly,
          'premium_yearly': _config.productIds.premiumYearly,
        },
      );
      _configured = true;
    } catch (_) {
      _configured = false;
    }
  }

  @override
  Future<void> identify(String userId) async {
    if (!_configured) {
      return;
    }
    try {
      await identifySuperwallUser(userId);
    } catch (_) {
      // Identity is best-effort; entitlements still refresh from Backend.
    }
  }

  @override
  Future<void> reset() async {
    if (!_configured) {
      return;
    }
    try {
      await resetSuperwallUser();
    } catch (_) {
      // Sign-out should still proceed.
    }
  }

  @override
  Future<PaywallPresentation> present({
    required PaywallPlacement placement,
    BuildContext? context,
  }) async {
    if (_configured) {
      try {
        await registerSuperwallPlacement(
          placement.id,
          params: {
            'target_tier': placement.targetTier.wireValue,
            'reason': placement.id,
            'product_basic_monthly': _config.productIds.basicMonthly,
            'product_basic_yearly': _config.productIds.basicYearly,
            'product_premium_monthly': _config.productIds.premiumMonthly,
            'product_premium_yearly': _config.productIds.premiumYearly,
          },
        );
        return const PaywallPresentation();
      } catch (_) {
        // Fall through to the themed sheet.
      }
    }
    if (context == null || !context.mounted) {
      return const PaywallPresentation(shown: false);
    }
    return const FallbackPaywallGateway().present(
      placement: placement,
      context: context,
    );
  }

  @override
  Future<RestorePurchasesResult> restorePurchases() async {
    if (!_configured) {
      return RestorePurchasesResult.unavailable;
    }
    try {
      final restored = await restoreSuperwallPurchases();
      return restored
          ? RestorePurchasesResult.restored
          : RestorePurchasesResult.failed;
    } catch (_) {
      return RestorePurchasesResult.failed;
    }
  }
}

/// SDK hooks isolated so unit tests never need the native plugin.
///
/// Production assigns these from [bindSuperwallSdk]. Tests can replace them.
Future<void> Function({
  required String apiKey,
  required Map<String, String> productIds,
})
configureSuperwallSdk = _unimplementedConfigure;

Future<void> Function(String userId) identifySuperwallUser = (_) async {};

Future<void> Function() resetSuperwallUser = () async {};

Future<void> Function(String placement, {Map<String, Object>? params})
registerSuperwallPlacement = (_, {params}) async {};

Future<bool> Function() restoreSuperwallPurchases = () async => false;

Future<void> _unimplementedConfigure({
  required String apiKey,
  required Map<String, String> productIds,
}) async {
  throw StateError('Superwall SDK is not bound.');
}

/// Wires [superwallkit_flutter] without leaking the package into tests.
void bindSuperwallSdk({
  required Future<void> Function({
    required String apiKey,
    required Map<String, String> productIds,
  })
  configure,
  required Future<void> Function(String userId) identify,
  required Future<void> Function() reset,
  required Future<void> Function(
    String placement, {
    Map<String, Object>? params,
  })
  registerPlacement,
  required Future<bool> Function() restorePurchases,
}) {
  configureSuperwallSdk = configure;
  identifySuperwallUser = identify;
  resetSuperwallUser = reset;
  registerSuperwallPlacement = registerPlacement;
  restoreSuperwallPurchases = restorePurchases;
}
