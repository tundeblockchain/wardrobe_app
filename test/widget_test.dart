import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/app.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/presentation/login_screen.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import 'helpers/fake_auth_repository.dart';
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
}
