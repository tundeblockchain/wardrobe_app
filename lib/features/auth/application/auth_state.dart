import '../../../core/router/auth_redirect.dart';
import '../domain/app_user.dart';

/// Immutable auth UI + session state owned by [AuthController].
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isBusy = false,
    this.infoMessage,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final String? infoMessage;
  final bool isBusy;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
    bool? isBusy,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthState &&
            status == other.status &&
            user == other.user &&
            errorMessage == other.errorMessage &&
            infoMessage == other.infoMessage &&
            isBusy == other.isBusy;
  }

  @override
  int get hashCode =>
      Object.hash(status, user, errorMessage, infoMessage, isBusy);
}
