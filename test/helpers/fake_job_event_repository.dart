import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_contract.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event_repository.dart';

JobEvent testJobEvent({
  String eventId = 'evt_item_item_xyz123_READY',
  JobEventType jobType = JobEventType.processWardrobeItem,
  JobEventStatus status = JobEventStatus.ready,
  String wardrobeId = 'wd_abc123',
  String? itemId = 'item_xyz123',
  String? outfitId,
  String? renderId,
  String? aiProfileId,
  String? error,
  DateTime? createdAt,
  DateTime? acknowledgedAt,
  bool isLocalPending = false,
}) {
  return JobEvent(
    eventId: eventId,
    jobType: jobType,
    status: status,
    wardrobeId: wardrobeId,
    itemId: itemId,
    outfitId: outfitId,
    renderId: renderId,
    aiProfileId: aiProfileId,
    error: error,
    createdAt: createdAt ?? DateTime.utc(2026, 9, 19, 10),
    acknowledgedAt: acknowledgedAt,
    isLocalPending: isLocalPending,
  );
}

JobEvent testTryOnEvent({
  JobEventStatus status = JobEventStatus.ready,
  String? error,
}) {
  return testJobEvent(
    eventId: 'evt_render_rend_abc123_READY',
    jobType: JobEventType.renderOutfit,
    status: status,
    itemId: null,
    outfitId: 'outfit_123',
    renderId: 'rend_abc123',
    aiProfileId: 'profile_generic_01',
    error: error,
  );
}

/// In-memory [JobEventRepository] for unit and widget tests.
class FakeJobEventRepository implements JobEventRepository {
  FakeJobEventRepository({
    List<JobEvent>? seed,
    this.contractUnavailable = false,
  }) : events = [...?seed];

  final List<JobEvent> events;
  bool contractUnavailable;
  ApiException? nextFailure;
  int listCalls = 0;
  int ackCalls = 0;
  int ackBatchCalls = 0;
  bool lastUnreadOnly = InboxContract.defaultUnreadOnly;
  int lastLimit = InboxContract.defaultLimit;
  final List<String> acknowledgedIds = [];

  @override
  Future<JobEventPage> listEvents({
    bool unreadOnly = true,
    int limit = 20,
  }) async {
    listCalls++;
    lastUnreadOnly = unreadOnly;
    lastLimit = limit;
    _maybeFail();
    if (contractUnavailable) {
      return JobEventPage.unavailable;
    }
    final unread = [
      for (final event in events)
        if (!unreadOnly || event.isUnread) event,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final clipped = unread.take(limit).toList();
    return JobEventPage(
      events: clipped,
      unreadCount: events.where((event) => event.isUnread).length,
    );
  }

  @override
  Future<JobEvent> acknowledge(String eventId) async {
    ackCalls++;
    acknowledgedIds.add(eventId);
    _maybeFail();
    final index = events.indexWhere((event) => event.eventId == eventId);
    if (index < 0) {
      throw const ApiException(
        message: 'Event not found.',
        code: InboxContract.eventNotFound,
        statusCode: 404,
      );
    }
    final acked = events[index].copyWith(
      acknowledgedAt: DateTime.utc(2026, 9, 19, 11),
    );
    events[index] = acked;
    return acked;
  }

  @override
  Future<List<JobEvent>> acknowledgeMany(List<String> eventIds) async {
    ackBatchCalls++;
    if (eventIds.isEmpty) {
      throw const ApiException(
        message: 'eventIds must not be empty.',
        code: InboxContract.validationError,
        statusCode: 400,
      );
    }
    _maybeFail();
    final acked = <JobEvent>[];
    for (final id in eventIds) {
      try {
        acked.add(await acknowledge(id));
      } on ApiException catch (error) {
        if (error.code != InboxContract.eventNotFound) {
          rethrow;
        }
      }
    }
    return acked;
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}
