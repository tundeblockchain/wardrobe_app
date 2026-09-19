import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';
import 'package:wardrobe_app/features/worn_on/presentation/widgets/outfit_worn_on_section.dart';

import '../../../helpers/fake_worn_on_repository.dart';
import '../../../helpers/worn_on_test_overrides.dart';

void main() {
  Future<void> pumpSection(
    WidgetTester tester, {
    FakeWornOnRepository? repository,
  }) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: wornOnTestOverrides(repository: repository),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: OutfitWornOnSection(
                wardrobeId: 'wd_abc123',
                outfitId: 'outfit_123',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows empty copy and mark today', (tester) async {
    await pumpSection(tester);

    expect(find.byKey(OutfitWornOnSection.sectionKey), findsOneWidget);
    expect(find.text('Worn on'), findsOneWidget);
    expect(find.text('Mark worn today'), findsOneWidget);
    expect(find.text('No worn dates yet.'), findsOneWidget);
  });

  testWidgets('mark today appends a date and unmark removes it', (
    tester,
  ) async {
    final repository = FakeWornOnRepository();
    await pumpSection(tester, repository: repository);

    await tester.tap(find.byKey(OutfitWornOnSection.markTodayKey));
    await tester.pumpAndSettle();

    expect(repository.setCalls, 1);
    expect(find.text('18 Sep 2026'), findsNothing);
    expect(find.text('19 Sep 2026'), findsOneWidget);
    expect(find.text('Worn today'), findsOneWidget);

    await tester.tap(
      find.byKey(OutfitWornOnSection.unmarkKey(DateTime.utc(2026, 9, 19))),
    );
    await tester.pumpAndSettle();

    expect(repository.removeCalls, 1);
    expect(find.text('No worn dates yet.'), findsOneWidget);
  });

  testWidgets('surfaces 400 validation copy', (tester) async {
    final repository = FakeWornOnRepository();
    await pumpSection(tester, repository: repository);
    repository.nextFailure = const ApiException(
      message: 'wornOn must be an ISO date (YYYY-MM-DD).',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );

    await tester.tap(find.byKey(OutfitWornOnSection.markTodayKey));
    await tester.pumpAndSettle();

    expect(find.text('wornOn must be an ISO date (YYYY-MM-DD).'), findsWidgets);
  });

  testWidgets('surfaces 404 outfit copy on load', (tester) async {
    final repository = FakeWornOnRepository()
      ..nextFailure = const ApiException(
        message: 'missing',
        code: 'OUTFIT_NOT_FOUND',
        statusCode: 404,
      );
    await pumpSection(tester, repository: repository);

    expect(find.text(WornOnErrors.outfitNotFound), findsOneWidget);
    expect(find.byKey(OutfitWornOnSection.retryKey), findsOneWidget);
  });
}
