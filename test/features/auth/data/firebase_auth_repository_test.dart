import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wardrobe_app/features/auth/data/apple_sign_in_client.dart';
import 'package:wardrobe_app/features/auth/data/firebase_auth_repository.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAppleSignInClient extends Mock implements AppleSignInClient {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockUserInfo extends Mock implements UserInfo {}

class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockAppleSignInClient appleSignIn;
  late FirebaseAuthRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    appleSignIn = MockAppleSignInClient();
    repository = FirebaseAuthRepository(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
      appleSignIn: appleSignIn,
      appleRawNonceGenerator: () => 'raw-nonce',
    );
  });

  MockUserCredential stubSignedInUser({
    String uid = 'uid-google',
    String email = 'user@gmail.com',
    String? displayName = 'Ada Lovelace',
    String providerId = 'google.com',
  }) {
    final user = MockUser();
    when(() => user.uid).thenReturn(uid);
    when(() => user.email).thenReturn(email);
    when(() => user.displayName).thenReturn(displayName);
    final info = MockUserInfo();
    when(() => info.providerId).thenReturn(providerId);
    when(() => user.providerData).thenReturn([info]);
    final credential = MockUserCredential();
    when(() => credential.user).thenReturn(user);
    when(() => firebaseAuth.signInWithCredential(any()))
        .thenAnswer((_) async => credential);
    return credential;
  }

  void stubAppleTokens({
    String? identityToken = 'apple-id-token',
    String authorizationCode = 'apple-auth-code',
  }) {
    when(() => appleSignIn.getAppleIdCredential(nonce: any(named: 'nonce')))
        .thenAnswer(
          (_) async => AppleIdTokens(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
          ),
        );
  }

  Future<void> stubGoogleAccount({
    String? idToken = 'id-token',
    String? accessToken = 'access-token',
  }) async {
    final account = MockGoogleSignInAccount();
    final auth = MockGoogleSignInAuthentication();
    when(() => auth.idToken).thenReturn(idToken);
    when(() => auth.accessToken).thenReturn(accessToken);
    when(() => account.authentication).thenAnswer((_) async => auth);
    when(() => googleSignIn.signIn()).thenAnswer((_) async => account);
  }

  test('signInWithGoogle maps Google tokens to an AppUser session', () async {
    await stubGoogleAccount();
    stubSignedInUser();

    final user = await repository.signInWithGoogle();

    expect(user.uid, 'uid-google');
    expect(user.email, 'user@gmail.com');
    expect(user.displayName, 'Ada Lovelace');
    expect(user.providerId, 'google.com');
    expect(user.providerLabel, 'Google');
    verify(() => googleSignIn.signIn()).called(1);
    verify(() => firebaseAuth.signInWithCredential(any())).called(1);
  });

  test('signInWithGoogle treats a null account as cancelled', () async {
    when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

    expect(
      () => repository.signInWithGoogle(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.isCancelled,
          'isCancelled',
          isTrue,
        ),
      ),
    );
    verifyNever(() => firebaseAuth.signInWithCredential(any()));
  });

  test(
    'signInWithGoogle maps account-exists-with-different-credential',
    () async {
      await stubGoogleAccount();
      when(() => firebaseAuth.signInWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'account-exists-with-different-credential'),
      );

      expect(
        () => repository.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>()
              .having(
                (failure) => failure.code,
                'code',
                'account-exists-with-different-credential',
              )
              .having(
                (failure) => failure.message,
                'message',
                contains('already exists'),
              ),
        ),
      );
    },
  );

  test(
    'signInWithGoogle maps platform cancel without hitting Firebase',
    () async {
      when(() => googleSignIn.signIn()).thenThrow(
        PlatformException(code: 'sign_in_canceled', message: 'cancelled'),
      );

      expect(
        () => repository.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.isCancelled,
            'isCancelled',
            isTrue,
          ),
        ),
      );
      verifyNever(() => firebaseAuth.signInWithCredential(any()));
    },
  );

  test('signInWithGoogle maps other platform errors', () async {
    when(() => googleSignIn.signIn())
        .thenThrow(PlatformException(code: 'network_error'));

    expect(
      () => repository.signInWithGoogle(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.message,
          'message',
          'Network error. Check your connection.',
        ),
      ),
    );
  });

  test('signInWithGoogle fails when Google returns no tokens', () async {
    await stubGoogleAccount(idToken: null, accessToken: null);

    expect(
      () => repository.signInWithGoogle(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.code,
          'code',
          'missing-google-tokens',
        ),
      ),
    );
    verifyNever(() => firebaseAuth.signInWithCredential(any()));
  });

  test('signOut disconnects Google then signs out of Firebase', () async {
    when(() => googleSignIn.disconnect()).thenAnswer((_) async => null);
    when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

    await repository.signOut();

    verifyInOrder([
      () => googleSignIn.disconnect(),
      () => firebaseAuth.signOut(),
    ]);
  });

  test(
    'signOut still signs out of Firebase if Google disconnect fails',
    () async {
      when(() => googleSignIn.disconnect())
          .thenThrow(Exception('no google session'));
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => firebaseAuth.signOut()).called(1);
    },
  );

  test('deleteUser deletes Firebase then disconnects Google', () async {
    final user = MockUser();
    when(() => user.delete()).thenAnswer((_) async {});
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => googleSignIn.disconnect()).thenAnswer((_) async => null);

    await repository.deleteUser();

    verifyInOrder([() => user.delete(), () => googleSignIn.disconnect()]);
  });

  test('deleteUser maps requires-recent-login and skips disconnect', () async {
    final user = MockUser();
    when(() => user.delete())
        .thenThrow(FirebaseAuthException(code: 'requires-recent-login'));
    when(() => firebaseAuth.currentUser).thenReturn(user);

    expect(
      () => repository.deleteUser(),
      throwsA(
        isA<AuthFailure>()
            .having((failure) => failure.code, 'code', 'requires-recent-login')
            .having(
              (failure) => failure.message,
              'message',
              'Sign in again to delete your account.',
            ),
      ),
    );
    verifyNever(() => googleSignIn.disconnect());
  });

  test('deleteUser still succeeds if Google disconnect fails', () async {
    final user = MockUser();
    when(() => user.delete()).thenAnswer((_) async {});
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => googleSignIn.disconnect()).thenThrow(Exception('no google'));

    await repository.deleteUser();

    verify(() => user.delete()).called(1);
  });

  test('deleteUser fails when there is no current user', () async {
    when(() => firebaseAuth.currentUser).thenReturn(null);

    expect(
      () => repository.deleteUser(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.message,
          'message',
          'No signed-in user to delete.',
        ),
      ),
    );
  });

  test('email signIn is unchanged', () async {
    final user = MockUser();
    when(() => user.uid).thenReturn('uid-email');
    when(() => user.email).thenReturn('user@example.com');
    when(() => user.displayName).thenReturn(null);
    final info = MockUserInfo();
    when(() => info.providerId).thenReturn('password');
    when(() => user.providerData).thenReturn([info]);
    final credential = MockUserCredential();
    when(() => credential.user).thenReturn(user);
    when(
      () => firebaseAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => credential);

    final session = await repository.signIn(
      email: ' user@example.com ',
      password: 'secret1',
    );

    expect(session.email, 'user@example.com');
    expect(session.providerId, 'password');
    expect(session.providerLabel, 'Email');
    verifyNever(() => googleSignIn.signIn());
    verifyNever(
      () => appleSignIn.getAppleIdCredential(nonce: any(named: 'nonce')),
    );
  });

  test('signInWithApple maps Apple tokens to an AppUser session', () async {
    stubAppleTokens();
    stubSignedInUser(
      uid: 'uid-apple',
      email: 'hidden@privaterelay.appleid.com',
      displayName: 'Ada',
      providerId: 'apple.com',
    );

    final user = await repository.signInWithApple();

    expect(user.uid, 'uid-apple');
    expect(user.email, 'hidden@privaterelay.appleid.com');
    expect(user.displayName, 'Ada');
    expect(user.providerId, 'apple.com');
    expect(user.providerLabel, 'Apple');
    verify(
      () =>
          appleSignIn.getAppleIdCredential(nonce: sha256ofString('raw-nonce')),
    ).called(1);
    verify(() => firebaseAuth.signInWithCredential(any())).called(1);
    verifyNever(() => googleSignIn.signIn());
  });

  test('signInWithApple treats a cancelled sheet as cancelled', () async {
    when(() => appleSignIn.getAppleIdCredential(nonce: any(named: 'nonce')))
        .thenThrow(
          const SignInWithAppleAuthorizationException(
            code: AuthorizationErrorCode.canceled,
            message: 'The user canceled',
          ),
        );

    expect(
      () => repository.signInWithApple(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.isCancelled,
          'isCancelled',
          isTrue,
        ),
      ),
    );
    verifyNever(() => firebaseAuth.signInWithCredential(any()));
  });

  test(
    'signInWithApple maps account-exists-with-different-credential',
    () async {
      stubAppleTokens();
      when(() => firebaseAuth.signInWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'account-exists-with-different-credential'),
      );

      expect(
        () => repository.signInWithApple(),
        throwsA(
          isA<AuthFailure>()
              .having(
                (failure) => failure.code,
                'code',
                'account-exists-with-different-credential',
              )
              .having(
                (failure) => failure.message,
                'message',
                contains('already exists'),
              ),
        ),
      );
    },
  );

  test('signInWithApple maps other Apple authorization errors', () async {
    when(() => appleSignIn.getAppleIdCredential(nonce: any(named: 'nonce')))
        .thenThrow(
          const SignInWithAppleAuthorizationException(
            code: AuthorizationErrorCode.failed,
            message: 'failed',
          ),
        );

    expect(
      () => repository.signInWithApple(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.message,
          'message',
          'Apple sign-in failed. Please try again.',
        ),
      ),
    );
  });

  test('signInWithApple fails when Apple returns no identity token', () async {
    stubAppleTokens(identityToken: null);

    expect(
      () => repository.signInWithApple(),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.code,
          'code',
          'missing-apple-token',
        ),
      ),
    );
    verifyNever(() => firebaseAuth.signInWithCredential(any()));
  });
}
