import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/presentation/outfits_screen.dart';

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
    expectNoCreatedUpdatedDateStamps();
  });
}
