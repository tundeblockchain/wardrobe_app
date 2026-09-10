import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_item_slider.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/recommendations/presentation/recommendation_detail_screen.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_recommendation_repository.dart';

void main() {
  testWidgets('suggestion detail shows a slider of selected-item cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(seed: [testRecommendation()]),
          ),
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(
              seed: [
                testItem(id: 'item_top123', name: 'Navy knit'),
                testItem(
                  id: 'item_bottom456',
                  name: 'Beige trousers',
                  category: ItemCategory.bottom,
                ),
              ],
            ),
          ),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
        ],
        child: const MaterialApp(
          home: RecommendationDetailScreen(wardrobeId: 'wd_abc123', index: 0),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Navy + Beige look'), findsWidgets);
    expect(find.text('Items'), findsOneWidget);
    expect(find.byKey(OutfitItemSlider.sliderKey), findsOneWidget);
    expect(find.byKey(OutfitItemSlider.cardKey('item_top123')), findsOneWidget);
    expect(find.text('Navy knit'), findsOneWidget);
    expect(find.text('Save outfit'), findsOneWidget);
  });
}
