/// Domain error raised by [AuthRepository] implementations.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.code});

  /// User dismissed the Google account picker (not an error to display).
  static const cancelledCode = 'cancelled';

  final String message;
  final String? code;

  bool get isCancelled =>
      code == cancelledCode ||
      code == 'sign_in_canceled' ||
      code == 'sign_in_cancelled';

  @override
  String toString() => 'AuthFailure($code, $message)';
}

/// Maps Firebase Auth error codes to user-facing copy.
String messageForFirebaseAuthCode(String code) {
  switch (code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Invalid email or password.';
    case 'email-already-in-use':
      return 'An account already exists for that email.';
    case 'account-exists-with-different-credential':
      return 'An account already exists for that email. '
          'Sign in with email and password.';
    case 'invalid-email':
      return 'Enter a valid email address.';
    case 'weak-password':
      return 'Password is too weak.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    case AuthFailure.cancelledCode:
    case 'sign_in_canceled':
    case 'sign_in_cancelled':
      return 'Sign-in cancelled.';
    default:
      return 'Authentication failed. Please try again.';
  }
}

/// Maps Google Sign-In / platform error codes to user-facing copy.
String messageForGoogleSignInCode(String code) {
  switch (code) {
    case AuthFailure.cancelledCode:
    case 'sign_in_canceled':
    case 'sign_in_cancelled':
      return 'Sign-in cancelled.';
    case 'network_error':
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    case 'sign_in_failed':
    case 'sign_in_required':
      return 'Google sign-in failed. Please try again.';
    default:
      return 'Google sign-in failed. Please try again.';
  }
}
