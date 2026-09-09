import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/theme/app_colors.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/theme/theme_controller.dart';
import 'package:wardrobe_app/core/theme/theme_preferences.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/account/data/dio_account_repository.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/ai_try_on_screen.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/profile/presentation/contact_us_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/report_bug_screen.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_account_repository.dart';
import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_app_reviewer.dart';
import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_device_context.dart';
import '../../../helpers/fake_item_image_picker.dart';
import '../../../helpers/fake_support_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late FakeAppReviewer reviewer;
  late FakeSupportRepository support;

  setUp(() {
    auth = FakeAuthRepository(
      initialUser: const AppUser(
        uid: 'uid-1',
        email: 'ada@example.com',
        displayName: 'Ada Lovelace',
        providerId: 'google.com',
      ),
    );
    reviewer = FakeAppReviewer();
    support = FakeSupportRepository();
  });

  tearDown(() => auth.dispose());

  Future<void> pumpMenu(
    WidgetTester tester, {
    ThemePreferences? themePreferences,
  }) async {
    final router = GoRouter(
      initialLocation: AppRoutes.profile,
      routes: [
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'contact',
              builder: (context, state) => const ContactUsScreen(),
            ),
            GoRoute(
              path: 'report-bug',
              builder: (context, state) => const ReportBugScreen(),
            ),
            GoRoute(
              path: 'ai-try-on',
              builder: (context, state) => const AiTryOnScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          accountRepositoryProvider.overrideWithValue(FakeAccountRepository()),
          appReviewerProvider.overrideWithValue(reviewer),
          supportRepositoryProvider.overrideWithValue(support),
          aiProfileRepositoryProvider.overrideWithValue(
            FakeAiProfileRepository(),
          ),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
          deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
          if (themePreferences != null)
            themePreferencesProvider.overrideWithValue(themePreferences),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp.router(
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: ref.watch(themeControllerProvider),
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows Firebase account info and menu items', (tester) async {
    await pumpMenu(tester);

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('Signed in with Google'), findsOneWidget);
    expect(find.byKey(ProfileScreen.themeToggleKey), findsOneWidget);
    expect(find.text('Dark theme'), findsOneWidget);
    expect(find.byKey(ProfileScreen.aiTryOnTileKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
    expect(find.byKey(ProfileScreen.rateTileKey), findsOneWidget);
    expect(find.byKey(ProfileScreen.contactTileKey), findsOneWidget);
    expect(find.byKey(ProfileScreen.reportBugTileKey), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(ProfileScreen.deleteAccountButtonKey),
      80,
    );
    expect(find.byKey(ProfileScreen.clearContentButtonKey), findsOneWidget);
    expect(find.byKey(ProfileScreen.deleteAccountButtonKey), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(ProfileScreen.signOutButtonKey),
      80,
    );
    expect(find.byKey(ProfileScreen.signOutButtonKey), findsOneWidget);
  });

  testWidgets('Sign out from profile clears the session', (tester) async {
    await pumpMenu(tester);

    await tester.scrollUntilVisible(
      find.byKey(ProfileScreen.signOutButtonKey),
      80,
    );
    await tester.tap(find.byKey(ProfileScreen.signOutButtonKey));
    await tester.pumpAndSettle();

    expect(auth.currentUser, isNull);
  });

  testWidgets('Rate the app calls the reviewer', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.byKey(ProfileScreen.rateTileKey));
    await tester.pumpAndSettle();

    expect(reviewer.requestCalls, 1);
    expect(find.text('Unable to open the store right now.'), findsNothing);
  });

  testWidgets('Rate the app shows an error when the store fails', (
    tester,
  ) async {
    reviewer.nextError = Exception('unavailable');
    await pumpMenu(tester);

    await tester.tap(find.byKey(ProfileScreen.rateTileKey));
    await tester.pumpAndSettle();

    expect(find.text('Unable to open the store right now.'), findsOneWidget);
  });

  testWidgets('theme toggle switches to dark AppTheme tokens and persists', (
    tester,
  ) async {
    final store = InMemoryThemePreferences(ThemeMode.light);
    await pumpMenu(tester, themePreferences: store);

    expect(find.byKey(ProfileScreen.themeToggleKey), findsOneWidget);
    var scheme = Theme.of(tester.element(find.byType(ProfileScreen)))
        .colorScheme;
    expect(scheme.brightness, Brightness.light);
    expect(scheme.primary, AppColors.lightPrimary);
    expect(scheme.secondary, AppColors.lightSecondary);

    await tester.tap(find.byKey(ProfileScreen.themeToggleKey));
    await tester.pumpAndSettle();

    expect(store.read(), ThemeMode.dark);
    scheme = Theme.of(tester.element(find.byType(ProfileScreen))).colorScheme;
    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, AppColors.darkPrimary);
    expect(scheme.secondary, AppColors.darkSecondary);

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpMenu(tester, themePreferences: store);
    scheme = Theme.of(tester.element(find.byType(ProfileScreen))).colorScheme;
    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, AppColors.darkPrimary);
  });

  testWidgets('AI try-on opens the profile setup screen', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.byKey(ProfileScreen.aiTryOnTileKey));
    await tester.pumpAndSettle();

    expect(find.byType(AiTryOnScreen), findsOneWidget);
    expect(find.text('AI try-on'), findsWidgets);
  });

  testWidgets('Contact us opens the support form', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.byKey(ProfileScreen.contactTileKey));
    await tester.pumpAndSettle();

    expect(find.byType(ContactUsScreen), findsOneWidget);
    expect(find.text('Contact us'), findsWidgets);
  });

  testWidgets('Report a bug opens the bug form', (tester) async {
    await pumpMenu(tester);

    await tester.tap(find.byKey(ProfileScreen.reportBugTileKey));
    await tester.pumpAndSettle();

    expect(find.byType(ReportBugScreen), findsOneWidget);
    expect(find.text('Report a bug'), findsWidgets);
  });
}
