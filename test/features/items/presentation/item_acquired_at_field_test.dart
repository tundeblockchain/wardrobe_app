import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at.dart';
import 'package:wardrobe_app/features/items/domain/item_detail_meta.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_acquired_at_field.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester, {
    DateTime? value,
    ValueChanged<DateTime?>? onChanged,
  }) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ItemAcquiredAtField(
            value: value,
            onChanged: onChanged ?? (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('empty field shows the placeholder', (tester) async {
    await pumpField(tester);

    expect(find.byKey(ItemAcquiredAtField.fieldKey), findsOneWidget);
    expect(find.text('Acquired / purchased (optional)'), findsOneWidget);
    expect(find.text(ItemDetailMeta.emptyPlaceholder), findsOneWidget);
  });

  testWidgets('picking a date reports a calendar day', (tester) async {
    DateTime? picked;
    await pumpField(tester, onChanged: (value) => picked = value);

    await tester.tap(find.byKey(ItemAcquiredAtField.fieldKey));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked, ItemAcquiredAt.dateOnly(picked!));
    expect(picked!.isAfter(DateTime.utc(1969, 12, 31)), isTrue);
  });

  testWidgets('clear removes the date', (tester) async {
    DateTime? current = DateTime.utc(2024, 3, 9);
    await pumpField(
      tester,
      value: current,
      onChanged: (value) => current = value,
    );

    expect(find.text('9 Mar 2024'), findsOneWidget);
    await tester.tap(find.byKey(ItemAcquiredAtField.clearButtonKey));
    await tester.pump();

    expect(current, isNull);
  });
}
