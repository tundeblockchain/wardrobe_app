import 'package:flutter/widgets.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement.dart';
import 'package:wardrobe_app/features/entitlements/domain/entitlement_repository.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_placement.dart';

/// In-memory Superwall stand-in for tests. Never talks to the native SDK.
class FakePaywallGateway implements PaywallGateway {
  FakePaywallGateway();

  final presented = <PaywallPlacement>[];
  final identified = <String>[];
  int configureCount = 0;
  int resetCount = 0;
  int restoreCount = 0;
  RestorePurchasesResult restoreResult = RestorePurchasesResult.restored;

  @override
  Future<void> configure() async {
    configureCount++;
  }

  @override
  Future<void> identify(String userId) async {
    identified.add(userId);
  }

  @override
  Future<void> reset() async {
    resetCount++;
  }

  @override
  Future<PaywallPresentation> present({
    required PaywallPlacement placement,
    BuildContext? context,
  }) async {
    presented.add(placement);
    return const PaywallPresentation();
  }

  @override
  Future<RestorePurchasesResult> restorePurchases() async {
    restoreCount++;
    return restoreResult;
  }
}

/// Mutable entitlement source for controller and widget tests.
class FakeEntitlementRepository implements EntitlementRepository {
  FakeEntitlementRepository({Entitlement? seed})
    : current = seed ?? Entitlement.free;

  Entitlement current;
  int fetchCount = 0;
  Object? error;

  @override
  Future<Entitlement> fetchEntitlements() async {
    fetchCount++;
    final thrown = error;
    if (thrown != null) {
      if (thrown is ApiException) {
        throw thrown;
      }
      throw thrown;
    }
    return current;
  }
}
