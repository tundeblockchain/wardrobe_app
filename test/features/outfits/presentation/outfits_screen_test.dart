import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfits_screen.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_list_tile.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  Future<void> pumpList(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          outfitRepositoryProvider.overrideWithValue(
            FakeOutfitRepository(seed: [testOutfit()]),
          ),
        ],
        child: const MaterialApp(home: OutfitsScreen(wardrobeId: 'wd_abc123')),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('outfit list does not show Created or Updated datestamps', (
    tester,
  ) async {
    await pumpList(tester);

    expect(find.byType(OutfitsScreen), findsOneWidget);
    expect(find.text('Friday Night'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);
    expect(find.byKey(OutfitsScreen.createButtonKey), findsOneWidget);
    expect(find.byKey(OutfitListTile.deleteKey('outfit_123')), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
  });

  testWidgets('outfit list delete confirm removes the row', (tester) async {
    final repository = FakeOutfitRepository(seed: [testOutfit()]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: ScaffoldMessenger(
            child: OutfitsScreen(wardrobeId: 'wd_abc123'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OutfitListTile.deleteKey('outfit_123')));
    await tester.pumpAndSettle();
    expect(find.text('Delete outfit?'), findsOneWidget);

    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 1);
    expect(find.byKey(OutfitsScreen.emptyStateKey), findsOneWidget);
    expect(find.text('Friday Night'), findsNothing);
  });

  testWidgets('outfit list delete cancel does not call DELETE', (tester) async {
    final repository = FakeOutfitRepository(seed: [testOutfit()]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: OutfitsScreen(wardrobeId: 'wd_abc123')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OutfitListTile.deleteKey('outfit_123')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.cancelButtonKey));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 0);
    expect(find.text('Friday Night'), findsOneWidget);
  });

  testWidgets('outfit list delete error keeps the row and shows a snackbar', (
    tester,
  ) async {
    final repository = FakeOutfitRepository(seed: [testOutfit()]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [outfitRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: ScaffoldMessenger(
            child: OutfitsScreen(wardrobeId: 'wd_abc123'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    repository.nextFailure = const ApiException(
      message: 'Outfit not found.',
      code: 'OUTFIT_NOT_FOUND',
    );

    await tester.tap(find.byKey(OutfitListTile.deleteKey('outfit_123')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 1);
    expect(find.text('Friday Night'), findsOneWidget);
    expect(find.text('Outfit not found.'), findsWidgets);
  });
}
