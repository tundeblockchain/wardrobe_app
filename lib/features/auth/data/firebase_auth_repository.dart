import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import 'apple_sign_in_client.dart';

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

/// Cryptographically random nonce for Sign in with Apple (replay protection).
String generateAppleRawNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}

/// SHA-256 hex digest of [input]. Apple receives this; Firebase checks the raw nonce.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// Firebase Auth implementation of [AuthRepository].
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    AppleSignInClient? appleSignIn,
    String Function()? appleRawNonceGenerator,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? defaultGoogleSignIn(),
       _appleSignIn = appleSignIn ?? const PluginAppleSignInClient(),
       _appleRawNonceGenerator =
           appleRawNonceGenerator ?? generateAppleRawNonce;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final AppleSignInClient _appleSignIn;
  final String Function() _appleRawNonceGenerator;

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
  Future<AppUser> signInWithApple() async {
    try {
      final rawNonce = _appleRawNonceGenerator();
      final apple = await _appleSignIn.getAppleIdCredential(
        nonce: sha256ofString(rawNonce),
      );
      final identityToken = apple.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw const AuthFailure(
          'Apple sign-in failed. Please try again.',
          code: 'missing-apple-token',
        );
      }

      final credential = OAuthProvider('apple.com').credential(
        idToken: identityToken,
        rawNonce: rawNonce,
        accessToken: apple.authorizationCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _requireUser(userCredential.user);
    } on AuthFailure {
      rethrow;
    } on SignInWithAppleAuthorizationException catch (error) {
      final cancelled = error.code == AuthorizationErrorCode.canceled;
      throw AuthFailure(
        messageForAppleSignInCode(error.code.name),
        code: cancelled ? AuthFailure.cancelledCode : error.code.name,
      );
    } on SignInWithAppleException {
      throw const AuthFailure(
        'Apple sign-in failed. Please try again.',
        code: 'apple-sign-in-failed',
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    } on PlatformException catch (error) {
      throw AuthFailure(
        messageForAppleSignInCode(error.code),
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

  @override
  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthFailure('No signed-in user to delete.');
    }
    try {
      await user.delete();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(
        messageForFirebaseAuthCode(error.code),
        code: error.code,
      );
    }
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Firebase user is already gone. Disconnect is only for the next picker.
    }
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
