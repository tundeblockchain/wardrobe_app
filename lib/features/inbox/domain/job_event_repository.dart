import 'job_event.dart';

/// Durable in-app inbox for AI job-done events (WARDROBE-114).
///
/// Identity comes from the Firebase Bearer token. Not entitlement-gated.
abstract interface class JobEventRepository {
  Future<JobEventPage> listEvents({bool unreadOnly = true, int limit = 20});

  Future<JobEvent> acknowledge(String eventId);

  Future<List<JobEvent>> acknowledgeMany(List<String> eventIds);
}
