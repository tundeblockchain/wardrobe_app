import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_recommendation_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  testWidgets('wardrobe detail does not show Created or Updated datestamps', (
    tester,
  ) async {
    final wardrobe = testWardrobe();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [wardrobe]),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
        ],
        child: const MaterialApp(
          home: WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.text('Summer Clothes'), findsWidgets);
    expect(find.textContaining('Created'), findsNothing);
    expect(find.textContaining('Updated'), findsNothing);
    expect(find.text('Outfits'), findsOneWidget);
    expect(find.text('Suggestions'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('Create outfit'), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.addItemButtonKey), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.renameButtonKey), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.deleteButtonKey), findsOneWidget);
  });
}
