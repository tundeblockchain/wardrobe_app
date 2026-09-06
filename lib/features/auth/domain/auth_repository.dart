import 'app_user.dart';

/// Auth contract used by controllers. Implementations talk to Firebase.
abstract interface class AuthRepository {
  /// Emits the current user, then subsequent sign-in / sign-out changes.
  Stream<AppUser?> authStateChanges();

  /// Synchronous snapshot. May be `null` while restoring or signed out.
  AppUser? get currentUser;

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({required String email, required String password});

  /// Google / Gmail sign-in. Returns the same [AppUser] session as email/password.
  Future<AppUser> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  /// Deletes the Firebase Auth user after `DELETE /me`. Disconnects Google.
  Future<void> deleteUser();
}
