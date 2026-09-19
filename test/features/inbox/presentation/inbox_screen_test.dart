import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';
import 'package:wardrobe_app/features/inbox/presentation/inbox_screen.dart';
import 'package:wardrobe_app/features/inbox/presentation/widgets/inbox_badge_button.dart';
import 'package:wardrobe_app/features/inbox/presentation/widgets/inbox_event_tile.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_job_event_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';
import '../../../helpers/fake_wardrobe_repository.dart';
import '../../../helpers/inbox_test_overrides.dart';
import '../../../helpers/test_app.dart';

void main() {
  late FakeJobEventRepository events;

  setUp(() {
    events = FakeJobEventRepository();
  });

  Future<void> pumpInbox(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.inbox,
      routes: [
        GoRoute(
          path: AppRoutes.inbox,
          builder: (context, state) => const InboxScreen(),
        ),
        GoRoute(
          path: AppRoutes.itemDetail('wd_abc123', 'item_xyz123'),
          builder: (context, state) => const Scaffold(
            key: Key('inbox_item_dest'),
            body: Text('Item dest'),
          ),
        ),
        GoRoute(
          path: AppRoutes.tryOn('wd_abc123', 'outfit_123'),
          builder: (context, state) => const Scaffold(
            key: Key('inbox_try_on_dest'),
            body: Text('Try-on dest'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: inboxTestOverrides(events: events),
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty inbox shows a refreshable empty state', (tester) async {
    await pumpInbox(tester);

    expect(find.byType(InboxScreen), findsOneWidget);
    expect(find.byKey(InboxScreen.emptyStateKey), findsOneWidget);
    expect(find.text('No processing updates'), findsOneWidget);
    expect(find.textContaining('Pull to refresh'), findsOneWidget);
  });

  testWidgets('unavailable contract still offers refresh', (tester) async {
    events.contractUnavailable = true;
    await pumpInbox(tester);

    expect(find.text('No updates yet'), findsOneWidget);
    expect(find.byKey(InboxScreen.emptyRefreshKey), findsOneWidget);
  });

  testWidgets('READY and FAILED rows show success and error copy', (
    tester,
  ) async {
    events.events.addAll([
      testJobEvent(),
      testTryOnEvent(
        status: JobEventStatus.failed,
        error: 'Gemini blocked the try-on request (SAFETY)',
      ),
    ]);
    await pumpInbox(tester);

    expect(find.text('Item ready'), findsOneWidget);
    expect(find.text('Try-on failed'), findsOneWidget);
    expect(
      find.text('Gemini blocked the try-on request (SAFETY)'),
      findsOneWidget,
    );
  });

  testWidgets('tap opens item detail and acks the event', (tester) async {
    events.events.add(testJobEvent());
    await pumpInbox(tester);

    await tester.tap(find.text('Item ready'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inbox_item_dest')), findsOneWidget);
    expect(events.ackCalls, 1);
  });

  testWidgets('try-on row opens the render route', (tester) async {
    events.events.add(testTryOnEvent());
    await pumpInbox(tester);

    await tester.tap(find.text('Try-on ready'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inbox_try_on_dest')), findsOneWidget);
    expect(events.ackCalls, 1);
  });

  testWidgets('dismiss acks without navigating', (tester) async {
    events.events.add(testJobEvent());
    await pumpInbox(tester);

    await tester.tap(
      find.byKey(InboxEventTile.dismissKey(events.events.single.eventId)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(InboxScreen), findsOneWidget);
    expect(find.text('Item ready'), findsNothing);
    expect(events.ackCalls, 1);
  });

  testWidgets('home badge opens the inbox from Wardrobes', (tester) async {
    events.events.add(testJobEvent());
    final harness = TestAppHarness(
      wardrobes: FakeWardrobeRepository(seed: [testWardrobe()]),
      items: FakeItemRepository(seed: [testItem()]),
      outfits: FakeOutfitRepository(seed: [testOutfit()]),
      inbox: events,
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.byKey(InboxBadgeButton.buttonKey), findsOneWidget);
    expect(find.byKey(InboxBadgeButton.badgeKey), findsOneWidget);
    await tester.tap(find.byKey(InboxBadgeButton.buttonKey));
    await tester.pumpAndSettle();

    expect(find.byType(InboxScreen), findsOneWidget);
    expect(find.text('Item ready'), findsOneWidget);
  });
}
