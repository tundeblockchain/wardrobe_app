// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    _SupportRequest(
      subject: json['subject'] as String,
      body: json['body'] as String,
      replyTo: json['replyTo'] as String?,
      meta: (json['meta'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$SupportRequestToJson(_SupportRequest instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'body': instance.body,
      'replyTo': ?instance.replyTo,
      'meta': ?instance.meta,
    };
