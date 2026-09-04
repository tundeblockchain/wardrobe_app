import 'app_user.dart';

/// Auth contract used by controllers. Implementations talk to Firebase.
abstract interface class AuthRepository {
  /// Emits the current user, then subsequent sign-in / sign-out changes.
  Stream<AppUser?> authStateChanges();

  /// Synchronous snapshot. May be `null` while restoring or signed out.
  AppUser? get currentUser;

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({required String email, required String password});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}
