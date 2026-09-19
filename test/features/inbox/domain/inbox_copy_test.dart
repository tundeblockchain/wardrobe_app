import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_copy.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';

import '../../../helpers/fake_job_event_repository.dart';

void main() {
  test('READY and FAILED use success and error copy', () {
    expect(InboxCopy.titleFor(testJobEvent()), 'Item ready');
    expect(
      InboxCopy.titleFor(testTryOnEvent(status: JobEventStatus.failed)),
      'Try-on failed',
    );
    expect(
      InboxCopy.detailFor(
        testTryOnEvent(
          status: JobEventStatus.failed,
          error: 'Gemini blocked the try-on request (SAFETY)',
        ),
      ),
      'Gemini blocked the try-on request (SAFETY)',
    );
  });

  test('PENDING rows tell the user to refresh', () {
    final pending = testJobEvent(
      status: JobEventStatus.pending,
      isLocalPending: true,
    );
    expect(InboxCopy.titleFor(pending), 'Item still processing');
    expect(InboxCopy.detailFor(pending), contains('Pull to refresh'));
  });

  test('unread subtitle stays clear when empty', () {
    expect(InboxCopy.unreadSubtitle(0), InboxCopy.accountTileSubtitle);
    expect(InboxCopy.unreadSubtitle(1), '1 unread update');
    expect(InboxCopy.unreadSubtitle(3), '3 unread updates');
  });
}
