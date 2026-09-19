import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/inbox/data/dio_job_event_repository.dart';
import 'package:wardrobe_app/features/inbox/data/events_api.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_contract.dart';
import 'package:wardrobe_app/features/inbox/domain/job_event.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  late ScriptedHttpAdapter adapter;

  EventsApi buildApi(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return EventsApi(dio);
  }

  DioJobEventRepository buildRepository(List<HttpScript> scripts) {
    return DioJobEventRepository(buildApi(scripts));
  }

  test('lists unread events with default query', () async {
    final api = buildApi([
      const HttpScript(
        statusCode: 200,
        body: {
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
        },
      ),
    ]);

    final page = await api.list();
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, InboxContract.eventsPath);
    expect(adapter.requests.single.headers['Authorization'], 'Bearer token');
    expect(adapter.requests.single.queryParameters, {
      'unreadOnly': 'true',
      'limit': '20',
    });
    expect(page.unreadCount, 1);
    expect(page.events.single.eventId, 'evt_item_item_xyz123_READY');
  });

  test('acks a single event', () async {
    final api = buildApi([
      const HttpScript(
        statusCode: 200,
        body: {
          'eventId': 'evt_item_item_xyz123_READY',
          'jobType': 'PROCESS_WARDROBE_ITEM',
          'status': 'READY',
          'wardrobeId': 'wd_abc123',
          'itemId': 'item_xyz123',
          'createdAt': '2026-09-19T10:00:00.000Z',
          'acknowledgedAt': '2026-09-19T10:01:00.000Z',
        },
      ),
    ]);

    final event = await api.acknowledge('evt_item_item_xyz123_READY');
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      '/me/events/evt_item_item_xyz123_READY/ack',
    );
    expect(event.acknowledgedAt, isNotNull);
  });

  test('acks a batch and skips unknown ids on the repository', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'events': [
            {
              'eventId': 'evt_1',
              'jobType': 'PROCESS_WARDROBE_ITEM',
              'status': 'READY',
              'wardrobeId': 'wd_abc123',
              'itemId': 'item_1',
              'createdAt': '2026-09-19T10:00:00.000Z',
              'acknowledgedAt': '2026-09-19T10:01:00.000Z',
            },
          ],
        },
      ),
    ]);

    final events = await repository.acknowledgeMany(['evt_1', 'evt_missing']);
    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, InboxContract.ackBatchPath);
    expect(_requestBody(adapter.requests.single), {
      'eventIds': ['evt_1', 'evt_missing'],
    });
    expect(events, hasLength(1));
  });

  test('list 404 is a soft-empty inbox while Backend is unmerged', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'NOT_FOUND', 'message': 'Not found.'},
        },
      ),
    ]);

    final page = await repository.listEvents();
    expect(page.contractUnavailable, isTrue);
    expect(page.events, isEmpty);
  });

  test('single ack of an unknown event is EVENT_NOT_FOUND', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'EVENT_NOT_FOUND', 'message': 'Event not found.'},
        },
      ),
    ]);

    expect(
      () => repository.acknowledge('evt_missing'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'EVENT_NOT_FOUND')
            .having((error) => error.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('maps listed events to domain READY item jobs', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
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
        },
      ),
    ]);

    final page = await repository.listEvents();
    expect(page.events.single.status, JobEventStatus.ready);
    expect(page.unreadCount, 1);
  });
}

Map<String, dynamic> _requestBody(RequestOptions options) {
  final data = options.data;
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  if (data is String && data.isNotEmpty) {
    return Map<String, dynamic>.from(jsonDecode(data) as Map);
  }
  return const {};
}
