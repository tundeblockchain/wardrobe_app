import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/features/items/domain/item_transfer.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_transfer_sheet.dart';

import '../../../helpers/fake_wardrobe_repository.dart';

void main() {
  testWidgets('picker lists other wardrobes and skips fade when reduced', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ItemTransferSheet(
              kind: ItemTransferKind.move,
              destinations: [testWardrobe(id: 'wd_other12ab', name: 'Winter')],
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(ItemTransferSheet.sheetKey), findsOneWidget);
    expect(find.text('Move to another wardrobe'), findsOneWidget);
    expect(find.text('Winter'), findsOneWidget);
    expect(
      find.byKey(ItemTransferSheet.destinationKey('wd_other12ab')),
      findsOneWidget,
    );
    expect(find.byType(AppFadeIn), findsNothing);
  });

  testWidgets('empty destinations show a create-another-wardrobe CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: ItemTransferSheet(
            kind: ItemTransferKind.copy,
            destinations: [],
          ),
        ),
      ),
    );

    expect(find.byKey(ItemTransferSheet.emptyKey), findsOneWidget);
    expect(find.text(ItemTransferMessages.noDestinations), findsOneWidget);
    expect(find.text('Copy to another wardrobe'), findsOneWidget);
  });

  testWidgets('selecting a wardrobe then confirming returns the pick', (
    tester,
  ) async {
    ItemTransferPick? pick;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  pick = await ItemTransferSheet.show(
                    context,
                    kind: ItemTransferKind.copy,
                    destinations: [
                      testWardrobe(id: 'wd_other12ab', name: 'Winter'),
                    ],
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Winter'));
    await tester.pumpAndSettle();
    expect(find.text('Copy this item to Winter?'), findsOneWidget);
    await tester.tap(find.byKey(ItemTransferSheet.confirmKey));
    await tester.pumpAndSettle();

    expect(pick?.wardrobe.id, 'wd_other12ab');
  });

  testWidgets('canceling confirm does not return a destination', (
    tester,
  ) async {
    ItemTransferPick? pick = const ItemTransferPick(wardrobe: _placeholder);
    var resolved = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  pick = await ItemTransferSheet.show(
                    context,
                    kind: ItemTransferKind.move,
                    destinations: [
                      testWardrobe(id: 'wd_other12ab', name: 'Winter'),
                    ],
                  );
                  resolved = true;
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Winter'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemTransferSheet.cancelKey));
    await tester.pumpAndSettle();

    expect(resolved, isTrue);
    expect(pick, isNull);
  });
}

final _placeholder = testWardrobe();
