import 'package:dio/dio.dart';

import '../domain/inbox_contract.dart';
import 'job_event_dtos.dart';

/// Thin Dio client for `/me/events` (WARDROBE-114).
class EventsApi {
  EventsApi(this._dio);

  final Dio _dio;

  Future<JobEventListResponse> list({
    bool unreadOnly = InboxContract.defaultUnreadOnly,
    int limit = InboxContract.defaultLimit,
  }) async {
    final response = await _dio.get<dynamic>(
      InboxContract.eventsPath,
      queryParameters: InboxContract.listQueryParameters(
        unreadOnly: unreadOnly,
        limit: limit,
      ),
    );
    if (response.data is! Map) {
      throw StateError('Unexpected events list payload.');
    }
    return JobEventListResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<JobEventResponse> acknowledge(String eventId) async {
    final response = await _dio.post<dynamic>(InboxContract.ackPath(eventId));
    if (response.data is! Map) {
      throw StateError('Unexpected event ack payload.');
    }
    return JobEventResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<AckEventsResponse> acknowledgeMany(List<String> eventIds) async {
    final response = await _dio.post<dynamic>(
      InboxContract.ackBatchPath,
      data: AckEventsRequest(eventIds: eventIds).toJson(),
    );
    if (response.data is! Map) {
      throw StateError('Unexpected batch ack payload.');
    }
    return AckEventsResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
