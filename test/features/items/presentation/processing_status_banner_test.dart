import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/processing_status_chip.dart';

void main() {
  Future<void> pumpBanner(
    WidgetTester tester, {
    required ItemProcessingStatus status,
    String? processingError,
    VoidCallback? onRetry,
    bool reduceMotion = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light().copyWith(platform: TargetPlatform.iOS),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: reduceMotion),
            child: child!,
          );
        },
        home: Scaffold(
          body: ProcessingStatusBanner(
            status: status,
            processingError: processingError,
            onRetry: onRetry,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('FAILED banner shows processingError and a burgundy retry CTA', (
    tester,
  ) async {
    var taps = 0;
    await pumpBanner(
      tester,
      status: ItemProcessingStatus.failed,
      processingError: 'Background removal failed.',
      onRetry: () => taps++,
    );

    expect(find.byType(ProcessingStatusBanner), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Background removal failed.'), findsOneWidget);
    expect(find.byKey(ProcessingStatusBanner.retryButtonKey), findsOneWidget);

    final button = tester.widget<FilledButton>(
      find.byKey(ProcessingStatusBanner.retryButtonKey),
    );
    expect(button.style?.backgroundColor?.resolve({}) ?? true, isNotNull);

    await tester.tap(find.byKey(ProcessingStatusBanner.retryButtonKey));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('PENDING banner has no retry CTA', (tester) async {
    await pumpBanner(tester, status: ItemProcessingStatus.pending);

    expect(find.text('Pending'), findsOneWidget);
    expect(find.byKey(ProcessingStatusBanner.retryButtonKey), findsNothing);
  });

  testWidgets('reduced motion still shows the failed retry banner', (
    tester,
  ) async {
    await pumpBanner(
      tester,
      status: ItemProcessingStatus.failed,
      processingError: 'Classifier unavailable.',
      onRetry: () {},
      reduceMotion: true,
    );

    expect(
      AppMotion.reduce(tester.element(find.byType(ProcessingStatusBanner))),
      isTrue,
    );
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
