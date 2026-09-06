import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/try_on/application/try_on_poll.dart';
import 'package:wardrobe_app/features/try_on/presentation/try_on_screen.dart';
import 'package:wardrobe_app/features/try_on/presentation/widgets/try_on_result_image.dart';
import 'package:wardrobe_app/features/try_on/presentation/widgets/try_on_status_banner.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  late FakeOutfitRepository outfits;
  late FakeAiProfileRepository profiles;

  setUp(() {
    outfits = FakeOutfitRepository(seed: [testOutfit()]);
    profiles = FakeAiProfileRepository();
  });

  Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AppRoutes.tryOn('wd_abc123', 'outfit_123'),
      routes: [
        GoRoute(
          path: AppRoutes.tryOn('wd_abc123', 'outfit_123'),
          builder: (context, state) => const TryOnScreen(
            wardrobeId: 'wd_abc123',
            outfitId: 'outfit_123',
          ),
        ),
        GoRoute(
          path: AppRoutes.aiTryOn,
          builder: (context, state) => const Scaffold(body: Text('Profiles')),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        outfitRepositoryProvider.overrideWithValue(outfits),
        aiProfileRepositoryProvider.overrideWithValue(profiles),
        tryOnPollConfigProvider.overrideWithValue(
          const TryOnPollConfig(
            interval: Duration.zero,
            timeout: Duration(minutes: 1),
          ),
        ),
        tryOnDelayProvider.overrideWithValue((_) async {}),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty profile state asks the user to choose one', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.byType(TryOnScreen), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
    expect(find.byKey(TryOnScreen.profileEmptyKey), findsOneWidget);
    expect(find.text('No profile selected'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(TryOnScreen.submitButtonKey))
          .onPressed,
      isNull,
    );
  });

  testWidgets('submit polls Dio-backed repository until READY imageUrl', (
    tester,
  ) async {
    outfits.renderPollQueue.addAll([
      testOutfitRender(status: OutfitRenderStatus.processing, imageKey: null),
      testOutfitRender(),
    ]);
    final container = await pumpScreen(tester);
    container
        .read(selectedAiProfileProvider.notifier)
        .select(testGenericModel());
    await tester.pumpAndSettle();

    expect(find.byKey(TryOnScreen.selectedProfileKey), findsOneWidget);
    expect(find.text('Alex'), findsWidgets);

    await tester.tap(find.byKey(TryOnScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(outfits.requestRenderCalls, 1);
    expect(outfits.getRenderCalls, greaterThanOrEqualTo(1));
    expect(find.byType(TryOnResultImage), findsOneWidget);
    expect(
      find.byKey(
        TryOnResultImage.urlKey(
          'https://cdn.example.com/try-on/outfit_123.png',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows FAILED banner from poll error', (tester) async {
    outfits.renderPollQueue.add(
      testOutfitRender(
        status: OutfitRenderStatus.failed,
        imageKey: null,
        error: 'Gemini blocked this look.',
      ),
    );
    final container = await pumpScreen(tester);
    container
        .read(selectedAiProfileProvider.notifier)
        .select(testGenericModel());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(TryOnScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(TryOnStatusBanner), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Gemini blocked this look.'), findsOneWidget);
  });

  testWidgets('outfit load error shows retry', (tester) async {
    outfits = FakeOutfitRepository();
    await pumpScreen(tester);

    expect(find.text('Outfit not found.'), findsOneWidget);
    expect(find.byKey(TryOnScreen.retryButtonKey), findsOneWidget);
  });
}
