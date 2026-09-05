import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/application/outfits_controller.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/recommendations/application/recommendation_detail_controller.dart';
import 'package:wardrobe_app/features/recommendations/application/recommendation_scope.dart';
import 'package:wardrobe_app/features/recommendations/application/recommendations_controller.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/recommendations/data/recommendation_dtos.dart';

import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_recommendation_repository.dart';

void main() {
  late FakeRecommendationRepository recommendations;
  late FakeOutfitRepository outfits;
  late ProviderContainer container;

  const scope = RecommendationScope(wardrobeId: 'wd_abc123', index: 0);

  setUp(() {
    recommendations = FakeRecommendationRepository(
      seed: [testRecommendation()],
    );
    outfits = FakeOutfitRepository();
    container = ProviderContainer.test(
      overrides: [
        recommendationRepositoryProvider.overrideWithValue(recommendations),
        outfitRepositoryProvider.overrideWithValue(outfits),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads the suggestion from the list by index', () async {
    container.read(recommendationsControllerProvider('wd_abc123'));
    container.read(recommendationDetailControllerProvider(scope));
    await settle();

    final state = container.read(recommendationDetailControllerProvider(scope));
    expect(state.recommendation?.name, 'Navy + Beige look');
    expect(state.recommendation?.items, hasLength(2));
    expect(outfits.createCalls, 0);
  });

  test('save maps to CreateOutfitRequest and creates an outfit', () async {
    container.read(recommendationsControllerProvider('wd_abc123'));
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(recommendationDetailControllerProvider(scope));
    await settle();

    final recommendation = container
        .read(recommendationDetailControllerProvider(scope))
        .recommendation!;
    expect(createOutfitRequestFromRecommendation(recommendation).toJson(), {
      'name': 'Navy + Beige look',
      'items': [
        {'itemId': 'item_top123', 'slot': 'TOP'},
        {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
      ],
    });

    final saved = await container
        .read(recommendationDetailControllerProvider(scope).notifier)
        .save();

    expect(saved?.name, 'Navy + Beige look');
    expect(saved?.id, 'outfit_1');
    expect(outfits.createCalls, 1);
    expect(outfits.lastItems, [
      const OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
      const OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
    ]);
    expect(
      container
          .read(outfitsControllerProvider('wd_abc123'))
          .outfits
          .single
          .name,
      'Navy + Beige look',
    );
    expect(
      container.read(recommendationDetailControllerProvider(scope)).isSaving,
      isFalse,
    );
    expect(
      container
          .read(recommendationDetailControllerProvider(scope))
          .savedOutfit
          ?.id,
      'outfit_1',
    );
  });

  test('save records failure without creating an outfit', () async {
    container.read(recommendationsControllerProvider('wd_abc123'));
    container.read(outfitsControllerProvider('wd_abc123'));
    container.read(recommendationDetailControllerProvider(scope));
    await settle();
    outfits.nextFailure = const ApiException(
      message: 'name is required.',
      code: 'VALIDATION_ERROR',
    );

    final saved = await container
        .read(recommendationDetailControllerProvider(scope).notifier)
        .save();

    expect(saved, isNull);
    expect(
      container
          .read(recommendationDetailControllerProvider(scope))
          .errorMessage,
      'name is required.',
    );
    expect(
      container.read(outfitsControllerProvider('wd_abc123')).outfits,
      isEmpty,
    );
  });

  test('does not auto-save when the suggestion loads', () async {
    container.read(recommendationsControllerProvider('wd_abc123'));
    container.read(recommendationDetailControllerProvider(scope));
    await settle();

    expect(outfits.createCalls, 0);
    expect(
      container.read(recommendationDetailControllerProvider(scope)).savedOutfit,
      isNull,
    );
  });
}
