import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/core/widgets/type_to_confirm_dialog.dart';

void main() {
  testWidgets('destructive confirm cancel does not confirm', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await DestructiveConfirmDialog.show(
                  context,
                  title: 'Delete wardrobe?',
                  message: 'This cannot be undone.',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Delete wardrobe?'), findsOneWidget);

    await tester.tap(find.byKey(DestructiveConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(result, isFalse);
    expect(find.text('Delete wardrobe?'), findsNothing);
  });

  testWidgets('destructive confirm delete returns true', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await DestructiveConfirmDialog.show(
                  context,
                  title: 'Delete item?',
                  message: 'This cannot be undone.',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('type-to-confirm stays disabled until the phrase matches', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await TypeToConfirmDialog.show(
                  context,
                  title: 'Clear all content?',
                  message: 'Wipe everything.',
                  phrase: 'CLEAR',
                  confirmLabel: 'Clear all',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final confirm = tester.widget<FilledButton>(
      find.byKey(TypeToConfirmDialog.confirmButtonKey),
    );
    expect(confirm.onPressed, isNull);

    await tester.enterText(
      find.byKey(TypeToConfirmDialog.phraseFieldKey),
      'nope',
    );
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(TypeToConfirmDialog.confirmButtonKey),
          )
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(TypeToConfirmDialog.phraseFieldKey),
      'clear',
    );
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(TypeToConfirmDialog.confirmButtonKey),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byKey(TypeToConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('type-to-confirm cancel does not confirm', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await TypeToConfirmDialog.show(
                  context,
                  title: 'Delete your account?',
                  message: 'Gone forever.',
                  phrase: 'DELETE',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TypeToConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
