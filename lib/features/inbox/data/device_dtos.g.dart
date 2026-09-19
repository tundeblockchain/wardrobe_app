// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterDeviceRequest _$RegisterDeviceRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterDeviceRequest(
  token: json['token'] as String,
  platform: json['platform'] as String,
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$RegisterDeviceRequestToJson(
  _RegisterDeviceRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'platform': instance.platform,
  'deviceId': ?instance.deviceId,
};

_DeviceRegistrationResponse _$DeviceRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _DeviceRegistrationResponse(
  deviceId: json['deviceId'] as String,
  platform: json['platform'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DeviceRegistrationResponseToJson(
  _DeviceRegistrationResponse instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'platform': instance.platform,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
