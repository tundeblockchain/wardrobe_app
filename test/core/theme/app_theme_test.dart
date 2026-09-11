import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/app.dart';
import 'package:wardrobe_app/core/theme/app_colors.dart';
import 'package:wardrobe_app/core/theme/app_spacing.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/theme/theme_preferences.dart';
import 'package:wardrobe_app/core/widgets/app_empty_state.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/presentation/login_screen.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_item_image_picker.dart';
import '../../helpers/fake_item_repository.dart';
import '../../helpers/fake_outfit_repository.dart';
import '../../helpers/fake_recommendation_repository.dart';
import '../../helpers/fake_upload_repository.dart';
import '../../helpers/fake_wardrobe_repository.dart';

double _contrast(Color a, Color b) {
  final light = a.computeLuminance();
  final dark = b.computeLuminance();
  final brighter = light > dark ? light : dark;
  final dimmer = light > dark ? dark : light;
  return (brighter + 0.05) / (dimmer + 0.05);
}

void _expectAaContrast(Color foreground, Color background) {
  expect(
    _contrast(foreground, background),
    greaterThanOrEqualTo(4.5),
    reason:
        'Expected AA contrast between '
        '${foreground.toARGB32().toRadixString(16)} and '
        '${background.toARGB32().toRadixString(16)}',
  );
}

void main() {
  group('AppTheme contrast', () {
    for (final entry in [
      ('light', AppColors.lightScheme()),
      ('dark', AppColors.darkScheme()),
    ]) {
      test('${entry.$1} key pairs meet WCAG AA', () {
        final scheme = entry.$2;
        _expectAaContrast(scheme.onPrimary, scheme.primary);
        _expectAaContrast(scheme.onSecondary, scheme.secondary);
        _expectAaContrast(scheme.onTertiary, scheme.tertiary);
        _expectAaContrast(scheme.onError, scheme.error);
        _expectAaContrast(scheme.onSurface, scheme.surface);
        _expectAaContrast(scheme.onPrimaryContainer, scheme.primaryContainer);
        _expectAaContrast(
          scheme.onSecondaryContainer,
          scheme.secondaryContainer,
        );
        _expectAaContrast(scheme.onTertiaryContainer, scheme.tertiaryContainer);
        _expectAaContrast(scheme.onErrorContainer, scheme.errorContainer);
        _expectAaContrast(scheme.onSurfaceVariant, scheme.surface);
      });
    }
  });

  test('light theme uses the burgundy/plum family and rounded surfaces', () {
    final theme = AppTheme.light();
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, AppColors.lightPrimary);
    expect(theme.colorScheme.secondary, AppColors.lightSecondary);
    final primaryHue = HSLColor.fromColor(AppColors.lightPrimary).hue;
    final secondaryHue = HSLColor.fromColor(AppColors.lightSecondary).hue;
    expect(
      primaryHue >= 330 || primaryHue <= 20,
      isTrue,
      reason: 'primary should be burgundy (wine red), hue=$primaryHue',
    );
    expect(
      secondaryHue,
      inInclusiveRange(300, 340),
      reason: 'secondary should be plum, hue=$secondaryHue',
    );
    expect(
      theme.floatingActionButtonTheme.backgroundColor,
      AppColors.lightSecondary,
    );
    expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
    final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
    expect(cardShape.borderRadius, AppRadii.card);
    expect(theme.appBarTheme.backgroundColor, AppColors.lightPrimary);
    expect(theme.appBarTheme.foregroundColor, AppColors.lightOnPrimary);
    expect(theme.appBarTheme.backgroundColor, isNot(theme.colorScheme.surface));
    _expectAaContrast(
      theme.appBarTheme.foregroundColor!,
      theme.appBarTheme.backgroundColor!,
    );
    expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
    expect(
      (theme.inputDecorationTheme.border! as OutlineInputBorder).borderRadius,
      AppRadii.input,
    );
  });

  test('dark AppBar uses plum-burgundy fill distinct from the surface', () {
    final theme = AppTheme.dark();
    expect(theme.appBarTheme.backgroundColor, AppColors.darkPrimaryContainer);
    expect(theme.appBarTheme.foregroundColor, AppColors.darkOnPrimaryContainer);
    expect(theme.appBarTheme.backgroundColor, isNot(theme.colorScheme.surface));
    _expectAaContrast(
      theme.appBarTheme.foregroundColor!,
      theme.appBarTheme.backgroundColor!,
    );
  });

  testWidgets('WardrobeApp applies AppTheme to auth and material chrome', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
        ],
        child: const WardrobeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.system);
    expect(materialApp.theme!.colorScheme.primary, AppColors.lightPrimary);
    expect(materialApp.theme!.colorScheme.secondary, AppColors.lightSecondary);
    expect(materialApp.darkTheme!.colorScheme.primary, AppColors.darkPrimary);
    expect(
      materialApp.darkTheme!.colorScheme.secondary,
      AppColors.darkSecondary,
    );

    final scheme = Theme.of(tester.element(find.byType(LoginScreen)))
        .colorScheme;
    expect(scheme.primary, AppColors.lightPrimary);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('WardrobeApp uses persisted dark ThemeMode and dark tokens', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          wardrobeRepositoryProvider.overrideWithValue(
            FakeWardrobeRepository(),
          ),
          itemRepositoryProvider.overrideWithValue(FakeItemRepository()),
          outfitRepositoryProvider.overrideWithValue(FakeOutfitRepository()),
          recommendationRepositoryProvider.overrideWithValue(
            FakeRecommendationRepository(),
          ),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
          themePreferencesProvider.overrideWithValue(
            InMemoryThemePreferences(ThemeMode.dark),
          ),
        ],
        child: const WardrobeApp(),
      ),
    );
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);

    final scheme = Theme.of(tester.element(find.byType(LoginScreen)))
        .colorScheme;
    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, AppColors.darkPrimary);
    expect(scheme.secondary, AppColors.darkSecondary);
  });

  testWidgets('empty state and chips follow the color scheme', (tester) async {
    late ColorScheme scheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            scheme = Theme.of(context).colorScheme;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: [
                  AppEmptyState(
                    icon: Icons.checkroom_outlined,
                    title: 'No wardrobes yet',
                    message: 'Create a wardrobe to get started.',
                    actionLabel: 'Create wardrobe',
                    onAction: () {},
                  ),
                  const Card(child: Text('Look')),
                  const Chip(label: Text('Ready')),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('No wardrobes yet'), findsOneWidget);
    expect(find.text('Create wardrobe'), findsOneWidget);

    final theme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(theme.colorScheme.primary, scheme.primary);
    expect(theme.floatingActionButtonTheme.backgroundColor, scheme.secondary);
    expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
  });
}
