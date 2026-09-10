import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/enlarged_image_popup.dart';

void main() {
  testWidgets('shows the full image with contain framing and closes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => EnlargedImagePopup.show(
                context,
                image: const ColoredBox(
                  color: Colors.red,
                  child: SizedBox.expand(),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(EnlargedImagePopup.dialogKey), findsOneWidget);
    expect(find.byKey(EnlargedImagePopup.imageSlotKey), findsOneWidget);

    await tester.tap(find.byKey(EnlargedImagePopup.closeKey));
    await tester.pumpAndSettle();
    expect(find.byKey(EnlargedImagePopup.dialogKey), findsNothing);
  });
}
