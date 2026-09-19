import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/inbox/data/devices_api.dart';
import 'package:wardrobe_app/features/inbox/data/dio_device_repository.dart';
import 'package:wardrobe_app/features/inbox/domain/device_registration.dart';
import 'package:wardrobe_app/features/inbox/domain/inbox_contract.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  late ScriptedHttpAdapter adapter;

  DevicesApi buildApi(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DevicesApi(dio);
  }

  test('PUT /me/devices registers a token as write-only', () async {
    final repository = DioDeviceRepository(
      buildApi([
        const HttpScript(
          statusCode: 200,
          body: {
            'deviceId': 'dev_abc123xyz0',
            'platform': 'ANDROID',
            'updatedAt': '2026-09-19T10:00:00.000Z',
          },
        ),
      ]),
    );

    final device = await repository.register(
      token: 'fcm-token',
      platform: DevicePlatform.android,
    );

    expect(adapter.requests.single.method, 'PUT');
    expect(adapter.requests.single.path, InboxContract.devicesPath);
    expect(adapter.requests.single.headers['Authorization'], 'Bearer token');
    expect(_requestBody(adapter.requests.single), {
      'token': 'fcm-token',
      'platform': 'ANDROID',
    });
    expect(device.deviceId, 'dev_abc123xyz0');
    expect(device.platform, DevicePlatform.android);
  });

  test('DELETE /me/devices/{deviceId} is 204', () async {
    final api = buildApi([const HttpScript(statusCode: 204)]);
    await api.unregister('dev_abc123xyz0');
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/me/devices/dev_abc123xyz0');
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
