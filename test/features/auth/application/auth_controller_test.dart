import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/router/auth_redirect.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';

import '../../../helpers/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() {
    repository.dispose();
    container.dispose();
  });

  test('starts unknown then becomes unauthenticated from the stream', () async {
    final first = container.read(authControllerProvider);
    expect(first.status, AuthStatus.unknown);

    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.unauthenticated,
    );
  });

  test('signIn updates status to authenticated', () async {
    await Future<void>.delayed(Duration.zero);
    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'user@example.com', password: 'secret1');

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, 'user@example.com');
    expect(state.isBusy, isFalse);
  });

  test('signIn records AuthFailure without authenticating', () async {
    await Future<void>.delayed(Duration.zero);
    repository.nextFailure = const AuthFailure('Invalid email or password.');

    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'user@example.com', password: 'nope');

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.errorMessage, 'Invalid email or password.');
    expect(state.user, isNull);
  });

  test('signOut returns to unauthenticated', () async {
    await Future<void>.delayed(Duration.zero);
    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'user@example.com', password: 'secret1');
    await container.read(authControllerProvider.notifier).signOut();

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.user, isNull);
  });

  test('signInWithGoogle updates status to authenticated', () async {
    await Future<void>.delayed(Duration.zero);
    await container.read(authControllerProvider.notifier).signInWithGoogle();

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, 'google.user@example.com');
    expect(state.isBusy, isFalse);
    expect(state.errorMessage, isNull);
  });

  test('signInWithGoogle cancel leaves the user unauthenticated', () async {
    await Future<void>.delayed(Duration.zero);
    repository.nextFailure = const AuthFailure(
      'Sign-in cancelled.',
      code: AuthFailure.cancelledCode,
    );

    await container.read(authControllerProvider.notifier).signInWithGoogle();

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.errorMessage, isNull);
    expect(state.user, isNull);
    expect(state.isBusy, isFalse);
  });

  test(
    'signInWithGoogle records account-exists without authenticating',
    () async {
      await Future<void>.delayed(Duration.zero);
      repository.nextFailure = const AuthFailure(
        'An account already exists for that email. Sign in with email and password.',
        code: 'account-exists-with-different-credential',
      );

      await container.read(authControllerProvider.notifier).signInWithGoogle();

      final state = container.read(authControllerProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.errorMessage, contains('already exists'));
      expect(state.user, isNull);
    },
  );

  test('signInWithApple updates status to authenticated', () async {
    await Future<void>.delayed(Duration.zero);
    await container.read(authControllerProvider.notifier).signInWithApple();

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, 'apple.user@example.com');
    expect(state.user?.providerId, 'apple.com');
    expect(state.isBusy, isFalse);
    expect(state.errorMessage, isNull);
  });

  test('signInWithApple cancel leaves the user unauthenticated', () async {
    await Future<void>.delayed(Duration.zero);
    repository.nextFailure = const AuthFailure(
      'Sign-in cancelled.',
      code: AuthFailure.cancelledCode,
    );

    await container.read(authControllerProvider.notifier).signInWithApple();

    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.unauthenticated);
    expect(state.errorMessage, isNull);
    expect(state.user, isNull);
    expect(state.isBusy, isFalse);
  });

  test(
    'signInWithApple records account-exists without authenticating',
    () async {
      await Future<void>.delayed(Duration.zero);
      repository.nextFailure = const AuthFailure(
        'An account already exists for that email. Sign in with email and password.',
        code: 'account-exists-with-different-credential',
      );

      await container.read(authControllerProvider.notifier).signInWithApple();

      final state = container.read(authControllerProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.errorMessage, contains('already exists'));
      expect(state.user, isNull);
    },
  );

  test('sendPasswordResetEmail sets info message', () async {
    await Future<void>.delayed(Duration.zero);
    await container
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(email: 'user@example.com');

    expect(
      container.read(authControllerProvider).infoMessage,
      'Password reset email sent.',
    );
  });
}
