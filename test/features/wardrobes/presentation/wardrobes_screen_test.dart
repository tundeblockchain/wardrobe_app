import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobes_screen.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/widgets/wardrobe_list_card.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/test_app.dart';

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
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(seed: [testItem()]),
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
    expect(find.textContaining('Signed in as'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets('empty wardrobe list keeps the existing empty state', (
    tester,
  ) async {
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(),
      items: FakeItemRepository(),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.byKey(WardrobesScreen.emptyStateKey), findsOneWidget);
    expect(find.text('No wardrobes yet'), findsOneWidget);
    expect(find.byType(WardrobeListCard), findsNothing);
    expect(find.textContaining('Signed in as'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
  });

  testWidgets('wardrobe home shows cards with the first item image', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final shirt = testItem();
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(
        seed: [
          testWardrobe(),
          testWardrobe(id: 'wd_empty', name: 'Empty Closet'),
        ],
      ),
      items: FakeItemRepository(
        seed: [
          shirt,
          testItem(id: 'item_jeans', name: 'Blue jeans'),
        ],
      ),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byType(WardrobeListCard), findsNWidgets(2));
    expect(find.byType(ListTile), findsNothing);
    expect(
      find.byKey(WardrobeListCard.cardKey(shirt.wardrobeId)),
      findsOneWidget,
    );
    expect(
      find.byKey(WardrobeListCard.coverKey(shirt.wardrobeId)),
      findsOneWidget,
    );
    expect(find.byKey(ItemBrowseImage.imageKey(shirt.id)), findsOneWidget);
    expect(
      find.byKey(ItemBrowseImage.sourceKey(shirt.originalImageKey!)),
      findsOneWidget,
    );
    expect(find.text('Summer Clothes'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
    expect(
      find.byKey(WardrobeListCard.placeholderKey('wd_empty')),
      findsOneWidget,
    );
    expect(find.text('Empty Closet'), findsOneWidget);
    expect(find.text('No items yet'), findsOneWidget);
    expect(find.byKey(WardrobesScreen.emptyStateKey), findsNothing);
    expect(find.textContaining('Signed in as'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets('tapping a wardrobe card opens detail', (tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobeListCard.cardKey('wd_abc123')));
    await tester.pumpAndSettle();

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
  });

  testWidgets('wardrobe card delete confirm removes the card from the list', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobeListCard.deleteKey('wd_abc123')));
    await tester.pumpAndSettle();
    expect(find.text('Delete wardrobe?'), findsOneWidget);

    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(harness.wardrobes.deleteCalls, 1);
    expect(find.byType(WardrobesScreen), findsOneWidget);
    expect(find.byType(WardrobeDetailScreen), findsNothing);
    expect(find.byKey(WardrobesScreen.emptyStateKey), findsOneWidget);
  });

  testWidgets('wardrobe card delete cancel does not call DELETE', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = TestAppHarness();
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WardrobeListCard.deleteKey('wd_abc123')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(harness.wardrobes.deleteCalls, 0);
    expect(find.text('Summer Clothes'), findsOneWidget);
  });

  testWidgets(
    'wardrobe card delete error keeps the card and shows a snackbar',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final harness = TestAppHarness();
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      harness.wardrobes.nextFailure = const ApiException(
        message: 'Wardrobe not found.',
        code: 'WARDROBE_NOT_FOUND',
      );

      await tester.tap(find.byKey(WardrobeListCard.deleteKey('wd_abc123')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(WardrobesScreen), findsOneWidget);
      expect(find.text('Summer Clothes'), findsOneWidget);
      expect(find.text('Wardrobe not found.'), findsWidgets);
    },
  );
}
