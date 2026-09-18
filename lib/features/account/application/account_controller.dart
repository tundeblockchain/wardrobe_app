import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../../core/session/user_session_reset.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/auth_failure.dart';
import '../../entitlements/data/paywall_gateway_provider.dart';
import '../../entitlements/domain/paywall_gateway.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../data/dio_account_repository.dart';
import '../domain/account_repository.dart';
import '../domain/account_subscription_copy.dart';
import '../domain/account_wipe_summary.dart';
import '../domain/subscription_cancel_info.dart';
import 'account_state.dart';

/// Clear-all content and delete-account actions against `/me`.
class AccountController extends Notifier<AccountState> {
  @override
  AccountState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const AccountState();
  }

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  PaywallGateway get _paywall => ref.read(paywallGatewayProvider);

  /// Wipes wardrobes/items/outfits. Firebase session stays signed in.
  Future<AccountWipeSummary?> clearContent() async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      final summary = await _repository.clearContent();
      await _refreshLocalLists();
      if (!ref.mounted) {
        return summary;
      }
      state = state.copyWith(
        isBusy: false,
        lastSummary: summary,
        infoMessage: summary.feedbackMessage,
      );
      return summary;
    } on ApiException catch (error) {
      return _fail(error.message);
    } catch (_) {
      return _fail('Something went wrong. Please try again.');
    }
  }

  /// Client Superwall cancel, then `DELETE /me`, then Firebase Auth delete.
  ///
  /// Soft-fail: if store cancel fails, the wipe still counts, but the user
  /// must Retry or Continue before we treat delete as complete.
  Future<AccountWipeSummary?> deleteAccount() async {
    state = state.copyWith(
      isBusy: true,
      clearError: true,
      clearInfo: true,
      clearFollowUp: true,
    );
    final clientCancel = await _cancelClientSubscription();
    try {
      final summary = await _repository.deleteAccount();
      return _afterWipe(summary, clientCancel: clientCancel);
    } on ApiException catch (error) {
      return _fail(error.message);
    } catch (_) {
      return _fail('Something went wrong. Please try again.');
    }
  }

  /// Retry Superwall cancel after a soft-fail. Does not re-call `DELETE /me`.
  Future<AccountWipeSummary?> retrySubscriptionCancel() async {
    final summary = state.lastSummary;
    if (summary == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    final clientCancel = await _cancelClientSubscription();
    if (clientCancel.failed) {
      return _presentFollowUp(
        summary,
        AccountSubscriptionFollowUp.cancelFailed,
        clientCancel.info,
      );
    }
    return _completeDeletedAccount(summary);
  }

  /// User accepts orphaned-billing risk and finishes Firebase Auth delete.
  Future<AccountWipeSummary?> acknowledgeOrphanedBilling() async {
    final summary = state.lastSummary;
    if (summary == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, clearError: true, clearFollowUp: true);
    return _completeDeletedAccount(summary);
  }

  Future<AccountWipeSummary?> _afterWipe(
    AccountWipeSummary summary, {
    required _ClientCancelOutcome clientCancel,
  }) async {
    final followUp = resolveSubscriptionFollowUp(
      summary,
      clientCancelFailed: clientCancel.failed,
    );
    if (followUp != AccountSubscriptionFollowUp.none) {
      final info = clientCancel.failed && !summary.subscription.isFailed
          ? clientCancel.info
          : summary.subscription;
      return _presentFollowUp(summary, followUp, info);
    }
    return _completeDeletedAccount(summary);
  }

  Future<AccountWipeSummary?> _completeDeletedAccount(
    AccountWipeSummary summary,
  ) async {
    if (!summary.isAccountDeleted) {
      if (!ref.mounted) {
        return summary;
      }
      state = state.copyWith(
        isBusy: false,
        lastSummary: summary,
        clearFollowUp: true,
        errorMessage:
            'Your wardrobe data was deleted, but the sign-in account is '
            'still active. Sign in again and retry Delete account.',
      );
      return null;
    }
    try {
      await ref.read(authRepositoryProvider).deleteUser();
    } on AuthFailure catch (failure) {
      return _firebaseDeleteFailed(summary, failure);
    } catch (_) {
      return _firebaseDeleteFailed(summary, null);
    }
    if (!ref.mounted) {
      return summary;
    }
    state = state.copyWith(
      isBusy: false,
      isAccountDeleted: true,
      lastSummary: summary,
      clearFollowUp: true,
    );
    return summary;
  }

  Future<AccountWipeSummary?> _presentFollowUp(
    AccountWipeSummary summary,
    AccountSubscriptionFollowUp followUp,
    SubscriptionCancelInfo info,
  ) async {
    if (!ref.mounted) {
      return null;
    }
    state = state.copyWith(
      isBusy: false,
      lastSummary: summary,
      subscriptionFollowUp: followUp,
      subscriptionFollowUpInfo: info,
      errorMessage: AccountSubscriptionCopy.followUpMessage(info),
    );
    return null;
  }

  Future<_ClientCancelOutcome> _cancelClientSubscription() async {
    try {
      final result = await _paywall.cancelSubscription();
      if (result == CancelSubscriptionResult.failed) {
        return const _ClientCancelOutcome.failed();
      }
      return const _ClientCancelOutcome.ok();
    } catch (_) {
      return const _ClientCancelOutcome.failed();
    }
  }

  Future<void> _refreshLocalLists() async {
    invalidateUserScopedProviders(ref);
    await ref.read(wardrobesControllerProvider.notifier).refresh();
  }

  AccountWipeSummary? _fail(String message) {
    if (!ref.mounted) {
      return null;
    }
    state = state.copyWith(isBusy: false, errorMessage: message);
    return null;
  }

  AccountWipeSummary? _firebaseDeleteFailed(
    AccountWipeSummary summary,
    AuthFailure? failure,
  ) {
    if (!ref.mounted) {
      return null;
    }
    state = state.copyWith(
      isBusy: false,
      lastSummary: summary,
      errorMessage: _firebaseDeleteFailedMessage(failure),
    );
    return null;
  }

  String _firebaseDeleteFailedMessage(AuthFailure? failure) {
    final detail = failure?.message;
    if (detail != null && detail.isNotEmpty) {
      return 'Your wardrobe data was deleted, but the sign-in account '
          'could not be removed. $detail';
    }
    return 'Your wardrobe data was deleted, but the sign-in account '
        'could not be removed. Sign in again and retry Delete account.';
  }
}

class _ClientCancelOutcome {
  const _ClientCancelOutcome.ok() : failed = false;

  const _ClientCancelOutcome.failed() : failed = true;

  final bool failed;

  SubscriptionCancelInfo get info => failed
      ? const SubscriptionCancelInfo(
          status: SubscriptionCancelStatus.cancelFailed,
          retryInStore: true,
          message: AccountSubscriptionCopy.clientCancelFailedMessage,
        )
      : SubscriptionCancelInfo.absent;
}

/// Maps Backend subscription fields + client Superwall cancel onto follow-up.
AccountSubscriptionFollowUp resolveSubscriptionFollowUp(
  AccountWipeSummary summary, {
  required bool clientCancelFailed,
}) {
  final subscription = summary.subscription;
  if (subscription.isPeriodEnd && !subscription.isFailed) {
    return AccountSubscriptionFollowUp.cancelAtPeriodEnd;
  }
  if (subscription.isResolvedSuccess) {
    return AccountSubscriptionFollowUp.none;
  }
  if (subscription.isFailed || clientCancelFailed) {
    return AccountSubscriptionFollowUp.cancelFailed;
  }
  return AccountSubscriptionFollowUp.none;
}

final accountControllerProvider =
    NotifierProvider<AccountController, AccountState>(AccountController.new);
