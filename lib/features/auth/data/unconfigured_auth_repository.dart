import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';

/// Used when Firebase was not initialized (missing dart-defines / options).
///
/// Keeps CI and local unit tests running without secrets. Auth actions fail
/// with a clear configuration message.
class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  static const configMessage =
      'Firebase is not configured. Pass FIREBASE_* dart-defines '
      '(see docs/local-config.example.md).';

  @override
  Stream<AppUser?> authStateChanges() => Stream<AppUser?>.value(null);

  @override
  AppUser? get currentUser => null;

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    throw const AuthFailure(configMessage);
  }

  @override
  Future<AppUser> signUp({required String email, required String password}) {
    throw const AuthFailure(configMessage);
  }

  @override
  Future<AppUser> signInWithGoogle() {
    throw const AuthFailure(configMessage);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw const AuthFailure(configMessage);
  }

  @override
  Future<void> signOut() async {}
}
