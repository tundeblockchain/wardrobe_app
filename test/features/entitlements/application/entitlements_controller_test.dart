import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/lifecycle/app_lifecycle.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/session/session_gate.dart';
import 'package:wardrobe_app/features/entitlements/application/entitlements_controller.dart';
import 'package:wardrobe_app/features/entitlements/application/pending_paywall.dart';
import 'package:wardrobe_app/features/entitlements/data/dio_entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/data/paywall_gateway_provider.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';

import '../../../helpers/fake_entitlements.dart';

void main() {
  late FakeEntitlementRepository repository;
  late FakePaywallGateway paywall;
  late ProviderContainer container;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    repository = FakeEntitlementRepository(seed: Entitlement.free);
    paywall = FakePaywallGateway();
    container = ProviderContainer.test(
      overrides: [
        entitlementRepositoryProvider.overrideWithValue(repository),
        paywallGatewayProvider.overrideWithValue(paywall),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'bootstrap configures Superwall, restores, and loads entitlements',
    () async {
      container.read(entitlementsControllerProvider);
      await settle();
      await settle();

      expect(paywall.configureCount, 1);
      expect(paywall.restoreCount, 1);
      expect(repository.fetchCount, greaterThanOrEqualTo(1));
      expect(
        container.read(entitlementsControllerProvider).current.tier,
        SubscriptionTier.free,
      );
    },
  );

  test('refresh after purchase picks up Backend Premium', () async {
    container.read(entitlementsControllerProvider);
    await settle();
    repository.current = Entitlement.premium;

    await container.read(entitlementsControllerProvider.notifier).refresh();

    expect(
      container.read(entitlementsControllerProvider).current,
      Entitlement.premium,
    );
  });

  test('restore purchases records a restore and refreshes', () async {
    container.read(entitlementsControllerProvider);
    await settle();
    repository.current = Entitlement.basic;

    final result = await container
        .read(entitlementsControllerProvider.notifier)
        .restorePurchases();

    expect(result, RestorePurchasesResult.restored);
    expect(paywall.restoreCount, greaterThanOrEqualTo(2));
    expect(
      container.read(entitlementsControllerProvider).current.tier,
      SubscriptionTier.basic,
    );
    expect(
      container.read(entitlementsControllerProvider).infoMessage,
      'Purchases restored.',
    );
  });

  test(
    'session start identifies the user and session end resets Superwall',
    () async {
      container.read(entitlementsControllerProvider);
      await settle();

      container.read(sessionGateProvider.notifier).markSignedIn('uid-42');
      await settle();
      expect(paywall.identified, contains('uid-42'));

      container.read(sessionGateProvider.notifier).markSignedOut();
      await settle();
      expect(paywall.resetCount, 1);
      expect(
        container.read(entitlementsControllerProvider).current,
        Entitlement.free,
      );
    },
  );

  test('app resume refreshes entitlements', () async {
    container.read(entitlementsControllerProvider);
    await settle();
    final before = repository.fetchCount;
    container.read(appLifecycleTickProvider.notifier).bump();
    await settle();
    expect(repository.fetchCount, greaterThan(before));
  });

  test('onPurchaseCompleted re-reads GET /me', () async {
    container.read(entitlementsControllerProvider);
    await settle();
    final before = repository.fetchCount;
    repository.current = Entitlement.premium;

    await container
        .read(entitlementsControllerProvider.notifier)
        .onPurchaseCompleted();

    expect(repository.fetchCount, greaterThan(before));
    expect(
      container.read(entitlementsControllerProvider).current.tier,
      SubscriptionTier.premium,
    );
  });

  test('403 codes can be queued as a pending Superwall placement', () {
    final placement = PaywallPlacement.fromApiException(
      const ApiException(
        message: 'Item limit',
        code: 'ENTITLEMENT_ITEM_LIMIT',
        statusCode: 403,
      ),
      fallback: PaywallPlacement.itemLimit,
    );
    container.read(pendingPaywallProvider.notifier).queue(placement!);

    expect(container.read(pendingPaywallProvider), PaywallPlacement.itemLimit);
  });

  test('unknown ENTITLEMENT_* queues a generic Basic upgrade', () {
    const error = ApiException(
      message: 'raw backend code',
      code: 'ENTITLEMENT_SOMETHING_NEW',
      statusCode: 403,
    );
    final message = container.read(
      Provider<String>((ref) => queueEntitlementPaywall(ref, error)),
    );

    expect(
      container.read(pendingPaywallProvider),
      PaywallPlacement.upgradeBasic,
    );
    expect(message, PaywallPlacement.upgradeBasic.message);
    expect(message, isNot(contains('raw backend')));
  });

  test('presentPaywall wires restore through the controller', () async {
    container.read(entitlementsControllerProvider);
    await settle();
    await settle();

    await container
        .read(entitlementsControllerProvider.notifier)
        .presentPaywall(placement: PaywallPlacement.itemLimit);

    expect(paywall.presented, contains(PaywallPlacement.itemLimit));
    expect(paywall.lastOnRestore, isNotNull);

    repository.current = Entitlement.basic;
    final result = await paywall.lastOnRestore!();
    expect(result, RestorePurchasesResult.restored);
    expect(
      container.read(entitlementsControllerProvider).current.tier,
      SubscriptionTier.basic,
    );
  });
}
