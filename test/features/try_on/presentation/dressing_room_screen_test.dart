import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/try_on/presentation/dressing_room_screen.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  late FakeOutfitRepository outfits;

  setUp(() {
    outfits = FakeOutfitRepository();
  });

  Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AppRoutes.dressingRoom('wd_abc123'),
      routes: [
        GoRoute(
          path: AppRoutes.dressingRoom('wd_abc123'),
          builder: (context, state) =>
              const DressingRoomScreen(wardrobeId: 'wd_abc123'),
        ),
        GoRoute(
          path: AppRoutes.tryOn('wd_abc123', 'outfit_123'),
          builder: (context, state) => const Scaffold(body: Text('Try-on')),
        ),
        GoRoute(
          path: AppRoutes.createOutfit('wd_abc123'),
          builder: (context, state) => const Scaffold(body: Text('Create')),
        ),
        GoRoute(
          path: AppRoutes.aiTryOn,
          builder: (context, state) => const Scaffold(body: Text('Profiles')),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [outfitRepositoryProvider.overrideWithValue(outfits)],
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

  testWidgets('empty wardrobe shows create-outfit empty state', (tester) async {
    await pumpScreen(tester);

    expect(find.byKey(DressingRoomScreen.emptyStateKey), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
    expect(find.text('No outfits yet'), findsOneWidget);
    expect(find.text('No AI profile selected'), findsOneWidget);
  });

  testWidgets('lists outfits and opens try-on', (tester) async {
    outfits.outfits.add(testOutfit());
    final container = await pumpScreen(tester);
    container
        .read(selectedAiProfileProvider.notifier)
        .select(testGenericModel());
    await tester.pumpAndSettle();

    expect(find.text('Selected: Alex'), findsOneWidget);
    expect(
      find.byKey(const Key('dressing_room_outfit_outfit_123')),
      findsOneWidget,
    );
    expectNoCreatedUpdatedDateStamps();

    await tester.tap(find.byKey(const Key('dressing_room_outfit_outfit_123')));
    await tester.pumpAndSettle();

    expect(find.text('Try-on'), findsOneWidget);
  });
}
