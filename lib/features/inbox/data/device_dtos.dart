import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../domain/device_registration.dart';

part 'device_dtos.freezed.dart';
part 'device_dtos.g.dart';

/// `PUT /me/devices` body. Token is write-only.
@freezed
abstract class RegisterDeviceRequest with _$RegisterDeviceRequest {
  const factory RegisterDeviceRequest({
    required String token,
    required String platform,
    @JsonKey(includeIfNull: false) String? deviceId,
  }) = _RegisterDeviceRequest;

  factory RegisterDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceRequestFromJson(json);
}

/// `PUT /me/devices` result. Token is never echoed.
@freezed
abstract class DeviceRegistrationResponse with _$DeviceRegistrationResponse {
  const DeviceRegistrationResponse._();

  const factory DeviceRegistrationResponse({
    required String deviceId,
    required String platform,
    required DateTime updatedAt,
  }) = _DeviceRegistrationResponse;

  factory DeviceRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceRegistrationResponseFromJson(json);

  DeviceRegistration toDomain() {
    final parsed = DevicePlatform.tryParse(platform);
    if (parsed == null) {
      throw const ApiException(
        message: 'Unexpected device platform.',
        code: 'INVALID_RESPONSE',
      );
    }
    return DeviceRegistration(
      deviceId: deviceId,
      platform: parsed,
      updatedAt: updatedAt,
    );
  }
}
