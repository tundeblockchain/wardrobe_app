import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../domain/paywall_gateway.dart';
import '../presentation/paywall_sheet.dart';
import 'superwall_paywall_gateway.dart';

/// Superwall when an API key is present; themed fallback otherwise.
final paywallGatewayProvider = Provider<PaywallGateway>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.hasSuperwallApiKey) {
    return const FallbackPaywallGateway();
  }
  return SuperwallPaywallGateway(config);
});
