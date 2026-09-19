import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/device_registration.dart';
import '../domain/device_repository.dart';
import 'devices_api.dart';

/// Dio [DeviceRepository] against `/me/devices`.
class DioDeviceRepository implements DeviceRepository {
  DioDeviceRepository(this._api);

  final DevicesApi _api;

  @override
  Future<DeviceRegistration> register({
    required String token,
    required DevicePlatform platform,
    String? deviceId,
  }) {
    return _guard(() async {
      final response = await _api.register(
        token: token,
        platform: platform,
        deviceId: deviceId,
      );
      return response.toDomain();
    });
  }

  @override
  Future<void> unregister(String deviceId) {
    return _guard(() async {
      await _api.unregister(deviceId);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        message: 'Unexpected device response.',
        code: 'INVALID_RESPONSE',
      );
    }
  }
}

final devicesApiProvider = Provider<DevicesApi>((ref) {
  return DevicesApi(ref.watch(dioProvider));
});

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DioDeviceRepository(ref.watch(devicesApiProvider));
});
