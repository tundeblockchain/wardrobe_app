import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/core/widgets/type_to_confirm_dialog.dart';
import 'package:wardrobe_app/features/account/domain/account_subscription_copy.dart';
import 'package:wardrobe_app/features/account/domain/account_wipe_summary.dart';
import 'package:wardrobe_app/features/account/domain/subscription_cancel_info.dart';
import 'package:wardrobe_app/features/account/presentation/subscription_cancel_follow_up_dialog.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';
import 'package:wardrobe_app/features/auth/presentation/login_screen.dart';
import 'package:wardrobe_app/features/entitlements/domain/paywall_gateway.dart';
import 'package:wardrobe_app/features/entitlements/domain/subscription_tier.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets('wardrobe delete cancel does not call DELETE', (tester) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobeDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Delete wardrobe?'), findsOneWidget);

    await tester.tap(find.byKey(DestructiveConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(harness.wardrobes.deleteCalls, 0);
    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
  });

  testWidgets('wardrobe delete confirm calls API and returns to the list', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobeDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(harness.wardrobes.deleteCalls, 1);
    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.text('No wardrobes yet'), findsOneWidget);
  });

  testWidgets('wardrobe delete error stays on detail and shows a snackbar', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    harness.wardrobes.nextFailure = const ApiException(
      message: 'Wardrobe not found.',
      code: 'WARDROBE_NOT_FOUND',
    );

    await tester.tap(find.byKey(WardrobeDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.text('Wardrobe not found.'), findsWidgets);
  });

  testWidgets('item delete cancel does not call DELETE', (tester) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await _openItemDetail(tester);

    await tester.tap(find.byKey(ItemDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(harness.items.deleteCalls, 0);
    expect(find.byType(ItemDetailScreen), findsOneWidget);
  });

  testWidgets('item delete confirm calls API and pops to wardrobe detail', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tapHomeWardrobeCard(tester);
    await tester.pumpAndSettle();
    await _openItemDetail(tester);

    await tester.tap(find.byKey(ItemDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(harness.items.deleteCalls, 1);
    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.byType(ItemDetailScreen), findsNothing);
  });

  testWidgets('clear all content requires CLEAR and keeps the session', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _ensureVisible(tester, ProfileScreen.clearContentButtonKey);

    await tester.tap(find.byKey(ProfileScreen.clearContentButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TypeToConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();
    expect(harness.account.clearCalls, 0);

    await tester.tap(find.byKey(ProfileScreen.clearContentButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(TypeToConfirmDialog.phraseFieldKey),
      'CLEAR',
    );
    await tester.pump();
    await tester.tap(find.byKey(TypeToConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(harness.account.clearCalls, 1);
    expect(harness.auth.deleteUserCalls, 0);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byKey(ProfileScreen.infoTextKey), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('clear all content surfaces API errors', (tester) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);
    harness.account.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _ensureVisible(tester, ProfileScreen.clearContentButtonKey);
    await tester.tap(find.byKey(ProfileScreen.clearContentButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(TypeToConfirmDialog.phraseFieldKey),
      'CLEAR',
    );
    await tester.pump();
    await tester.tap(find.byKey(TypeToConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(ProfileScreen.errorTextKey), findsOneWidget);
    expect(find.textContaining('connection'), findsOneWidget);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('delete account CANCELED goes to login without follow-up', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);
    harness.account.deleteResult = const AccountWipeSummary(
      keepAccount: false,
      deletedWardrobes: 1,
      deletedItems: 2,
      deletedOutfits: 1,
      deletedS3Objects: 3,
      s3Failures: 0,
      deleted: true,
      entitlementRevoked: true,
      subscription: SubscriptionCancelInfo(
        status: SubscriptionCancelStatus.canceled,
        cancelMode: SubscriptionCancelMode.immediate,
      ),
    );

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _confirmDeleteAccount(tester);

    expect(harness.account.deleteCalls, 1);
    expect(harness.auth.deleteUserCalls, 1);
    expect(
      find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
      findsNothing,
    );
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('delete account NONE goes to login without follow-up', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);
    harness.account.deleteResult = const AccountWipeSummary(
      keepAccount: false,
      deletedWardrobes: 1,
      deletedItems: 2,
      deletedOutfits: 1,
      deletedS3Objects: 3,
      s3Failures: 0,
      deleted: true,
      entitlementRevoked: true,
      subscription: SubscriptionCancelInfo(
        status: SubscriptionCancelStatus.none,
      ),
    );

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _confirmDeleteAccount(tester);

    expect(harness.auth.deleteUserCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('delete account still succeeds when Backend omits subscription', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _confirmDeleteAccount(tester);

    expect(harness.account.deleteCalls, 1);
    expect(harness.auth.deleteUserCalls, 1);
    expect(
      find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
      findsNothing,
    );
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('delete account surfaces Firebase failure and stays signed in', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);
    harness.auth.nextFailure = const AuthFailure(
      'Sign in again to delete your account.',
      code: 'requires-recent-login',
    );

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _ensureVisible(tester, ProfileScreen.deleteAccountButtonKey);
    await tester.tap(find.byKey(ProfileScreen.deleteAccountButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(TypeToConfirmDialog.phraseFieldKey),
      'DELETE',
    );
    await tester.pump();
    await tester.tap(find.byKey(TypeToConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(harness.account.deleteCalls, 1);
    expect(harness.auth.deleteUserCalls, 0);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.textContaining('could not be removed'), findsOneWidget);
  });

  testWidgets(
    'delete account CANCEL_FAILED shows Retry/Continue and Continue logs out',
    (tester) async {
      final harness = TestAppHarness();
      addTearDown(harness.dispose);
      harness.account.deleteResult = const AccountWipeSummary(
        keepAccount: false,
        deletedWardrobes: 1,
        deletedItems: 2,
        deletedOutfits: 1,
        deletedS3Objects: 3,
        s3Failures: 0,
        deleted: true,
        entitlementRevoked: true,
        subscription: SubscriptionCancelInfo(
          status: SubscriptionCancelStatus.cancelFailed,
          retryInStore: true,
          store: EntitlementStore.appStore,
        ),
      );

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
      await tester.pumpAndSettle();
      await _confirmDeleteAccount(tester);

      expect(harness.account.deleteCalls, 1);
      expect(harness.paywall.cancelCount, 1);
      expect(harness.auth.deleteUserCalls, 0);
      expect(
        find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
        findsOneWidget,
      );
      expect(find.textContaining('orphaned billing'), findsWidgets);
      expect(find.textContaining('App Store → Subscriptions'), findsWidgets);
      expect(
        find.byKey(SubscriptionCancelFollowUpDialog.retryButtonKey),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(SubscriptionCancelFollowUpDialog.continueButtonKey),
      );
      await tester.pumpAndSettle();

      expect(harness.auth.deleteUserCalls, 1);
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets('delete account cancel Retry then success goes to login', (
    tester,
  ) async {
    final harness = TestAppHarness();
    addTearDown(harness.dispose);
    harness.paywall.cancelError = StateError('superwall cancel');
    harness.account.deleteResult = const AccountWipeSummary(
      keepAccount: false,
      deletedWardrobes: 1,
      deletedItems: 2,
      deletedOutfits: 1,
      deletedS3Objects: 3,
      s3Failures: 0,
      deleted: true,
    );

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();
    await _confirmDeleteAccount(tester);

    expect(
      find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
      findsOneWidget,
    );
    expect(harness.auth.deleteUserCalls, 0);

    harness.paywall.cancelResult = CancelSubscriptionResult.canceled;
    await tester.tap(
      find.byKey(SubscriptionCancelFollowUpDialog.retryButtonKey),
    );
    await tester.pumpAndSettle();

    expect(harness.paywall.cancelCount, 2);
    expect(harness.auth.deleteUserCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets(
    'CANCEL_AT_PERIOD_END shows store copy without Retry and Continue logs out',
    (tester) async {
      final harness = TestAppHarness();
      addTearDown(harness.dispose);
      harness.account.deleteResult = const AccountWipeSummary(
        keepAccount: false,
        deletedWardrobes: 1,
        deletedItems: 2,
        deletedOutfits: 1,
        deletedS3Objects: 3,
        s3Failures: 0,
        deleted: true,
        subscription: SubscriptionCancelInfo(
          status: SubscriptionCancelStatus.cancelAtPeriodEnd,
          cancelMode: SubscriptionCancelMode.periodEnd,
        ),
      );

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
      await tester.pumpAndSettle();
      await _confirmDeleteAccount(tester);

      expect(
        find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
        findsOneWidget,
      );
      expect(
        find.byKey(SubscriptionCancelFollowUpDialog.messageKey),
        findsOneWidget,
      );
      expect(find.textContaining('current period'), findsWidgets);
      expect(
        find.byKey(SubscriptionCancelFollowUpDialog.retryButtonKey),
        findsNothing,
      );

      await tester.tap(
        find.byKey(SubscriptionCancelFollowUpDialog.continueButtonKey),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets(
    'delete account 500 INTERNAL_ERROR shows Retry delete and retry succeeds',
    (tester) async {
      final harness = TestAppHarness();
      addTearDown(harness.dispose);
      harness.account.nextFailure = const ApiException(
        message: 'Wipe failed.',
        code: 'INTERNAL_ERROR',
        statusCode: 500,
      );

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
      await tester.pumpAndSettle();
      await _confirmDeleteAccount(tester);

      expect(harness.account.deleteCalls, 1);
      expect(harness.auth.deleteUserCalls, 0);
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
      expect(
        find.text(AccountSubscriptionCopy.wipeFailedMessage),
        findsOneWidget,
      );

      await _ensureVisible(tester, ProfileScreen.retryWipeButtonKey);
      await tester.tap(find.byKey(ProfileScreen.retryWipeButtonKey));
      await tester.pumpAndSettle();

      expect(harness.account.deleteCalls, 2);
      expect(harness.auth.deleteUserCalls, 1);
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets('reduced motion skips the subscription follow-up fade', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const SubscriptionCancelFollowUpDialog(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(SubscriptionCancelFollowUpDialog.dialogKey),
      findsOneWidget,
    );
    expect(find.byType(AppFadeIn), findsNothing);
  });
}

Future<void> _ensureVisible(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.scrollUntilVisible(finder, 80);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> _confirmDeleteAccount(WidgetTester tester) async {
  await _ensureVisible(tester, ProfileScreen.deleteAccountButtonKey);
  await tester.tap(find.byKey(ProfileScreen.deleteAccountButtonKey));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(TypeToConfirmDialog.phraseFieldKey),
    'DELETE',
  );
  await tester.pump();
  await tester.tap(find.byKey(TypeToConfirmDialog.confirmButtonKey));
  await tester.pumpAndSettle();
}

Future<void> _openItemDetail(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpAndSettle();

  final itemFinder = find.byKey(Key('item_tile_${testItem().id}'));
  await tester.ensureVisible(itemFinder);
  await tester.tap(itemFinder);
  await tester.pumpAndSettle();
}
