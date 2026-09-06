import '../domain/account_wipe_summary.dart';

/// Immutable account-screen state owned by [AccountController].
class AccountState {
  const AccountState({
    this.isBusy = false,
    this.isAccountDeleted = false,
    this.lastSummary,
    this.errorMessage,
    this.infoMessage,
  });

  final bool isBusy;
  final bool isAccountDeleted;
  final AccountWipeSummary? lastSummary;
  final String? errorMessage;
  final String? infoMessage;

  AccountState copyWith({
    bool? isBusy,
    bool? isAccountDeleted,
    AccountWipeSummary? lastSummary,
    bool clearSummary = false,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
  }) {
    return AccountState(
      isBusy: isBusy ?? this.isBusy,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
      lastSummary: clearSummary ? null : (lastSummary ?? this.lastSummary),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
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
            infoMessage == other.infoMessage;
  }

  @override
  int get hashCode => Object.hash(
    isBusy,
    isAccountDeleted,
    lastSummary,
    errorMessage,
    infoMessage,
  );
}
