import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfit_detail_screen.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

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
}
