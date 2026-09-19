import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';
import 'package:wardrobe_app/features/worn_on/presentation/wardrobe_worn_on_screen.dart';
import 'package:wardrobe_app/features/worn_on/presentation/widgets/worn_on_month_calendar.dart';

import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_worn_on_repository.dart';
import '../../../helpers/worn_on_test_overrides.dart';

void main() {
  Future<void> pumpCalendar(
    WidgetTester tester, {
    FakeWornOnRepository? repository,
  }) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...wornOnTestOverrides(repository: repository),
          outfitRepositoryProvider.overrideWithValue(
            FakeOutfitRepository(seed: [testOutfit()]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const WardrobeWornOnScreen(wardrobeId: 'wd_abc123'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('joins outfit names onto the month list', (tester) async {
    await pumpCalendar(
      tester,
      repository: FakeWornOnRepository(seed: [testWornOnEntry()]),
    );

    expect(find.text('September 2026'), findsOneWidget);
    expect(find.byKey(WornOnMonthCalendar.gridKey), findsOneWidget);
    expect(find.text('Friday Night'), findsOneWidget);
    expect(find.text('18 Sep 2026'), findsOneWidget);
    expect(
      find.byKey(WornOnMonthCalendar.dayKey(DateTime.utc(2026, 9, 18))),
      findsOneWidget,
    );
  });

  testWidgets('empty month shows a placeholder', (tester) async {
    await pumpCalendar(tester);

    expect(find.byKey(WardrobeWornOnScreen.emptyKey), findsOneWidget);
    expect(find.text('No outfits logged'), findsOneWidget);
  });

  testWidgets('unmark removes the named row', (tester) async {
    final repository = FakeWornOnRepository(seed: [testWornOnEntry()]);
    await pumpCalendar(tester, repository: repository);

    await tester.tap(
      find.byKey(WardrobeWornOnScreen.unmarkKey(testWornOnEntry())),
    );
    await tester.pumpAndSettle();

    expect(repository.removeCalls, 1);
    expect(find.text('Friday Night'), findsNothing);
  });

  testWidgets('surfaces 401 copy on load', (tester) async {
    final repository = FakeWornOnRepository()
      ..nextFailure = const ApiException(
        message: 'Sign in.',
        code: 'UNAUTHENTICATED',
        statusCode: 401,
      );
    await pumpCalendar(tester, repository: repository);

    expect(find.text(WornOnErrors.unauthenticated), findsOneWidget);
  });
}
