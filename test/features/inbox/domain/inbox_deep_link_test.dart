import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_deep_link.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';

import '../../../helpers/fake_job_event_repository.dart';

void main() {
  group('InboxDeepLink', () {
    test('item jobs open item detail', () {
      expect(
        InboxDeepLink.locationFor(testJobEvent()),
        AppRoutes.itemDetail('wd_abc123', 'item_xyz123'),
      );
    });

    test('try-on jobs open the outfit render route', () {
      expect(
        InboxDeepLink.locationFor(testTryOnEvent()),
        AppRoutes.tryOn('wd_abc123', 'outfit_123'),
      );
    });

    test('wardrobe-only payload opens wardrobe detail', () {
      expect(
        InboxDeepLink.locationFor(testJobEvent(itemId: null, outfitId: null)),
        AppRoutes.wardrobeDetail('wd_abc123'),
      );
    });

    test('parses all-string push data', () {
      final event = InboxDeepLink.fromPushData({
        'eventId': 'evt_item_item_xyz123_READY',
        'jobType': 'PROCESS_WARDROBE_ITEM',
        'status': 'READY',
        'wardrobeId': 'wd_abc123',
        'itemId': 'item_xyz123',
      });

      expect(event, isNotNull);
      expect(event!.jobType, JobEventType.processWardrobeItem);
      expect(event.status, JobEventStatus.ready);
      expect(event.itemId, 'item_xyz123');
      expect(
        InboxDeepLink.locationFor(event),
        AppRoutes.itemDetail('wd_abc123', 'item_xyz123'),
      );
    });

    test('ignores incomplete push data', () {
      expect(InboxDeepLink.fromPushData({'eventId': 'evt_1'}), isNull);
    });
  });
}
