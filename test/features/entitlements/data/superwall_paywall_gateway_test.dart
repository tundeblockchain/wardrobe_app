import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/config/app_config.dart';
import 'package:wardrobe_app/features/entitlements/data/superwall_paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/presentation/paywall_sheet.dart';

void main() {
  late Future<CancelSubscriptionResult> Function() previousCancel;
  late Future<void> Function({
    required String apiKey,
    required Map<String, String> productIds,
  })
  previousConfigure;

  setUp(() {
    previousCancel = cancelSuperwallSubscription;
    previousConfigure = configureSuperwallSdk;
  });

  tearDown(() {
    cancelSuperwallSubscription = previousCancel;
    configureSuperwallSdk = previousConfigure;
  });

  test('unconfigured Superwall cancel is skipped', () async {
    final gateway = SuperwallPaywallGateway(
      const AppConfig(apiBaseUrl: 'https://api.example.com'),
    );

    expect(
      await gateway.cancelSubscription(),
      CancelSubscriptionResult.skipped,
    );
  });

  test('configured Superwall cancel uses the bound hook', () async {
    cancelSuperwallSubscription = () async => CancelSubscriptionResult.canceled;
    configureSuperwallSdk = ({required apiKey, required productIds}) async {};
    final gateway = SuperwallPaywallGateway(
      const AppConfig(
        apiBaseUrl: 'https://api.example.com',
        superwallApiKey: 'pk_public_test',
      ),
    );
    await gateway.configure();

    expect(
      await gateway.cancelSubscription(),
      CancelSubscriptionResult.canceled,
    );
  });

  test('configured Superwall cancel throws through to the caller', () async {
    cancelSuperwallSubscription = () async {
      throw StateError('store cancel unavailable');
    };
    configureSuperwallSdk = ({required apiKey, required productIds}) async {};
    final gateway = SuperwallPaywallGateway(
      const AppConfig(
        apiBaseUrl: 'https://api.example.com',
        superwallApiKey: 'pk_public_test',
      ),
    );
    await gateway.configure();

    await expectLater(gateway.cancelSubscription(), throwsStateError);
  });

  test('fallback paywall cancel is skipped', () async {
    expect(
      await const FallbackPaywallGateway().cancelSubscription(),
      CancelSubscriptionResult.skipped,
    );
  });
}
