import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_filter_bar.dart';

void main() {
  Future<void> pumpBar(
    WidgetTester tester, {
    ItemListFilters filters = const ItemListFilters(),
    ValueChanged<ItemListFilters>? onChanged,
  }) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ItemFilterBar(
              filters: filters,
              onChanged: onChanged ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'hide-older control starts empty and does not show Clear filters',
    (tester) async {
      await pumpBar(tester);

      expect(find.byKey(ItemFilterBar.acquiredAfterRowKey), findsOneWidget);
      expect(find.text('Hide older than'), findsOneWidget);
      expect(find.text('Choose date'), findsOneWidget);
      expect(
        find.text(
          'Items acquired before this date, and items with no acquired date, are hidden.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(ItemFilterBar.clearButtonKey), findsNothing);
    },
  );

  testWidgets('choosing a date sets acquiredAfter', (tester) async {
    ItemListFilters? next;
    await pumpBar(tester, onChanged: (filters) => next = filters);

    await tester.tap(find.byKey(ItemFilterBar.acquiredAfterButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(next?.acquiredAfter, isNotNull);
    expect(next?.acquiredAfter, ItemAcquiredAt.dateOnly(next!.acquiredAfter!));
    expect(next?.isEmpty, isFalse);
  });

  testWidgets('clearing acquiredAfter restores show-all', (tester) async {
    ItemListFilters? next;
    await pumpBar(
      tester,
      filters: ItemListFilters(acquiredAfter: DateTime.utc(2024, 1, 1)),
      onChanged: (filters) => next = filters,
    );

    expect(find.text('1 Jan 2024'), findsOneWidget);
    expect(find.byKey(ItemFilterBar.clearButtonKey), findsOneWidget);

    await tester.tap(find.byKey(ItemFilterBar.acquiredAfterClearKey));
    await tester.pump();

    expect(next?.acquiredAfter, isNull);
    expect(next?.isEmpty, isTrue);
  });
}
