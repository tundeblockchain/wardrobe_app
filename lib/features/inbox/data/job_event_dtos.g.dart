// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_event_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobEventResponse _$JobEventResponseFromJson(Map<String, dynamic> json) =>
    _JobEventResponse(
      eventId: json['eventId'] as String,
      jobType: json['jobType'] as String,
      status: json['status'] as String,
      wardrobeId: json['wardrobeId'] as String,
      itemId: json['itemId'] as String?,
      outfitId: json['outfitId'] as String?,
      renderId: json['renderId'] as String?,
      aiProfileId: json['aiProfileId'] as String?,
      error: json['error'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acknowledgedAt: json['acknowledgedAt'] == null
          ? null
          : DateTime.parse(json['acknowledgedAt'] as String),
    );

Map<String, dynamic> _$JobEventResponseToJson(_JobEventResponse instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'jobType': instance.jobType,
      'status': instance.status,
      'wardrobeId': instance.wardrobeId,
      'itemId': ?instance.itemId,
      'outfitId': ?instance.outfitId,
      'renderId': ?instance.renderId,
      'aiProfileId': ?instance.aiProfileId,
      'error': ?instance.error,
      'createdAt': instance.createdAt.toIso8601String(),
      'acknowledgedAt': ?instance.acknowledgedAt?.toIso8601String(),
    };

_JobEventListResponse _$JobEventListResponseFromJson(
  Map<String, dynamic> json,
) => _JobEventListResponse(
  events: (json['events'] as List<dynamic>)
      .map((e) => JobEventResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$JobEventListResponseToJson(
  _JobEventListResponse instance,
) => <String, dynamic>{
  'events': instance.events,
  'unreadCount': instance.unreadCount,
};

_AckEventsRequest _$AckEventsRequestFromJson(Map<String, dynamic> json) =>
    _AckEventsRequest(
      eventIds: (json['eventIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AckEventsRequestToJson(_AckEventsRequest instance) =>
    <String, dynamic>{'eventIds': instance.eventIds};

_AckEventsResponse _$AckEventsResponseFromJson(Map<String, dynamic> json) =>
    _AckEventsResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => JobEventResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AckEventsResponseToJson(_AckEventsResponse instance) =>
    <String, dynamic>{'events': instance.events};
