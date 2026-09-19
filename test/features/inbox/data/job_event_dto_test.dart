import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/inbox/data/job_event_dtos.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';

void main() {
  group('JobEventResponse (WARDROBE-114)', () {
    test('parses item READY and omits unused fields', () {
      final json = {
        'eventId': 'evt_item_item_xyz123_READY',
        'jobType': 'PROCESS_WARDROBE_ITEM',
        'status': 'READY',
        'wardrobeId': 'wd_abc123',
        'itemId': 'item_xyz123',
        'createdAt': '2026-09-19T10:00:00.000Z',
      };

      final event = JobEventResponse.fromJson(json).toDomain();
      expect(event.eventId, 'evt_item_item_xyz123_READY');
      expect(event.jobType, JobEventType.processWardrobeItem);
      expect(event.status, JobEventStatus.ready);
      expect(event.itemId, 'item_xyz123');
      expect(event.outfitId, isNull);
      expect(event.error, isNull);
      expect(event.acknowledgedAt, isNull);

      final encoded = JobEventResponse.fromJson(json).toJson();
      expect(encoded.containsKey('outfitId'), isFalse);
      expect(encoded.containsKey('error'), isFalse);
      expect(encoded.containsKey('acknowledgedAt'), isFalse);
    });

    test('parses try-on FAILED with error copy', () {
      final json = {
        'eventId': 'evt_render_rend_abc123_FAILED',
        'jobType': 'RENDER_OUTFIT',
        'status': 'FAILED',
        'wardrobeId': 'wd_abc123',
        'outfitId': 'outfit_qwerty12',
        'renderId': 'rend_abc123xyz0',
        'aiProfileId': 'profile_generic_01',
        'error': 'Gemini blocked the try-on request (SAFETY)',
        'createdAt': '2026-09-19T09:55:00.000Z',
      };

      final event = JobEventResponse.fromJson(json).toDomain();
      expect(event.jobType, JobEventType.renderOutfit);
      expect(event.status, JobEventStatus.failed);
      expect(event.error, 'Gemini blocked the try-on request (SAFETY)');
      expect(event.itemId, isNull);
    });

    test('list envelope maps unreadCount', () {
      final page = JobEventListResponse.fromJson({
        'events': [
          {
            'eventId': 'evt_item_item_xyz123_READY',
            'jobType': 'PROCESS_WARDROBE_ITEM',
            'status': 'READY',
            'wardrobeId': 'wd_abc123',
            'itemId': 'item_xyz123',
            'createdAt': '2026-09-19T10:00:00.000Z',
          },
        ],
        'unreadCount': 1,
      }).toDomain();

      expect(page.events, hasLength(1));
      expect(page.unreadCount, 1);
    });

    test('ack batch request serializes eventIds', () {
      expect(const AckEventsRequest(eventIds: ['evt_1', 'evt_2']).toJson(), {
        'eventIds': ['evt_1', 'evt_2'],
      });
    });
  });
}
