import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_entitlement_repository.dart';
import '../data/paywall_gateway_provider.dart';
import '../domain/entitlement.dart';
import '../domain/entitlement_repository.dart';
import '../domain/paywall_gateway.dart';
import '../domain/paywall_placement.dart';
import 'entitlements_state.dart';
import 'pending_paywall.dart';

/// Loads entitlements, restores purchases, and refreshes after session start.
class EntitlementsController extends Notifier<EntitlementsState> {
  bool _bootstrapped = false;

  @override
  EntitlementsState build() {
    ref.listen<SessionGate>(sessionGateProvider, (previous, next) {
      if (next.phase == SessionGatePhase.signedIn && next.uid != null) {
        unawaited(_onSignedIn(next.uid!));
      } else if (next.phase == SessionGatePhase.signedOut &&
          previous?.phase == SessionGatePhase.signedIn) {
        unawaited(_onSignedOut());
      }
    });
    ref.listen<int>(appLifecycleTickProvider, (previous, next) {
      if (previous != null && previous != next) {
        unawaited(refresh());
      }
    });
    Future<void>.microtask(_bootstrap);
    return const EntitlementsState(isLoading: true);
  }

  EntitlementRepository get _repository =>
      ref.read(entitlementRepositoryProvider);

  PaywallGateway get _paywall => ref.read(paywallGatewayProvider);

  Future<void> _bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;
    await _paywall.configure();
    if (!ref.mounted) {
      return;
    }
    final uid = ref.read(sessionGateProvider).uid;
    if (uid != null) {
      await _paywall.identify(uid);
    }
    if (!ref.mounted) {
      return;
    }
    await restorePurchases(silent: true);
    if (!ref.mounted) {
      return;
    }
    await refresh();
  }

  Future<void> _onSignedIn(String uid) async {
    await _paywall.identify(uid);
    if (!ref.mounted) {
      return;
    }
    await restorePurchases(silent: true);
    if (!ref.mounted) {
      return;
    }
    await refresh();
  }

  Future<void> _onSignedOut() async {
    await _paywall.reset();
    if (!ref.mounted) {
      return;
    }
    state = EntitlementsState(entitlement: Entitlement.free);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final entitlement = await _repository.fetchEntitlements();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, entitlement: entitlement);
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        entitlement: state.current,
        errorMessage: error.message,
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        entitlement: state.current,
        errorMessage: 'Could not refresh subscription status.',
      );
    }
  }

  Future<RestorePurchasesResult> restorePurchases({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(
        isRestoring: true,
        clearError: true,
        clearInfo: true,
      );
    }
    try {
      final result = await _paywall.restorePurchases();
      if (!ref.mounted) {
        return result;
      }
      await refresh();
      if (!ref.mounted) {
        return result;
      }
      if (!silent) {
        state = state.copyWith(
          isRestoring: false,
          infoMessage: result == RestorePurchasesResult.restored
              ? 'Purchases restored.'
              : result == RestorePurchasesResult.unavailable
              ? 'Restore is unavailable in this build.'
              : 'Could not restore purchases.',
          errorMessage: result == RestorePurchasesResult.failed
              ? 'Could not restore purchases.'
              : null,
          clearError: result != RestorePurchasesResult.failed,
          clearInfo: false,
        );
      } else {
        state = state.copyWith(isRestoring: false);
      }
      return result;
    } catch (_) {
      if (!ref.mounted) {
        return RestorePurchasesResult.failed;
      }
      if (!silent) {
        state = state.copyWith(
          isRestoring: false,
          errorMessage: 'Could not restore purchases.',
        );
      } else {
        state = state.copyWith(isRestoring: false);
      }
      return RestorePurchasesResult.failed;
    }
  }

  /// After a Superwall purchase, re-read `GET /me`.
  Future<void> onPurchaseCompleted() => refresh();
}

final entitlementsControllerProvider =
    NotifierProvider<EntitlementsController, EntitlementsState>(
      EntitlementsController.new,
    );

/// Queues a paywall from 403 API failures so the app binder can present it.
void queueEntitlementPaywall(
  Ref ref,
  ApiException error, {
  PaywallPlacement? fallback,
}) {
  final placement = PaywallPlacement.fromApiException(
    error,
    fallback: fallback,
  );
  if (placement != null) {
    ref.read(pendingPaywallProvider.notifier).queue(placement);
  }
}
