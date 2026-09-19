import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/job_event.dart';

part 'job_event_dtos.freezed.dart';
part 'job_event_dtos.g.dart';

/// Backend job-done event. Optional fields are omitted, never `null`.
@freezed
abstract class JobEventResponse with _$JobEventResponse {
  const JobEventResponse._();

  const factory JobEventResponse({
    required String eventId,
    required String jobType,
    required String status,
    required String wardrobeId,
    @JsonKey(includeIfNull: false) String? itemId,
    @JsonKey(includeIfNull: false) String? outfitId,
    @JsonKey(includeIfNull: false) String? renderId,
    @JsonKey(includeIfNull: false) String? aiProfileId,
    @JsonKey(includeIfNull: false) String? error,
    required DateTime createdAt,
    @JsonKey(includeIfNull: false) DateTime? acknowledgedAt,
  }) = _JobEventResponse;

  factory JobEventResponse.fromJson(Map<String, dynamic> json) =>
      _$JobEventResponseFromJson(json);

  JobEvent toDomain() {
    return JobEvent(
      eventId: eventId,
      jobType: JobEventType.parse(jobType),
      status: JobEventStatus.parse(status),
      wardrobeId: wardrobeId,
      itemId: _optional(itemId),
      outfitId: _optional(outfitId),
      renderId: _optional(renderId),
      aiProfileId: _optional(aiProfileId),
      error: _optional(error),
      createdAt: createdAt,
      acknowledgedAt: acknowledgedAt,
    );
  }
}

/// `GET /me/events` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class JobEventListResponse with _$JobEventListResponse {
  const JobEventListResponse._();

  const factory JobEventListResponse({
    required List<JobEventResponse> events,
    required int unreadCount,
  }) = _JobEventListResponse;

  factory JobEventListResponse.fromJson(Map<String, dynamic> json) =>
      _$JobEventListResponseFromJson(json);

  JobEventPage toDomain() {
    return JobEventPage(
      events: events.map((event) => event.toDomain()).toList(),
      unreadCount: unreadCount,
    );
  }
}

/// `POST /me/events/ack` body.
@freezed
abstract class AckEventsRequest with _$AckEventsRequest {
  const factory AckEventsRequest({required List<String> eventIds}) =
      _AckEventsRequest;

  factory AckEventsRequest.fromJson(Map<String, dynamic> json) =>
      _$AckEventsRequestFromJson(json);
}

/// `POST /me/events/ack` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AckEventsResponse with _$AckEventsResponse {
  const AckEventsResponse._();

  const factory AckEventsResponse({required List<JobEventResponse> events}) =
      _AckEventsResponse;

  factory AckEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$AckEventsResponseFromJson(json);

  List<JobEvent> toDomain() => events.map((event) => event.toDomain()).toList();
}

String? _optional(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
