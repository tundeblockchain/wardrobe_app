import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';

/// Optional Web OAuth client ID (Firebase Google provider) for Android ID tokens.
const String kGoogleServerClientIdDefine = String.fromEnvironment(
  'GOOGLE_SERVER_CLIENT_ID',
);

GoogleSignIn defaultGoogleSignIn() {
  return GoogleSignIn(
    scopes: const ['email', 'profile'],
    serverClientId: kGoogleServerClientIdDefine.isEmpty
        ? null
        : kGoogleServerClientIdDefine,
  );
}

/// Firebase Auth implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? defaultGoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  AppUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(credential.user);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(credential.user);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure(
          'Sign-in cancelled.',
          code: AuthFailure.cancelledCode,
        );
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw const AuthFailure(
          'Google sign-in failed. Please try again.',
          code: 'missing-google-tokens',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _requireUser(userCredential.user);
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    } on PlatformException catch (error) {
      throw AuthFailure(
        messageForGoogleSignInCode(error.code),
        code: error.code,
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Disconnect so the next Google sign-in shows the account picker.
      await _googleSignIn.disconnect();
    } catch (_) {
      // Email/password sessions (or already-disconnected Google) are fine.
    }
    await _auth.signOut();
  }

  AppUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) {
      throw const AuthFailure('Authentication failed. Please try again.');
    }
    return mapped;
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    final providers = user.providerData;
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      providerId: providers.isEmpty ? null : providers.first.providerId,
    );
  }
}
