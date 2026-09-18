import '../domain/account_wipe_summary.dart';
import '../domain/subscription_cancel_info.dart';

/// Follow-up after a successful wipe when store cancel is incomplete.
enum AccountSubscriptionFollowUp { none, cancelFailed, cancelAtPeriodEnd }

/// Immutable account-screen state owned by [AccountController].
class AccountState {
  const AccountState({
    this.isBusy = false,
    this.isAccountDeleted = false,
    this.lastSummary,
    this.errorMessage,
    this.infoMessage,
    this.subscriptionFollowUp = AccountSubscriptionFollowUp.none,
    this.subscriptionFollowUpInfo = SubscriptionCancelInfo.absent,
    this.canRetryWipe = false,
  });

  final bool isBusy;
  final bool isAccountDeleted;
  final AccountWipeSummary? lastSummary;
  final String? errorMessage;
  final String? infoMessage;
  final AccountSubscriptionFollowUp subscriptionFollowUp;
  final SubscriptionCancelInfo subscriptionFollowUpInfo;

  /// `500 INTERNAL_ERROR` after `DELETE /me` — retry the wipe, not Firebase.
  final bool canRetryWipe;

  bool get needsSubscriptionFollowUp =>
      subscriptionFollowUp != AccountSubscriptionFollowUp.none;

  AccountState copyWith({
    bool? isBusy,
    bool? isAccountDeleted,
    AccountWipeSummary? lastSummary,
    bool clearSummary = false,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
    AccountSubscriptionFollowUp? subscriptionFollowUp,
    SubscriptionCancelInfo? subscriptionFollowUpInfo,
    bool clearFollowUp = false,
    bool? canRetryWipe,
  }) {
    return AccountState(
      isBusy: isBusy ?? this.isBusy,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
      lastSummary: clearSummary ? null : (lastSummary ?? this.lastSummary),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
      subscriptionFollowUp: clearFollowUp
          ? AccountSubscriptionFollowUp.none
          : (subscriptionFollowUp ?? this.subscriptionFollowUp),
      subscriptionFollowUpInfo: clearFollowUp
          ? SubscriptionCancelInfo.absent
          : (subscriptionFollowUpInfo ?? this.subscriptionFollowUpInfo),
      canRetryWipe: clearError ? false : (canRetryWipe ?? this.canRetryWipe),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AccountState &&
            isBusy == other.isBusy &&
            isAccountDeleted == other.isAccountDeleted &&
            lastSummary == other.lastSummary &&
            errorMessage == other.errorMessage &&
            infoMessage == other.infoMessage &&
            subscriptionFollowUp == other.subscriptionFollowUp &&
            subscriptionFollowUpInfo == other.subscriptionFollowUpInfo &&
            canRetryWipe == other.canRetryWipe;
  }

  @override
  int get hashCode => Object.hash(
    isBusy,
    isAccountDeleted,
    lastSummary,
    errorMessage,
    infoMessage,
    subscriptionFollowUp,
    subscriptionFollowUpInfo,
    canRetryWipe,
  );
}
