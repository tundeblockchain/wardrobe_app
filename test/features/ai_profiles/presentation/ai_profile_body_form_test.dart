import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/ai_profile_body_form.dart';

void main() {
  Future<void> pumpForm(
    WidgetTester tester, {
    AiProfileBodyContext initial = AiProfileBodyContext.empty,
    required ValueChanged<AiProfileBodyContext> onSubmit,
  }) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: AiProfileBodyForm(initial: initial, onSubmit: onSubmit),
          ),
        ),
      ),
    );
  }

  Future<void> tapSubmit(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(AiProfileBodyForm.submitButtonKey));
    await tester.tap(find.byKey(AiProfileBodyForm.submitButtonKey));
    await tester.pump();
  }

  testWidgets('empty fields submit without blocking', (tester) async {
    AiProfileBodyContext? submitted;
    await pumpForm(tester, onSubmit: (value) => submitted = value);

    expect(find.byKey(AiProfileBodyForm.optionalBannerKey), findsOneWidget);
    expect(find.textContaining('never block try-on'), findsOneWidget);

    await tapSubmit(tester);

    expect(submitted, AiProfileBodyContext.empty);
  });

  testWidgets('out-of-range height is rejected', (tester) async {
    AiProfileBodyContext? submitted;
    await pumpForm(tester, onSubmit: (value) => submitted = value);

    await tester.enterText(find.byKey(AiProfileBodyForm.heightFieldKey), '12');
    await tapSubmit(tester);

    expect(find.textContaining('Height must be between'), findsOneWidget);
    expect(submitted, isNull);
  });

  testWidgets('valid fields map onto WARDROBE-80 names', (tester) async {
    AiProfileBodyContext? submitted;
    await pumpForm(tester, onSubmit: (value) => submitted = value);

    await tester.enterText(find.byKey(AiProfileBodyForm.heightFieldKey), '170');
    await tester.enterText(find.byKey(AiProfileBodyForm.ageFieldKey), '28');
    await tester.enterText(find.byKey(AiProfileBodyForm.bustFieldKey), '90');
    await tester.enterText(find.byKey(AiProfileBodyForm.hipsFieldKey), '100');
    await tester.enterText(find.byKey(AiProfileBodyForm.sizeFieldKey), 'M');
    await tester.enterText(find.byKey(AiProfileBodyForm.weightFieldKey), '65');
    await tapSubmit(tester);

    expect(
      submitted,
      const AiProfileBodyContext(
        height: 170,
        age: 28,
        bust: 90,
        hips: 100,
        size: 'M',
        weight: 65,
      ),
    );
  });

  testWidgets('prefills existing body context', (tester) async {
    await pumpForm(
      tester,
      initial: const AiProfileBodyContext(height: 168, size: '10'),
      onSubmit: (_) {},
    );

    expect(find.text('168'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
}
