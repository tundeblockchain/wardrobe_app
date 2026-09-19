import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/share/application/share_controller.dart';
import 'package:wardrobe_app/features/share/domain/share_errors.dart';
import 'package:wardrobe_app/features/share/presentation/widgets/share_action_button.dart';

import '../../../helpers/fake_share_repository.dart';
import '../../../helpers/fake_share_sheet.dart';
import '../../../helpers/share_test_overrides.dart';

void main() {
  const buttonKey = Key('share_cta');

  Future<void> pumpButton(
    WidgetTester tester, {
    FakeShareRepository? repository,
    FakeShareSheet? sheet,
    String landingBaseUrl = testShareLandingBaseUrl,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: shareTestOverrides(
          repository: repository ?? FakeShareRepository(),
          sheet: sheet ?? FakeShareSheet(),
          landingBaseUrl: landingBaseUrl,
        ),
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  actions: [
                    ShareActionButton(
                      key: buttonKey,
                      onShare: (origin) => ref
                          .read(shareControllerProvider.notifier)
                          .shareItem(
                            wardrobeId: 'wd_abc123',
                            itemId: 'item_xyz123',
                            title: 'Black Nike T-Shirt',
                            origin: origin,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('share button opens the sheet on success', (tester) async {
    final repository = FakeShareRepository();
    final sheet = FakeShareSheet();
    await pumpButton(tester, repository: repository, sheet: sheet);

    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();

    expect(repository.createItemCalls, 1);
    expect(sheet.payloads, hasLength(1));
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('missing env shows a snackbar and skips the sheet', (
    tester,
  ) async {
    final repository = FakeShareRepository();
    final sheet = FakeShareSheet();
    await pumpButton(
      tester,
      repository: repository,
      sheet: sheet,
      landingBaseUrl: '',
    );

    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();

    expect(repository.createItemCalls, 0);
    expect(sheet.payloads, isEmpty);
    expect(find.text(ShareErrors.missingLandingBase), findsOneWidget);
  });

  testWidgets('reduce-motion still shows the share icon', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: shareTestOverrides(),
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(actions: [ShareActionButton(onShare: _noopShare)]),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ShareActionButton), findsOneWidget);
    expect(find.byIcon(Icons.ios_share_outlined), findsOneWidget);
  });
}

Future<void> _noopShare(Rect? origin) async {}
