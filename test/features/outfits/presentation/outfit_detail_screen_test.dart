import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfit_detail_screen.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfits_screen.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_tile.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/widgets/wardrobe_list_card.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/test_app.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          outfitRepositoryProvider.overrideWithValue(
            FakeOutfitRepository(seed: [testOutfit()]),
          ),
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(
              seed: [
                testItem(id: 'item_top123', name: 'Black tee'),
                testItem(
                  id: 'item_bottom456',
                  name: 'Blue jeans',
                  category: ItemCategory.bottom,
                ),
                testItem(
                  id: 'item_shoes789',
                  name: 'White sneakers',
                  category: ItemCategory.shoes,
                ),
              ],
            ),
          ),
        ],
        child: const MaterialApp(
          home: OutfitDetailScreen(
            wardrobeId: 'wd_abc123',
            outfitId: 'outfit_123',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('outfit detail does not show Added or Updated datestamps', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(OutfitDetailScreen), findsOneWidget);
    expect(find.text('Friday Night'), findsWidgets);
    expect(find.text('Slots'), findsOneWidget);
    expect(find.text('Try on'), findsOneWidget);
    expect(find.byKey(OutfitDetailScreen.editButtonKey), findsOneWidget);
    expect(find.byKey(OutfitDetailScreen.deleteButtonKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets(
    'outfit detail delete confirm calls API and returns to the list',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final harness = TestAppHarness(
        outfits: FakeOutfitRepository(seed: [testOutfit()]),
      );
      addTearDown(harness.dispose);

      await tester.pumpWidget(harness.app());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(WardrobeListCard.cardKey('wd_abc123')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('wardrobe_outfit_tile_outfit_123')),
      );
      await tester.tap(
        find.byKey(const Key('wardrobe_outfit_tile_outfit_123')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OutfitDetailScreen), findsOneWidget);
      await tester.tap(find.byKey(OutfitDetailScreen.deleteButtonKey));
      await tester.pumpAndSettle();
      expect(find.text('Delete outfit?'), findsOneWidget);
      await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
      await tester.pumpAndSettle();

      expect(harness.outfits.deleteCalls, 1);
      expect(find.byType(OutfitsScreen), findsOneWidget);
      expect(find.byType(OutfitDetailScreen), findsNothing);
      expect(find.byKey(OutfitListTile.deleteKey('outfit_123')), findsNothing);
    },
  );

  testWidgets('outfit detail delete error stays and shows a snackbar', (
    tester,
  ) async {
    final outfits = FakeOutfitRepository(seed: [testOutfit()]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          outfitRepositoryProvider.overrideWithValue(outfits),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
        ],
        child: const MaterialApp(
          home: ScaffoldMessenger(
            child: OutfitDetailScreen(
              wardrobeId: 'wd_abc123',
              outfitId: 'outfit_123',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    outfits.nextFailure = const ApiException(
      message: 'Outfit not found.',
      code: 'OUTFIT_NOT_FOUND',
    );

    await tester.tap(find.byKey(OutfitDetailScreen.deleteButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(OutfitDetailScreen), findsOneWidget);
    expect(find.text('Outfit not found.'), findsWidgets);
  });
}
