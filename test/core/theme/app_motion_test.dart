import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_motion.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_empty_state.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/core/widgets/app_gloss.dart';
import 'package:wardrobe_app/core/widgets/app_sheen.dart';
import 'package:wardrobe_app/core/widgets/app_sparkle.dart';

Widget _withReducedMotion(Widget home, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      );
    },
    home: home,
  );
}

void main() {
  group('AppMotion tokens', () {
    test('fade and page durations stay short and tasteful', () {
      expect(AppMotion.fadeDuration, const Duration(milliseconds: 240));
      expect(AppMotion.pageDuration, const Duration(milliseconds: 280));
      expect(AppMotion.sheenDuration.inMilliseconds, lessThanOrEqualTo(900));
      expect(AppMotion.sparkleDuration.inMilliseconds, lessThanOrEqualTo(1100));
      expect(AppMotion.glossHighlightLight, lessThan(0.35));
      expect(AppMotion.sheenPeakOpacity, lessThan(0.3));
      expect(AppMotion.sparklePeakOpacity, lessThan(0.7));
    });

    testWidgets('reduce is true when disableAnimations is set', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: _ReduceProbe(),
        ),
      );
      final reduced = tester
          .state<_ReduceProbeState>(find.byType(_ReduceProbe))
          .value;
      expect(reduced, isTrue);
      expect(
        AppMotion.fadeOf(tester.element(find.byType(_ReduceProbe))),
        Duration.zero,
      );
    });

    testWidgets('reduce is false by default', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(data: MediaQueryData(), child: _ReduceProbe()),
      );
      final reduced = tester
          .state<_ReduceProbeState>(find.byType(_ReduceProbe))
          .value;
      expect(reduced, isFalse);
      expect(
        AppMotion.fadeOf(tester.element(find.byType(_ReduceProbe))),
        AppMotion.fadeDuration,
      );
    });
  });

  test('theme uses the shared fade page transition on every platform', () {
    final theme = AppTheme.light();
    for (final platform in TargetPlatform.values) {
      expect(
        theme.pageTransitionsTheme.builders[platform],
        isA<AppFadePageTransitionsBuilder>(),
      );
    }
    expect(theme.filledButtonTheme.style?.backgroundBuilder, isNotNull);
  });

  testWidgets('gloss overlay does not absorb pointer events', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 120,
            child: AppGloss(
              child: GestureDetector(
                onTap: () => taps++,
                child: const ColoredBox(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    expect(taps, 1);
    expect(find.byKey(AppGlossOverlay.overlayKey), findsWidgets);
  });

  testWidgets('fade-in is instant when motion is reduced', (tester) async {
    await tester.pumpWidget(
      _withReducedMotion(
        const Scaffold(
          body: AppFadeIn(key: AppFadeIn.fadeKey, child: Text('Ready')),
        ),
      ),
    );
    expect(find.text('Ready'), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
  });

  testWidgets('fade-in animates then settles when motion is allowed', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppFadeIn(child: Text('Looks'))),
      ),
    );
    expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Looks'), findsOneWidget);
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 1);
  });

  testWidgets('sheen and sparkle skip tickers when motion is reduced', (
    tester,
  ) async {
    await tester.pumpWidget(
      _withReducedMotion(
        const Scaffold(
          body: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [AppSheenSweep(), AppSparkleAccent()],
            ),
          ),
        ),
        theme: AppTheme.light(),
      ),
    );
    await tester.pump();
    expect(find.byKey(AppSparkleAccent.sparkleKey), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('empty state keeps copy and uses shared polish', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AppEmptyState(
            icon: Icons.checkroom_outlined,
            title: 'No wardrobes yet',
            message: 'Create a wardrobe to get started.',
            actionLabel: 'Create wardrobe',
            onAction: () => pressed++,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('No wardrobes yet'), findsOneWidget);
    expect(find.text('Create wardrobe'), findsOneWidget);
    expect(find.byType(AppFadeIn), findsOneWidget);
    expect(find.byType(AppGloss), findsWidgets);
    expect(find.byType(AppSparkleAccent), findsOneWidget);
    await tester.tap(find.text('Create wardrobe'));
    expect(pressed, 1);
    await tester.pumpAndSettle();
  });

  testWidgets('gloss bar still exposes a real AppBar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: AppGlossBar(title: const Text('Wardrobes')),
          body: const SizedBox.shrink(),
        ),
      ),
    );
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppGlossBar), findsOneWidget);
    expect(find.text('Wardrobes'), findsOneWidget);
    expect(find.byKey(AppGlossOverlay.overlayKey), findsWidgets);
  });

  testWidgets('fade page builder returns child when motion is reduced', (
    tester,
  ) async {
    const builder = AppFadePageTransitionsBuilder();
    final route = MaterialPageRoute<void>(
      builder: (_) => const SizedBox.shrink(),
    );
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return builder.buildTransitions<void>(
                route,
                context,
                const AlwaysStoppedAnimation(0),
                const AlwaysStoppedAnimation(0),
                const Text('Route'),
              );
            },
          ),
        ),
      ),
    );
    expect(find.text('Route'), findsOneWidget);
    expect(find.byType(FadeTransition), findsNothing);
  });
}

class _ReduceProbe extends StatefulWidget {
  const _ReduceProbe();

  @override
  State<_ReduceProbe> createState() => _ReduceProbeState();
}

class _ReduceProbeState extends State<_ReduceProbe> {
  late bool value;

  @override
  Widget build(BuildContext context) {
    value = AppMotion.reduce(context);
    return const SizedBox.shrink();
  }
}
