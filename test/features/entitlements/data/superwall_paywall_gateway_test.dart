import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/config/app_config.dart';
import 'package:wardrobe_app/features/entitlements/data/superwall_paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_paywall_copy.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/entitlements/presentation/paywall_sheet.dart';

void main() {
  late Future<CancelSubscriptionResult> Function() previousCancel;
  late Future<void> Function({
    required String apiKey,
    required Map<String, String> productIds,
  })
  previousConfigure;
  late Future<void> Function(String placement, {Map<String, Object>? params})
  previousRegister;

  setUp(() {
    previousCancel = cancelSuperwallSubscription;
    previousConfigure = configureSuperwallSdk;
    previousRegister = registerSuperwallPlacement;
  });

  tearDown(() {
    cancelSuperwallSubscription = previousCancel;
    configureSuperwallSdk = previousConfigure;
    registerSuperwallPlacement = previousRegister;
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

  test(
    'configured Superwall present passes upgrade and restore copy',
    () async {
      Map<String, Object>? captured;
      configureSuperwallSdk = ({required apiKey, required productIds}) async {};
      registerSuperwallPlacement = (placement, {params}) async {
        captured = params;
      };
      final gateway = SuperwallPaywallGateway(
        const AppConfig(
          apiBaseUrl: 'https://api.example.com',
          superwallApiKey: 'pk_public_test',
        ),
      );
      await gateway.configure();

      await gateway.present(placement: PaywallPlacement.wardrobeLimit);

      expect(captured, isNotNull);
      expect(captured!['upgrade_cta'], EntitlementPaywallCopy.upgradeBasicCta);
      expect(captured!['see_plans_cta'], EntitlementPaywallCopy.seePlansCta);
      expect(captured!['restore_cta'], EntitlementPaywallCopy.restoreCta);
      expect(captured!['headline'], PaywallPlacement.wardrobeLimit.headline);
    },
  );

  test('unconfigured Superwall restore is a clear unavailable stub', () async {
    final gateway = SuperwallPaywallGateway(
      const AppConfig(apiBaseUrl: 'https://api.example.com'),
    );
    expect(
      await gateway.restorePurchases(),
      RestorePurchasesResult.unavailable,
    );
    expect(
      await const FallbackPaywallGateway().restorePurchases(),
      RestorePurchasesResult.unavailable,
    );
  });
}
