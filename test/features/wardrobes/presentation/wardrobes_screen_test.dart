import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() {
    auth = FakeAuthRepository(
      initialUser: const AppUser(uid: 'uid-1', email: 'user@example.com'),
    );
  });

  tearDown(() => auth.dispose());

  Future<void> pumpList(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
        ],
        child: const MaterialApp(home: WardrobesScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('wardrobe list does not show Created or Updated datestamps', (
    tester,
  ) async {
    await pumpList(tester);

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.text('Summer Clothes'), findsOneWidget);
    expect(find.byKey(const Key('wardrobe_tile_wd_abc123')), findsOneWidget);
    expect(find.byKey(WardrobesScreen.createButtonKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });
}
