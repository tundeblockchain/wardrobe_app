// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    _SupportRequest(
      subject: json['subject'] as String,
      message: json['message'] as String,
      device: json['device'] as String?,
      appVersion: json['appVersion'] as String?,
    );

Map<String, dynamic> _$SupportRequestToJson(_SupportRequest instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'message': instance.message,
      'device': ?instance.device,
      'appVersion': ?instance.appVersion,
    };
