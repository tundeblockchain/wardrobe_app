import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/auth_redirect.dart';
import '../../../core/session/session_gate.dart';
import '../../../core/session/user_session_reset.dart';
import '../data/firebase_auth_repository.dart';
import '../data/unconfigured_auth_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import 'auth_state.dart';

/// Resolves the repository implementation. Override in tests with a fake.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (Firebase.apps.isEmpty) {
    return const UnconfiguredAuthRepository();
  }
  return FirebaseAuthRepository();
});

/// Session + form actions. Status is driven by [AuthRepository.authStateChanges].
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final repository = ref.watch(authRepositoryProvider);
    final subscription = repository.authStateChanges().listen(
      (user) {
        final leavingAccount =
            state.user != null && state.user?.uid != user?.uid;
        state = state.copyWith(
          status: user == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          user: user,
          clearUser: user == null,
          isBusy: false,
        );
        if (user != null) {
          ref.read(sessionGateProvider.notifier).markSignedIn(user.uid);
        } else if (leavingAccount) {
          unawaited(_clearLocalSession());
        }
      },
      onError: (Object _, StackTrace _) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          isBusy: false,
          errorMessage: 'Unable to restore session.',
        );
      },
    );
    ref.onDispose(subscription.cancel);

    final current = repository.currentUser;
    if (current != null) {
      return AuthState(status: AuthStatus.authenticated, user: current);
    }
    return const AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> signIn({required String email, required String password}) async {
    await _authenticate(
      () => _repository.signIn(email: email, password: password),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    await _authenticate(
      () => _repository.signUp(email: email, password: password),
    );
  }

  Future<void> signInWithGoogle() async {
    await _authenticate(_repository.signInWithGoogle);
  }

  Future<void> signInWithApple() async {
    await _authenticate(_repository.signInWithApple);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      await _repository.sendPasswordResetEmail(email: email);
      state = state.copyWith(
        isBusy: false,
        infoMessage: 'Password reset email sent.',
      );
    } on AuthFailure catch (failure) {
      state = state.copyWith(isBusy: false, errorMessage: failure.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      await _repository.signOut();
      await _clearLocalSession();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isBusy: false,
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
    } on AuthFailure catch (failure) {
      state = state.copyWith(isBusy: false, errorMessage: failure.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Wipes Riverpod lists, image cache, and any prefs / secure-storage hook.
  Future<void> _clearLocalSession() async {
    ref.read(sessionGateProvider.notifier).markSignedOut();
    await ref.read(userSessionResetProvider).clear();
  }

  Future<void> _authenticate(Future<AppUser> Function() action) async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      final user = await action();
      ref.read(sessionGateProvider.notifier).markSignedIn(user.uid);
      state = state.copyWith(
        isBusy: false,
        status: AuthStatus.authenticated,
        user: user,
      );
    } on AuthFailure catch (failure) {
      if (failure.isCancelled) {
        state = state.copyWith(isBusy: false);
        return;
      }
      state = state.copyWith(isBusy: false, errorMessage: failure.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
