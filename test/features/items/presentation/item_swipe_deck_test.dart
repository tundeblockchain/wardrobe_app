import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_swipe_card.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_swipe_deck.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';

void main() {
  final shirt = testItem();
  final jeans = testItem(
    id: 'item_jeans',
    name: 'Blue jeans',
    category: ItemCategory.bottom,
    subcategory: 'JEANS',
    colours: const ['BLUE'],
    brand: 'Levi\'s',
    originalImageKey: 'users/uid/uploads/jeans.jpg',
    processedImageKey: 'users/uid/items/item_jeans/processed.png',
  );
  final sneakers = testItem(
    id: 'item_sneakers',
    name: 'White sneakers',
    category: ItemCategory.shoes,
    subcategory: 'SNEAKERS',
    colours: const ['WHITE'],
    brand: 'Nike',
    processingStatus: ItemProcessingStatus.processing,
  );

  Future<void> pumpDeck(
    WidgetTester tester, {
    required List<Item> items,
    ValueChanged<Item>? onOpen,
    ValueChanged<Item>? onDelete,
  }) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final opened = <Item>[];
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ItemSwipeDeck(
                  items: items,
                  onOpenItem: onOpen ?? opened.add,
                  onDeleteItem: onDelete,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows a full-width card for the first item with its image', (
    tester,
  ) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    expect(find.byType(ItemSwipeDeck), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.cardKey(shirt.id)), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.imageKey(shirt.id)), findsOneWidget);
    expect(
      find.byKey(ItemBrowseImage.sourceKey(shirt.originalImageKey!)),
      findsOneWidget,
    );
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets('prefers the processed image key on the card', (tester) async {
    await pumpDeck(tester, items: [jeans, shirt]);

    expect(
      find.byKey(ItemBrowseImage.sourceKey(jeans.processedImageKey!)),
      findsOneWidget,
    );
    expect(
      find.byKey(ItemBrowseImage.sourceKey(jeans.originalImageKey!)),
      findsNothing,
    );
  });

  testWidgets('hides FAILED status and processingError on the card', (
    tester,
  ) async {
    final failed = testItem(
      id: 'item_failed',
      name: 'Torn shirt',
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Background removal failed.',
      originalImageUrl: 'https://cdn.example.com/original.jpg',
    );

    await pumpDeck(tester, items: [failed]);

    expect(find.byType(ProcessingStatusChip), findsNothing);
    expect(find.text('Failed'), findsNothing);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Processed'), findsNothing);
    expect(find.text('Background removal failed.'), findsNothing);
    expect(
      find.byKey(ItemBrowseImage.sourceKey(failed.originalImageKey!)),
      findsOneWidget,
    );
    expect(find.text('Torn shirt'), findsOneWidget);
  });

  testWidgets('hides processing status chrome on the card', (tester) async {
    await pumpDeck(tester, items: [sneakers]);

    expect(find.byType(ProcessingStatusChip), findsNothing);
    expect(find.text('Processing'), findsNothing);
    expect(find.text('Processed'), findsNothing);
    expect(find.text('Pending'), findsNothing);
    expect(find.text('Failed'), findsNothing);
    expect(find.text('White sneakers'), findsOneWidget);
  });

  testWidgets('single item is a static large card with no swipe affordance', (
    tester,
  ) async {
    await pumpDeck(tester, items: [shirt]);

    expect(find.byKey(ItemSwipeCard.cardKey(shirt.id)), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.imageKey(shirt.id)), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.swipeHintKey), findsNothing);
    expect(find.text(ItemSwipeDeck.swipeHintText), findsNothing);
    expect(find.byKey(ItemSwipeDeck.nextButtonKey), findsNothing);
    expect(find.byKey(ItemSwipeDeck.swipeLayerKey), findsNothing);
    expect(find.byKey(ItemSwipeDeck.openButtonKey), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.endKey), findsNothing);

    await tester.fling(
      find.byKey(ItemSwipeCard.cardKey(shirt.id)),
      const Offset(-300, 0),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(ItemSwipeCard.cardKey(shirt.id)), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.endKey), findsNothing);
    expect(find.text('No more items'), findsNothing);
  });

  testWidgets('multi-item deck keeps swipe hint and next-item controls', (
    tester,
  ) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    expect(find.byKey(ItemSwipeDeck.swipeHintKey), findsOneWidget);
    expect(find.text(ItemSwipeDeck.swipeHintText), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.nextButtonKey), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.swipeLayerKey), findsOneWidget);
  });

  testWidgets('swipe left does not advance or dismiss the card', (
    tester,
  ) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    await tester.fling(
      find.byKey(ItemSwipeCard.cardKey(shirt.id)),
      const Offset(-300, 0),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.cardKey(shirt.id)), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.endKey), findsNothing);
  });

  testWidgets('swipe right advances to the next item', (tester) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    await tester.fling(
      find.byKey(ItemSwipeCard.cardKey(shirt.id)),
      const Offset(300, 0),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.text('Blue jeans'), findsOneWidget);
    expect(find.text('2 of 2'), findsOneWidget);
  });

  testWidgets('vertical drag does not flip or advance the card', (
    tester,
  ) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    await tester.fling(
      find.byKey(ItemSwipeCard.cardKey(shirt.id)),
      const Offset(0, -300),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.byKey(ItemSwipeCard.cardKey(shirt.id)), findsOneWidget);

    await tester.fling(
      find.byKey(ItemSwipeCard.cardKey(shirt.id)),
      const Offset(0, 300),
      1200,
    );
    await tester.pumpAndSettle();

    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
  });

  testWidgets(
    'vertical drag on the card scrolls the parent instead of swiping',
    (tester) async {
      tester.view.physicalSize = const Size(400, 520);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ItemSwipeDeck(
                    items: [shirt, jeans],
                    onOpenItem: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.pixels, 0);

      await tester.drag(
        find.byKey(ItemSwipeCard.cardKey(shirt.id)),
        const Offset(0, -160),
      );
      await tester.pumpAndSettle();

      expect(find.text('Black Nike T-Shirt'), findsOneWidget);
      expect(find.text('1 of 2'), findsOneWidget);
      expect(scrollable.position.pixels, greaterThan(0));
    },
  );

  testWidgets('next-item affordance advances the stack', (tester) async {
    await pumpDeck(tester, items: [shirt, jeans, sneakers]);

    await tester.tap(find.byKey(ItemSwipeDeck.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Blue jeans'), findsOneWidget);
    expect(find.text('2 of 3'), findsOneWidget);
  });

  testWidgets('tap card and view-details open the current item', (
    tester,
  ) async {
    final opened = <Item>[];
    await pumpDeck(tester, items: [shirt, jeans], onOpen: opened.add);

    await tester.tap(find.byKey(ItemSwipeCard.cardKey(shirt.id)));
    await tester.pumpAndSettle();
    expect(opened.single.id, shirt.id);

    await tester.tap(find.byKey(ItemSwipeDeck.openButtonKey));
    await tester.pumpAndSettle();
    expect(opened, hasLength(2));
    expect(opened.last.id, shirt.id);
  });

  testWidgets(
    'delete controls appear for PROCESSING items and invoke callback',
    (tester) async {
      final deleted = <Item>[];
      await pumpDeck(tester, items: [sneakers], onDelete: deleted.add);

      expect(find.byKey(ItemSwipeCard.deleteKey(sneakers.id)), findsOneWidget);
      expect(find.byKey(ItemSwipeDeck.removeButtonKey), findsOneWidget);
      expect(find.text('Processing'), findsNothing);

      await tester.tap(find.byKey(ItemSwipeDeck.removeButtonKey));
      await tester.pumpAndSettle();
      expect(deleted.single.id, sneakers.id);

      deleted.clear();
      await tester.tap(find.byKey(ItemSwipeCard.deleteKey(sneakers.id)));
      await tester.pumpAndSettle();
      expect(deleted.single.id, sneakers.id);
    },
  );

  testWidgets('end of stack shows a reset affordance', (tester) async {
    await pumpDeck(tester, items: [shirt, jeans]);

    await tester.tap(find.byKey(ItemSwipeDeck.nextButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemSwipeDeck.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(ItemSwipeDeck.endKey), findsOneWidget);
    expect(find.text('No more items'), findsOneWidget);
    expect(find.byKey(ItemSwipeDeck.resetButtonKey), findsOneWidget);

    await tester.tap(find.byKey(ItemSwipeDeck.resetButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Black Nike T-Shirt'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
  });

  testWidgets('rebuilding with a filtered list resets to the filtered deck', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var items = [shirt, jeans, sneakers];
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ItemSwipeDeck(items: items, onOpenItem: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 of 3'), findsOneWidget);

    items = [jeans];
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ItemSwipeDeck(items: items, onOpenItem: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Blue jeans'), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsNothing);
    expect(find.byKey(ItemSwipeDeck.swipeHintKey), findsNothing);
    expect(find.byKey(ItemSwipeDeck.nextButtonKey), findsNothing);
  });
}
