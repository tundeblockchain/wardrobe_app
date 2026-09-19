import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_filter_bar.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_swipe_card.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_swipe_deck.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_carousel.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_tile.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';
import 'package:wardrobe_app/features/wardrobes/presentation/wardrobe_detail_screen.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_recommendation_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  Future<void> pumpDetail(
    WidgetTester tester, {
    List<Item>? items,
    FakeOutfitRepository? outfits,
  }) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(seed: items),
          ),
          outfitRepositoryProvider.overrideWithValue(
            outfits ?? FakeOutfitRepository(),
          ),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: const MaterialApp(
          home: WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('wardrobe detail does not show Created or Updated datestamps', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(WardrobeDetailScreen), findsOneWidget);
    expect(find.text('Summer Clothes'), findsWidgets);
    expectNoCreatedUpdatedDateStamps();
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('Outfits'), findsOneWidget);
    expect(find.text('Suggestions'), findsOneWidget);
    expect(find.text('Worn on'), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.wornOnButtonKey), findsOneWidget);
    expect(find.text('Dressing room'), findsOneWidget);
    expect(find.text('Create outfit'), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.addItemButtonKey), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.renameButtonKey), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.deleteButtonKey), findsOneWidget);
  });

  testWidgets('empty wardrobe keeps the existing empty items state', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsOneWidget);
    expect(find.text('Add your first piece'), findsOneWidget);
    expect(find.text('Add from gallery'), findsOneWidget);
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.byType(ItemSwipeDeck), findsNothing);
    expect(find.byType(ItemFilterBar), findsNothing);
  });

  testWidgets(
    'wardrobe detail sections are items, outfits, suggestions, worn on, then dressing room',
    (tester) async {
      await pumpDetail(tester);

      final itemsY = tester.getTopLeft(find.text('Items')).dy;
      final outfitsY = tester.getTopLeft(find.text('Outfits')).dy;
      final suggestionsY = tester.getTopLeft(find.text('Suggestions')).dy;
      final wornOnY = tester.getTopLeft(find.text('Worn on')).dy;
      final dressingY = tester.getTopLeft(find.text('Dressing room')).dy;

      expect(itemsY, lessThan(outfitsY));
      expect(outfitsY, lessThan(suggestionsY));
      expect(suggestionsY, lessThan(wornOnY));
      expect(wornOnY, lessThan(dressingY));

      expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsOneWidget);
      expect(find.text('Add your first piece'), findsOneWidget);
      expect(
        find.text('Build a look from items in this wardrobe'),
        findsOneWidget,
      );
      expect(find.text('No suggestions yet'), findsOneWidget);
      expect(find.byKey(WardrobeDetailScreen.wornOnButtonKey), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Virtual try-on'), findsOneWidget);
      expect(
        find.byKey(WardrobeDetailScreen.dressingRoomButtonKey),
        findsOneWidget,
      );

      final emptyItemsY = tester
          .getTopLeft(find.byKey(WardrobeDetailScreen.itemsEmptyKey))
          .dy;
      expect(emptyItemsY, greaterThan(itemsY));
      expect(emptyItemsY, lessThan(outfitsY));
    },
  );

  testWidgets('single item stays a large card without swipe', (tester) async {
    await pumpDetail(tester, items: [testItem()]);

    expect(find.byType(ItemSwipeDeck), findsOneWidget);
    expect(find.byType(GridView), findsNothing);
    expect(find.byType(ItemFilterBar), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.cardKey(testItem().id)), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.swipeHintKey), findsNothing);
    expect(find.byKey(ItemSwipeDeck.nextButtonKey), findsNothing);
    expect(find.byKey(ItemSwipeDeck.swipeLayerKey), findsNothing);
    expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsNothing);
  });

  testWidgets('populated wardrobe browses items with a swipe card deck', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      items: [
        testItem(),
        testItem(id: 'item_jeans', name: 'Blue jeans'),
      ],
    );

    expect(find.byType(ItemSwipeDeck), findsOneWidget);
    expect(find.byType(GridView), findsNothing);
    expect(find.byType(ItemFilterBar), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.cardKey(testItem().id)), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.swipeHintKey), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.nextButtonKey), findsOneWidget);
    expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsNothing);
  });

  testWidgets('smart filters apply to the swipe card deck', (tester) async {
    final shoes = testItem(
      id: 'item_shoes',
      name: 'Black boots',
      category: ItemCategory.shoes,
      subcategory: 'BOOTS',
    );
    await pumpDetail(tester, items: [testItem(), shoes]);

    expect(find.text('1 of 2'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.shoes)),
    );
    await tester.tap(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.shoes)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Black boots'), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsNothing);
  });

  testWidgets(
    'colour chip filters the loaded deck without hiding other items',
    (tester) async {
      final white = testItem(
        id: 'item_white',
        name: 'White shirt',
        colours: const ['WHITE'],
      );
      await pumpDetail(tester, items: [testItem(), white]);

      await tester.ensureVisible(
        find.byKey(ItemFilterBar.colourChipKey(ItemColour.white)),
      );
      await tester.tap(
        find.byKey(ItemFilterBar.colourChipKey(ItemColour.white)),
      );
      await tester.pumpAndSettle();

      expect(find.text('White shirt'), findsOneWidget);
      expect(find.text('1 of 1'), findsOneWidget);
      expect(find.text('Black Nike T-Shirt'), findsNothing);
    },
  );

  testWidgets('tag chip filters subcategory on the loaded deck', (
    tester,
  ) async {
    final hoodie = testItem(
      id: 'item_hoodie',
      name: 'Grey hoodie',
      subcategory: 'HOODIE',
      colours: const ['GREY'],
    );
    await pumpDetail(tester, items: [testItem(), hoodie]);

    await tester.ensureVisible(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.top)),
    );
    await tester.tap(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.top)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tag'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ItemFilterBar.subcategoryChipKey(ItemSubcategory.hoodie)),
    );
    await tester.tap(
      find.byKey(ItemFilterBar.subcategoryChipKey(ItemSubcategory.hoodie)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Grey hoodie'), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsNothing);
  });

  testWidgets('empty filter results show a soft message and clear filters', (
    tester,
  ) async {
    await pumpDetail(tester, items: [testItem()]);

    await tester.ensureVisible(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.dress)),
    );
    await tester.tap(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.dress)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(WardrobeDetailScreen.itemsFilteredEmptyKey),
      findsOneWidget,
    );
    expect(
      find.byKey(WardrobeDetailScreen.filteredDeckSwitcherKey),
      findsOneWidget,
    );
    expect(find.text('No matches'), findsOneWidget);
    expect(find.text('No items match these filters.'), findsOneWidget);
    expect(find.byType(ItemSwipeDeck), findsNothing);

    await tester.tap(
      find.byKey(WardrobeDetailScreen.itemsFilteredEmptyClearKey),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ItemSwipeDeck), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(
      find.byKey(WardrobeDetailScreen.itemsFilteredEmptyKey),
      findsNothing,
    );
  });

  testWidgets('filter deck skips cross-fade when motion is reduced', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(seed: [testItem()]),
          ),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(WardrobeDetailScreen.filteredDeckSwitcherKey),
      findsNothing,
    );
    await tester.ensureVisible(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.dress)),
    );
    await tester.tap(
      find.byKey(ItemFilterBar.categoryChipKey(ItemCategory.dress)),
    );
    await tester.pump();

    expect(find.text('No matches'), findsOneWidget);
    expect(
      find.byKey(WardrobeDetailScreen.filteredDeckSwitcherKey),
      findsNothing,
    );
  });

  testWidgets('hide-older-than filter drops clothes acquired before the date', (
    tester,
  ) async {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final older = testItem(
      id: 'item_old',
      name: 'Vintage coat',
      acquiredAt: DateTime.utc(2020, 1, 1),
    );
    final newer = testItem(id: 'item_new', name: 'New tee', acquiredAt: today);
    final unknown = testItem(id: 'item_unknown', name: 'No date shirt');
    await pumpDetail(tester, items: [older, newer, unknown]);

    expect(find.text('1 of 3'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(ItemFilterBar.acquiredAfterButtonKey),
    );
    await tester.tap(find.byKey(ItemFilterBar.acquiredAfterButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Vintage coat'), findsNothing);
    expect(find.text('No date shirt'), findsNothing);
    expect(find.text('New tee'), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.byKey(ItemFilterBar.clearButtonKey), findsOneWidget);
  });

  testWidgets('FAILED item card shows processingError and retry', (
    tester,
  ) async {
    final items = FakeItemRepository(
      seed: [
        testItem(
          processingStatus: ItemProcessingStatus.failed,
          processingError: 'Background removal failed.',
        ),
      ],
    );

    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          itemRepositoryProvider.overrideWithValue(items),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: const MaterialApp(
          home: WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Background removal failed.'), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.retryKey(testItem().id)), findsOneWidget);

    await tester.tap(find.byKey(ItemSwipeCard.retryKey(testItem().id)));
    await tester.pumpAndSettle();

    expect(items.reprocessCalls, 1);
    expect(find.text('Failed'), findsNothing);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('PROCESSING item card shows a delete control', (tester) async {
    await pumpDetail(
      tester,
      items: [testItem(processingStatus: ItemProcessingStatus.processing)],
    );

    expect(find.byKey(ItemSwipeCard.deleteKey(testItem().id)), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.removeButtonKey), findsOneWidget);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Processed'), findsNothing);
    expect(find.text('Failed'), findsNothing);
  });

  testWidgets('item card delete works for FAILED and PROCESSING items', (
    tester,
  ) async {
    final failed = testItem(processingStatus: ItemProcessingStatus.failed);
    final outfits = FakeOutfitRepository();
    final items = FakeItemRepository(seed: [failed]);

    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          itemRepositoryProvider.overrideWithValue(items),
          outfitRepositoryProvider.overrideWithValue(outfits),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: const MaterialApp(
          home: WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(ItemSwipeCard.deleteKey(failed.id)), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.removeButtonKey), findsOneWidget);

    await tester.ensureVisible(find.byKey(ItemSwipeDeck.removeButtonKey));
    await tester.tap(find.byKey(ItemSwipeDeck.removeButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Delete item?'), findsOneWidget);

    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(items.deleteCalls, 1);
    expect(find.byKey(WardrobeDetailScreen.itemsEmptyKey), findsOneWidget);
  });

  testWidgets('outfit preview delete confirm removes the row', (tester) async {
    final outfits = FakeOutfitRepository(seed: [testOutfit()]);
    await pumpDetail(tester, items: [testItem()], outfits: outfits);

    expect(find.byKey(OutfitCarousel.carouselKey), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(OutfitListTile.deleteKey('outfit_123')),
    );
    await tester.tap(find.byKey(OutfitListTile.deleteKey('outfit_123')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(outfits.deleteCalls, 1);
    expect(find.text('Friday Night'), findsNothing);
  });

  testWidgets('item card delete error stays on the deck and shows a snackbar', (
    tester,
  ) async {
    final items = FakeItemRepository(seed: [testItem()]);

    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(seed: [testWardrobe()]),
          ),
          itemRepositoryProvider.overrideWithValue(items),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          ...itemProcessingPollTestOverrides(),
        ],
        child: const MaterialApp(
          home: ScaffoldMessenger(
            child: WardrobeDetailScreen(wardrobeId: 'wd_abc123'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    items.nextFailure = const ApiException(
      message: 'Item not found.',
      code: 'ITEM_NOT_FOUND',
    );

    await tester.ensureVisible(find.byKey(ItemSwipeDeck.removeButtonKey));
    await tester.tap(find.byKey(ItemSwipeDeck.removeButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(items.deleteCalls, 1);
    expect(find.byKey(ItemSwipeCard.cardKey(testItem().id)), findsOneWidget);
    expect(find.text('Item not found.'), findsWidgets);
  });
}
