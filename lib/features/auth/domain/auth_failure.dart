/// Domain error raised by [AuthRepository] implementations.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.code});

  final String message;
  final String? code;

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
    default:
      return 'Authentication failed. Please try again.';
  }
}
