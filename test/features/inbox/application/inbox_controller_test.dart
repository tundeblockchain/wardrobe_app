import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/inbox/application/inbox_controller.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_contract.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_job_event_repository.dart';
import '../../../helpers/inbox_test_overrides.dart';

void main() {
  late FakeJobEventRepository events;
  late ProviderContainer container;

  setUp(() {
    events = FakeJobEventRepository();
    container = ProviderContainer.test(
      overrides: [...inboxTestOverrides(events: events)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads unread events newest first', () async {
    events.events.addAll([
      testJobEvent(),
      testTryOnEvent(
        status: JobEventStatus.failed,
        error: 'blocked',
      ).copyWith(createdAt: DateTime.utc(2026, 9, 19, 10, 5)),
    ]);

    await container.read(inboxControllerProvider.notifier).refresh();
    await settle();

    final state = container.read(inboxControllerProvider);
    expect(events.listCalls, 1);
    expect(events.lastUnreadOnly, isTrue);
    expect(state.events, hasLength(2));
    expect(state.unreadCount, 2);
    expect(state.events.first.jobType, JobEventType.renderOutfit);
  });

  test('404 list is an empty refreshable inbox', () async {
    events.contractUnavailable = true;

    await container.read(inboxControllerProvider.notifier).refresh();

    final state = container.read(inboxControllerProvider);
    expect(state.contractUnavailable, isTrue);
    expect(state.isEmpty, isTrue);
    expect(state.errorMessage, isNull);
  });

  test('ack on open removes the unread row', () async {
    events.events.add(testJobEvent());
    await container.read(inboxControllerProvider.notifier).refresh();

    await container
        .read(inboxControllerProvider.notifier)
        .open(events.events.single);

    expect(events.ackCalls, 1);
    expect(container.read(inboxControllerProvider).events, isEmpty);
    expect(container.read(inboxControllerProvider).unreadCount, 0);
  });

  test(
    'dismiss acks a server row and drops local PENDING without ack',
    () async {
      events.events.add(testJobEvent());
      await container.read(inboxControllerProvider.notifier).refresh();
      container
          .read(inboxControllerProvider.notifier)
          .trackPendingItem(
            testItem(processingStatus: ItemProcessingStatus.pending),
          );

      expect(container.read(inboxControllerProvider).pending, hasLength(1));

      await container
          .read(inboxControllerProvider.notifier)
          .dismiss(container.read(inboxControllerProvider).pending.single);
      expect(container.read(inboxControllerProvider).pending, isEmpty);
      expect(events.ackCalls, 0);

      await container
          .read(inboxControllerProvider.notifier)
          .dismiss(container.read(inboxControllerProvider).events.single);
      expect(events.ackCalls, 1);
    },
  );

  test('local PENDING is replaced when the matching event arrives', () async {
    container
        .read(inboxControllerProvider.notifier)
        .trackPendingItem(
          testItem(processingStatus: ItemProcessingStatus.pending),
        );
    events.events.add(testJobEvent(itemId: 'item_xyz123'));

    await container.read(inboxControllerProvider.notifier).refresh();

    final state = container.read(inboxControllerProvider);
    expect(state.pending, isEmpty);
    expect(state.events.single.status, JobEventStatus.ready);
    expect(state.visibleEvents, hasLength(1));
  });

  test('trackPendingRender keeps a try-on tray row', () {
    container
        .read(inboxControllerProvider.notifier)
        .trackPendingRender(
          wardrobeId: 'wd_abc123',
          outfitId: 'outfit_123',
          render: const OutfitRender(
            status: OutfitRenderStatus.pending,
            aiProfileId: 'profile_generic_01',
          ),
        );

    final row = container.read(inboxControllerProvider).pending.single;
    expect(row.isLocalPending, isTrue);
    expect(row.jobType, JobEventType.renderOutfit);
    expect(row.status, JobEventStatus.pending);
  });

  test('ready items do not create a silent PENDING row', () {
    container
        .read(inboxControllerProvider.notifier)
        .trackPendingItem(testItem());
    expect(container.read(inboxControllerProvider).pending, isEmpty);
  });

  test('unknown single ack drops the row', () async {
    events.events.add(testJobEvent());
    await container.read(inboxControllerProvider.notifier).refresh();
    events.events.clear();
    events.nextFailure = const ApiException(
      message: 'Event not found.',
      code: InboxContract.eventNotFound,
      statusCode: 404,
    );

    await container
        .read(inboxControllerProvider.notifier)
        .acknowledge('evt_item_item_xyz123_READY');

    expect(container.read(inboxControllerProvider).events, isEmpty);
  });

  test('applyPushData merges a deep-link payload', () {
    container.read(inboxControllerProvider.notifier).applyPushData({
      'eventId': 'evt_item_item_xyz123_READY',
      'jobType': 'PROCESS_WARDROBE_ITEM',
      'status': 'READY',
      'wardrobeId': 'wd_abc123',
      'itemId': 'item_xyz123',
    });

    expect(container.read(inboxControllerProvider).events, hasLength(1));
    expect(container.read(inboxControllerProvider).unreadCount, 1);
  });
}
