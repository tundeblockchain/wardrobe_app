import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/presentation/item_detail_screen.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_item_repository.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemRepositoryProvider.overrideWithValue(
            FakeItemRepository(seed: [testItem()]),
          ),
        ],
        child: const MaterialApp(
          home: ItemDetailScreen(
            wardrobeId: 'wd_abc123',
            itemId: 'item_xyz123',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('item detail does not show Added or Updated datestamps', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(ItemDetailScreen), findsOneWidget);
    expect(find.text('Black Nike T-Shirt'), findsWidgets);
    expect(find.text('Top'), findsOneWidget);
    expect(find.text('Nike'), findsOneWidget);
    expect(find.byType(ProcessingStatusBanner), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.editButtonKey), findsOneWidget);
    expect(find.byKey(ItemDetailScreen.deleteButtonKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });
}
