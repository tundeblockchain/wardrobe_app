/// Locked WARDROBE-114 HTTP contract (wardrobe-backend#53 SHA `0d75d71`).
///
/// Inbox works without FCM. Optional `PUT /me/devices` only registers a push
/// token when Firebase Messaging is configured.
abstract final class InboxContract {
  static const eventsPath = '/me/events';
  static const ackBatchPath = '/me/events/ack';
  static const devicesPath = '/me/devices';

  static String ackPath(String eventId) => '/me/events/$eventId/ack';

  static String devicePath(String deviceId) => '/me/devices/$deviceId';

  static const unreadOnlyQuery = 'unreadOnly';
  static const limitQuery = 'limit';

  static const defaultUnreadOnly = true;
  static const defaultLimit = 20;
  static const maxLimit = 50;

  static const eventNotFound = 'EVENT_NOT_FOUND';
  static const validationError = 'VALIDATION_ERROR';

  static int clampLimit(int value) => value.clamp(1, maxLimit);

  static Map<String, dynamic> listQueryParameters({
    bool unreadOnly = defaultUnreadOnly,
    int limit = defaultLimit,
  }) {
    return {
      unreadOnlyQuery: unreadOnly ? 'true' : 'false',
      limitQuery: '${clampLimit(limit)}',
    };
  }
}
