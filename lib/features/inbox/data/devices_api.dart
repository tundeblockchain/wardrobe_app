import 'package:dio/dio.dart';

import '../domain/device_registration.dart';
import '../domain/inbox_contract.dart';
import 'device_dtos.dart';

/// Thin Dio client for `/me/devices` (WARDROBE-114).
class DevicesApi {
  DevicesApi(this._dio);

  final Dio _dio;

  Future<DeviceRegistrationResponse> register({
    required String token,
    required DevicePlatform platform,
    String? deviceId,
  }) async {
    final response = await _dio.put<dynamic>(
      InboxContract.devicesPath,
      data: RegisterDeviceRequest(
        token: token,
        platform: platform.wireValue,
        deviceId: _optional(deviceId),
      ).toJson(),
    );
    if (response.data is! Map) {
      throw StateError('Unexpected device registration payload.');
    }
    return DeviceRegistrationResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> unregister(String deviceId) async {
    await _dio.delete<dynamic>(InboxContract.devicePath(deviceId));
  }

  String? _optional(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
