import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_subcategory_field.dart';

void main() {
  testWidgets('none is a valid empty choice and does not force a token', (
    tester,
  ) async {
    String? selected = 'TSHIRT';

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Form(
            child: ItemSubcategoryField(
              category: ItemCategory.top,
              value: selected,
              onChanged: (value) => selected = value,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(ItemSubcategoryField.fieldKey), findsOneWidget);
    expect(find.text('Subcategory (optional)'), findsOneWidget);

    await tester.tap(find.byKey(ItemSubcategoryField.fieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('None').last);
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('empty subcategory is shown as None', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Form(
            child: ItemSubcategoryField(
              category: ItemCategory.top,
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('None'), findsOneWidget);
  });
}
