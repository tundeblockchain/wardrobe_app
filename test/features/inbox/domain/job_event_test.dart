import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';

import '../../../helpers/fake_job_event_repository.dart';

void main() {
  group('JobEventType', () {
    test('parses known wire values', () {
      expect(
        JobEventType.parse('PROCESS_WARDROBE_ITEM'),
        JobEventType.processWardrobeItem,
      );
      expect(JobEventType.parse('RENDER_OUTFIT'), JobEventType.renderOutfit);
    });

    test('unknown wire values stay unknown', () {
      expect(JobEventType.parse(null), JobEventType.unknown);
      expect(JobEventType.parse('PROCESS_AI_PROFILE'), JobEventType.unknown);
    });
  });

  group('JobEventStatus', () {
    test('parses READY and FAILED', () {
      expect(JobEventStatus.parse('READY'), JobEventStatus.ready);
      expect(JobEventStatus.parse('FAILED'), JobEventStatus.failed);
      expect(JobEventStatus.parse('PENDING'), JobEventStatus.pending);
    });

    test('unknown wire values stay unknown', () {
      expect(JobEventStatus.parse('ERROR'), JobEventStatus.unknown);
    });
  });

  group('JobEvent.matchesPendingCompletion', () {
    test('matches item PENDING to the server item event', () {
      final pending = testJobEvent(
        eventId: 'local_item_item_xyz123',
        status: JobEventStatus.pending,
        isLocalPending: true,
      );
      expect(pending.matchesPendingCompletion(testJobEvent()), isTrue);
    });

    test('matches try-on PENDING by outfit and profile', () {
      final pending = testTryOnEvent().copyWith(
        eventId: 'local_render_outfit_123_profile_generic_01',
        jobStatus: JobEventStatus.pending,
        isLocalPending: true,
        clearRenderId: true,
      );
      expect(pending.matchesPendingCompletion(testTryOnEvent()), isTrue);
    });

    test('does not match a different item', () {
      final pending = testJobEvent(
        eventId: 'local_item_other',
        itemId: 'item_other',
        status: JobEventStatus.pending,
        isLocalPending: true,
      );
      expect(pending.matchesPendingCompletion(testJobEvent()), isFalse);
    });
  });
}
