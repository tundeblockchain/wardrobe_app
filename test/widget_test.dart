import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/app.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';
import 'package:wardrobe_app/features/auth/presentation/login_screen.dart';
import 'package:wardrobe_app/features/auth/presentation/signup_screen.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import 'helpers/fake_app_reviewer.dart';
import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_device_context.dart';
import 'helpers/fake_item_image_picker.dart';
import 'helpers/fake_item_repository.dart';
import 'helpers/fake_outfit_repository.dart';
import 'helpers/fake_recommendation_repository.dart';
import 'helpers/fake_support_repository.dart';
import 'helpers/fake_upload_repository.dart';
import 'helpers/fake_wardrobe_repository.dart';

void main() {
  testWidgets('login then logout follows the auth redirect shell', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
          supportRepositoryProvider.overrideWithValue(FakeSupportRepository()),
          appReviewerProvider.overrideWithValue(FakeAppReviewer()),
          deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
        ],
        child: const WardrobeApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(
      find.byKey(LoginScreen.emailFieldKey),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(LoginScreen.passwordFieldKey),
      'password123',
    );
    await tester.tap(find.byKey(LoginScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.text('No wardrobes yet'), findsOneWidget);
    expect(find.text('Signed in as user@example.com'), findsOneWidget);

    await tester.tap(find.byKey(WardrobesScreen.signOutButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('profile menu opens from the wardrobes app bar', (tester) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
          supportRepositoryProvider.overrideWithValue(FakeSupportRepository()),
          appReviewerProvider.overrideWithValue(FakeAppReviewer()),
          deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
        ],
        child: const WardrobeApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(LoginScreen.emailFieldKey),
      'user@example.com',
    );
    await tester.enterText(
      find.byKey(LoginScreen.passwordFieldKey),
      'password123',
    );
    await tester.tap(find.byKey(LoginScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(WardrobesScreen.profileButtonKey), findsOneWidget);
    await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('Signed in with Email'), findsOneWidget);
    expect(find.text('Rate the app'), findsOneWidget);
    expect(find.text('Contact us'), findsOneWidget);
    expect(find.text('Report a bug'), findsOneWidget);
  });

  testWidgets('Google sign-in from login follows the auth redirect shell', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
        ],
        child: const WardrobeApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(LoginScreen.googleButtonKey), findsOneWidget);

    await tester.tap(find.byKey(LoginScreen.googleButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.text('Signed in as google.user@example.com'), findsOneWidget);
  });

  testWidgets('Google sign-in from signup follows the auth redirect shell', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
        ],
        child: const WardrobeApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    expect(find.byType(SignupScreen), findsOneWidget);
    await tester.ensureVisible(find.byKey(SignupScreen.googleButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SignupScreen.googleButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.text('Signed in as google.user@example.com'), findsOneWidget);
  });

  testWidgets('Google cancel on login stays on the form without an error', (
    tester,
  ) async {
    final repository = FakeAuthRepository()
      ..nextFailure = const AuthFailure(
        'Sign-in cancelled.',
        code: AuthFailure.cancelledCode,
      );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
        ],
        child: const WardrobeApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LoginScreen.googleButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sign-in cancelled.'), findsNothing);
    expect(find.byType(WardrobesScreen), findsNothing);
  });
}
