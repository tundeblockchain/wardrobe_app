import 'job_event.dart';

/// User-facing inbox titles and details. Never includes secrets.
abstract final class InboxCopy {
  static const screenTitle = 'Processing';

  static const emptyTitle = 'No processing updates';

  static const emptyMessage =
      'When an item or try-on finishes, it shows up here. Pull to refresh.';

  static const unavailableTitle = 'No updates yet';

  static const unavailableMessage =
      'Processing updates appear here when they are ready. Pull to refresh.';

  static const refreshLabel = 'Refresh';

  static const dismissTooltip = 'Dismiss';

  static const accountTileTitle = 'Processing';

  static const accountTileSubtitle = 'Item and try-on updates';

  static const homeTooltip = 'Processing';

  static String titleFor(JobEvent event) {
    switch (event.status) {
      case JobEventStatus.ready:
        return event.isTryOnJob ? 'Try-on ready' : 'Item ready';
      case JobEventStatus.failed:
        return event.isTryOnJob ? 'Try-on failed' : 'Item processing failed';
      case JobEventStatus.pending:
        return event.isTryOnJob
            ? 'Try-on still processing'
            : 'Item still processing';
      case JobEventStatus.unknown:
        return event.jobType.label;
    }
  }

  static String detailFor(JobEvent event) {
    if (event.status.isFailed) {
      final trimmed = event.error?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
      return event.isTryOnJob
          ? 'Try-on failed. Open the outfit to try again.'
          : 'Processing failed. Open the item for details.';
    }
    if (event.status.isPending) {
      return event.isTryOnJob
          ? 'Still working on this look. Pull to refresh.'
          : 'Still working on this item. Pull to refresh.';
    }
    if (event.status.isReady) {
      return event.isTryOnJob
          ? 'Your try-on is ready to view.'
          : 'This item is ready to use.';
    }
    return 'Open to view this update.';
  }

  static String unreadSubtitle(int unreadCount) {
    if (unreadCount <= 0) {
      return accountTileSubtitle;
    }
    if (unreadCount == 1) {
      return '1 unread update';
    }
    return '$unreadCount unread updates';
  }
}
