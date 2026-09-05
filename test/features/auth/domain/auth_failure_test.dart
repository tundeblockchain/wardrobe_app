import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';

void main() {
  test('isCancelled covers picker dismiss codes', () {
    expect(
      const AuthFailure('x', code: AuthFailure.cancelledCode).isCancelled,
      isTrue,
    );
    expect(
      const AuthFailure('x', code: 'sign_in_canceled').isCancelled,
      isTrue,
    );
    expect(
      const AuthFailure('x', code: 'sign_in_cancelled').isCancelled,
      isTrue,
    );
    expect(
      const AuthFailure('x', code: 'invalid-credential').isCancelled,
      isFalse,
    );
  });

  test('messageForFirebaseAuthCode maps account-exists and cancel', () {
    expect(
      messageForFirebaseAuthCode('account-exists-with-different-credential'),
      'An account already exists for that email. Sign in with email and password.',
    );
    expect(
      messageForFirebaseAuthCode('invalid-credential'),
      'Invalid email or password.',
    );
    expect(
      messageForFirebaseAuthCode(AuthFailure.cancelledCode),
      'Sign-in cancelled.',
    );
  });

  test('messageForGoogleSignInCode maps platform errors', () {
    expect(
      messageForGoogleSignInCode('sign_in_canceled'),
      'Sign-in cancelled.',
    );
    expect(
      messageForGoogleSignInCode('network_error'),
      'Network error. Check your connection.',
    );
    expect(
      messageForGoogleSignInCode('sign_in_failed'),
      'Google sign-in failed. Please try again.',
    );
  });
}
