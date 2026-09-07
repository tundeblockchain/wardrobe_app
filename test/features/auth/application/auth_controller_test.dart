import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/router/auth_redirect.dart';
import 'package:wardrobe_app/core/session/session_gate.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';
import 'package:wardrobe_app/features/items/application/item_local_preview_cache.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late FakeWardrobeRepository wardrobes;
  late InMemorySessionLocalStore store;
  late RecordingSessionImageCache images;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAuthRepository();
    wardrobes = FakeWardrobeRepository(seed: [testWardrobe()]);
    store = InMemorySessionLocalStore(
      preferences: {'lastUser': 'alice'},
      secureStorage: {'tokenHint': 'alice-token'},
    );
    images = RecordingSessionImageCache();
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
        sessionLocalStoreProvider.overrideWithValue(store),
        sessionImageCacheProvider.overrideWithValue(images),
      ],
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

  test(
    'signOut clears lists, preview cache, disk hooks, and image cache',
    () async {
      await Future<void>.delayed(Duration.zero);
      await container
          .read(authControllerProvider.notifier)
          .signIn(email: 'alice@example.com', password: 'secret1');

      container.read(wardrobesControllerProvider);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(wardrobesControllerProvider).wardrobes,
        hasLength(1),
      );

      container
          .read(itemLocalPreviewCacheProvider.notifier)
          .store('item_alice', Uint8List.fromList(const [9, 8, 7]));

      await container.read(authControllerProvider.notifier).signOut();

      expect(
        container.read(authControllerProvider).status,
        AuthStatus.unauthenticated,
      );
      expect(
        container.read(sessionGateProvider).phase,
        SessionGatePhase.signedOut,
      );
      expect(container.read(sessionGateProvider).allowUserDataFetch, isFalse);
      expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
      expect(container.read(itemLocalPreviewCacheProvider), isEmpty);
      expect(store.clearCount, greaterThanOrEqualTo(1));
      expect(store.preferences, isEmpty);
      expect(store.secureStorage, isEmpty);
      expect(images.clearCount, greaterThanOrEqualTo(1));
    },
  );

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
