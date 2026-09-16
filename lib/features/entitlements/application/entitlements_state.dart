import '../domain/entitlement.dart';

/// Immutable entitlement snapshot owned by [EntitlementsController].
class EntitlementsState {
  const EntitlementsState({
    this.entitlement,
    this.isLoading = false,
    this.isRestoring = false,
    this.errorMessage,
    this.infoMessage,
  });

  /// Defaults to Free catalog when null (pre-refresh).
  final Entitlement? entitlement;

  Entitlement get current => entitlement ?? Entitlement.free;

  final bool isLoading;
  final bool isRestoring;
  final String? errorMessage;
  final String? infoMessage;

  EntitlementsState copyWith({
    Entitlement? entitlement,
    bool? isLoading,
    bool? isRestoring,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
  }) {
    return EntitlementsState(
      entitlement: entitlement ?? this.entitlement,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EntitlementsState &&
            entitlement == other.entitlement &&
            isLoading == other.isLoading &&
            isRestoring == other.isRestoring &&
            errorMessage == other.errorMessage &&
            infoMessage == other.infoMessage;
  }

  @override
  int get hashCode => Object.hash(
    entitlement,
    isLoading,
    isRestoring,
    errorMessage,
    infoMessage,
  );
}
