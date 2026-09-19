import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/inbox_contract.dart';
import '../domain/job_event.dart';
import '../domain/job_event_repository.dart';
import 'events_api.dart';

/// Dio [JobEventRepository] against `/me/events`.
///
/// A 404 on list is treated as an empty inbox so Flutter can ship before
/// Backend WARDROBE-114 is merged to the live API.
class DioJobEventRepository implements JobEventRepository {
  DioJobEventRepository(this._api);

  final EventsApi _api;

  @override
  Future<JobEventPage> listEvents({
    bool unreadOnly = InboxContract.defaultUnreadOnly,
    int limit = InboxContract.defaultLimit,
  }) {
    return _guard(() async {
      final response = await _api.list(unreadOnly: unreadOnly, limit: limit);
      return response.toDomain();
    }, onNotFound: () => JobEventPage.unavailable);
  }

  @override
  Future<JobEvent> acknowledge(String eventId) {
    return _guard(() async {
      final response = await _api.acknowledge(eventId);
      return response.toDomain();
    });
  }

  @override
  Future<List<JobEvent>> acknowledgeMany(List<String> eventIds) {
    return _guard(() async {
      final response = await _api.acknowledgeMany(eventIds);
      return response.toDomain();
    });
  }

  Future<T> _guard<T>(
    Future<T> Function() action, {
    T Function()? onNotFound,
  }) async {
    try {
      return await action();
    } on DioException catch (error) {
      if (onNotFound != null && _isSoftMissing(error)) {
        return onNotFound();
      }
      throw ApiException.fromDio(error);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Unexpected event response.',
        code: 'INVALID_RESPONSE',
      );
    }
  }

  bool _isSoftMissing(DioException error) {
    final status = error.response?.statusCode;
    if (status == 404 || status == 501) {
      return true;
    }
    final parsed = parseErrorEnvelope(error.response?.data);
    return parsed?.code == InboxContract.eventNotFound ||
        parsed?.code == 'NOT_FOUND';
  }
}

final eventsApiProvider = Provider<EventsApi>((ref) {
  return EventsApi(ref.watch(dioProvider));
});

final jobEventRepositoryProvider = Provider<JobEventRepository>((ref) {
  return DioJobEventRepository(ref.watch(eventsApiProvider));
});
