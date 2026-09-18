import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/account/application/account_controller.dart';
import 'package:wardrobe_app/features/account/application/account_state.dart';
import 'package:wardrobe_app/features/account/data/dio_account_repository.dart';
import 'package:wardrobe_app/features/account/domain/account_wipe_summary.dart';
import 'package:wardrobe_app/features/account/domain/subscription_cancel_info.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';
import 'package:wardrobe_app/features/entitlements/data/paywall_gateway_provider.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/fake_account_repository.dart';
import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_entitlements.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

const _deletedSummary = AccountWipeSummary(
  keepAccount: false,
  deletedWardrobes: 1,
  deletedItems: 2,
  deletedOutfits: 1,
  deletedS3Objects: 3,
  s3Failures: 0,
  deleted: true,
  entitlementRevoked: true,
);

void main() {
  late FakeAccountRepository accountRepository;
  late FakeAuthRepository authRepository;
  late FakeWardrobeRepository wardrobeRepository;
  late FakePaywallGateway paywall;
  late ProviderContainer container;

  setUp(() {
    accountRepository = FakeAccountRepository();
    authRepository = FakeAuthRepository(
      initialUser: const AppUser(uid: 'uid-1', email: 'user@example.com'),
    );
    wardrobeRepository = FakeWardrobeRepository(seed: [testWardrobe()]);
    paywall = FakePaywallGateway();
    container = ProviderContainer.test(
      overrides: [
        accountRepositoryProvider.overrideWithValue(accountRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        wardrobeRepositoryProvider.overrideWithValue(wardrobeRepository),
        paywallGatewayProvider.overrideWithValue(paywall),
      ],
    );
  });

  tearDown(() {
    authRepository.dispose();
    container.dispose();
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test(
    'clearContent wipes via API, refreshes lists, keeps the session',
    () async {
      container.read(wardrobesControllerProvider);
      await settle();
      expect(
        container.read(wardrobesControllerProvider).wardrobes,
        hasLength(1),
      );

      wardrobeRepository.items.clear();
      final summary = await container
          .read(accountControllerProvider.notifier)
          .clearContent();

      expect(summary?.keepAccount, isTrue);
      expect(accountRepository.clearCalls, 1);
      expect(accountRepository.deleteCalls, 0);
      expect(authRepository.deleteUserCalls, 0);
      expect(paywall.cancelCount, 0);
      expect(wardrobeRepository.listCalls, greaterThanOrEqualTo(2));
      expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
      expect(
        container.read(accountControllerProvider).infoMessage,
        contains('wardrobe'),
      );
      expect(
        container.read(authControllerProvider).user?.email,
        'user@example.com',
      );
    },
  );

  test('clearContent surfaces API errors without clearing lists', () async {
    container.read(wardrobesControllerProvider);
    await settle();
    accountRepository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    final summary = await container
        .read(accountControllerProvider.notifier)
        .clearContent();

    expect(summary, isNull);
    expect(
      container.read(accountControllerProvider).errorMessage,
      contains('connection'),
    );
    expect(container.read(wardrobesControllerProvider).wardrobes, hasLength(1));
    expect(authRepository.deleteUserCalls, 0);
  });

  test(
    'deleteAccount cancels Superwall, calls DELETE /me, then Firebase',
    () async {
      accountRepository.deleteResult = _deletedSummary.withCanceled();
      paywall.cancelResult = CancelSubscriptionResult.canceled;

      final summary = await container
          .read(accountControllerProvider.notifier)
          .deleteAccount();

      expect(summary?.keepAccount, isFalse);
      expect(paywall.cancelCount, 1);
      expect(accountRepository.deleteCalls, 1);
      expect(authRepository.deleteUserCalls, 1);
      expect(
        container.read(accountControllerProvider).isAccountDeleted,
        isTrue,
      );
      expect(
        container.read(accountControllerProvider).needsSubscriptionFollowUp,
        isFalse,
      );
      await settle();
      expect(container.read(authControllerProvider).user, isNull);
    },
  );

  test('deleteAccount stops when DELETE /me fails', () async {
    accountRepository.nextFailure = const ApiException(
      message: 'Missing token.',
      code: 'UNAUTHENTICATED',
    );

    final summary = await container
        .read(accountControllerProvider.notifier)
        .deleteAccount();

    expect(summary, isNull);
    expect(paywall.cancelCount, 1);
    expect(authRepository.deleteUserCalls, 0);
    expect(container.read(accountControllerProvider).isAccountDeleted, isFalse);
    expect(
      container.read(accountControllerProvider).errorMessage,
      'Missing token.',
    );
    expect(
      container.read(authControllerProvider).user?.email,
      'user@example.com',
    );
  });

  test(
    'deleteAccount surfaces Firebase failure after a successful wipe',
    () async {
      authRepository.nextFailure = const AuthFailure(
        'Sign in again to delete your account.',
        code: 'requires-recent-login',
      );

      final summary = await container
          .read(accountControllerProvider.notifier)
          .deleteAccount();

      expect(summary, isNull);
      expect(accountRepository.deleteCalls, 1);
      expect(authRepository.deleteUserCalls, 0);
      expect(
        container.read(accountControllerProvider).isAccountDeleted,
        isFalse,
      );
      expect(
        container.read(accountControllerProvider).errorMessage,
        contains('could not be removed'),
      );
      expect(
        container.read(accountControllerProvider).errorMessage,
        contains('Sign in again'),
      );
      expect(
        container.read(authControllerProvider).user?.email,
        'user@example.com',
      );
    },
  );

  test('deleteAccount soft-fails when Backend reports CANCEL_FAILED', () async {
    accountRepository.deleteResult = _deletedSummary.withSubscription(
      const SubscriptionCancelInfo(
        status: SubscriptionCancelStatus.cancelFailed,
        retryInStore: true,
        code: 'SUBSCRIPTION_CANCEL_FAILED',
        message: 'Store cancel timed out.',
      ),
    );

    final summary = await container
        .read(accountControllerProvider.notifier)
        .deleteAccount();

    expect(summary, isNull);
    expect(accountRepository.deleteCalls, 1);
    expect(authRepository.deleteUserCalls, 0);
    expect(container.read(accountControllerProvider).isAccountDeleted, isFalse);
    expect(
      container.read(accountControllerProvider).subscriptionFollowUp,
      AccountSubscriptionFollowUp.cancelFailed,
    );
    expect(
      container.read(accountControllerProvider).errorMessage,
      'Store cancel timed out.',
    );
    expect(
      container.read(authControllerProvider).user?.email,
      'user@example.com',
    );
  });

  test('retrySubscriptionCancel then completes Firebase delete', () async {
    paywall.cancelError = StateError('store cancel');
    accountRepository.deleteResult = _deletedSummary;

    await container.read(accountControllerProvider.notifier).deleteAccount();
    expect(authRepository.deleteUserCalls, 0);
    expect(
      container.read(accountControllerProvider).subscriptionFollowUp,
      AccountSubscriptionFollowUp.cancelFailed,
    );

    paywall.cancelResult = CancelSubscriptionResult.canceled;
    final summary = await container
        .read(accountControllerProvider.notifier)
        .retrySubscriptionCancel();

    expect(summary?.isAccountDeleted, isTrue);
    expect(paywall.cancelCount, 2);
    expect(accountRepository.deleteCalls, 1);
    expect(authRepository.deleteUserCalls, 1);
    expect(container.read(accountControllerProvider).isAccountDeleted, isTrue);
    expect(
      container.read(accountControllerProvider).needsSubscriptionFollowUp,
      isFalse,
    );
  });

  test(
    'acknowledgeOrphanedBilling completes Firebase delete after cancel fail',
    () async {
      accountRepository.deleteResult = _deletedSummary.withSubscription(
        const SubscriptionCancelInfo(
          status: SubscriptionCancelStatus.cancelFailed,
          retryInStore: true,
        ),
      );

      await container.read(accountControllerProvider.notifier).deleteAccount();
      final summary = await container
          .read(accountControllerProvider.notifier)
          .acknowledgeOrphanedBilling();

      expect(summary?.isAccountDeleted, isTrue);
      expect(authRepository.deleteUserCalls, 1);
      expect(
        container.read(accountControllerProvider).isAccountDeleted,
        isTrue,
      );
    },
  );

  test('CANCEL_AT_PERIOD_END waits for Continue before Firebase delete', () {
    expect(
      resolveSubscriptionFollowUp(
        _deletedSummary.withSubscription(
          const SubscriptionCancelInfo(
            status: SubscriptionCancelStatus.cancelAtPeriodEnd,
            retryInStore: true,
          ),
        ),
        clientCancelFailed: false,
      ),
      AccountSubscriptionFollowUp.cancelAtPeriodEnd,
    );
  });
}

extension on AccountWipeSummary {
  AccountWipeSummary withCanceled() {
    return withSubscription(
      const SubscriptionCancelInfo(status: SubscriptionCancelStatus.canceled),
    );
  }

  AccountWipeSummary withSubscription(SubscriptionCancelInfo subscription) {
    return AccountWipeSummary(
      keepAccount: keepAccount,
      deletedWardrobes: deletedWardrobes,
      deletedItems: deletedItems,
      deletedOutfits: deletedOutfits,
      deletedAiProfiles: deletedAiProfiles,
      deletedS3Objects: deletedS3Objects,
      s3Failures: s3Failures,
      deleted: deleted,
      entitlementRevoked: entitlementRevoked,
      subscription: subscription,
    );
  }
}
