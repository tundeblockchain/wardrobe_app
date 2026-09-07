import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/presentation/login_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/profile_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/widgets/wardrobe_list_card.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  testWidgets(
    'Profile sign-out then a different account shows only the new wardrobes',
    (tester) async {
      final harness = TestAppHarness(
        auth: FakeAuthRepository(),
        wardrobes: FakeWardrobeRepository(
          seed: [testWardrobe(id: 'wd_alice', name: 'Alice Closet')],
        ),
      );
      addTearDown(harness.dispose);

      harness.sessionStore.preferences['lastAccount'] = 'alice';
      harness.sessionStore.secureStorage['hint'] = 'alice-secret';

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.enterText(
        find.byKey(LoginScreen.emailFieldKey),
        'alice@example.com',
      );
      await tester.enterText(
        find.byKey(LoginScreen.passwordFieldKey),
        'password123',
      );
      await tester.tap(find.byKey(LoginScreen.submitButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(WardrobesScreen), findsOneWidget);
      expect(find.text('Alice Closet'), findsOneWidget);
      expect(find.byKey(WardrobeListCard.cardKey('wd_alice')), findsOneWidget);

      await tester.tap(find.byKey(WardrobesScreen.profileButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(ProfileScreen.signOutButtonKey),
        80,
      );
      await tester.tap(find.byKey(ProfileScreen.signOutButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Alice Closet'), findsNothing);
      expect(harness.sessionStore.preferences, isEmpty);
      expect(harness.sessionStore.secureStorage, isEmpty);
      expect(harness.sessionImages.clearCount, greaterThanOrEqualTo(1));
      expect(harness.sessionStore.clearCount, greaterThanOrEqualTo(1));

      harness.wardrobes.items
        ..clear()
        ..add(testWardrobe(id: 'wd_bob', name: 'Bob Closet'));

      await tester.enterText(
        find.byKey(LoginScreen.emailFieldKey),
        'bob@example.com',
      );
      await tester.enterText(
        find.byKey(LoginScreen.passwordFieldKey),
        'password123',
      );
      await tester.tap(find.byKey(LoginScreen.submitButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(WardrobesScreen), findsOneWidget);
      expect(find.text('Bob Closet'), findsOneWidget);
      expect(find.text('Alice Closet'), findsNothing);
      expect(find.byKey(WardrobeListCard.cardKey('wd_alice')), findsNothing);
      expect(find.byKey(WardrobeListCard.cardKey('wd_bob')), findsOneWidget);
    },
  );
}
