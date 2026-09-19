// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worn_on_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetWornOnRequest _$SetWornOnRequestFromJson(Map<String, dynamic> json) =>
    _SetWornOnRequest(wornOn: json['wornOn'] as String);

Map<String, dynamic> _$SetWornOnRequestToJson(_SetWornOnRequest instance) =>
    <String, dynamic>{'wornOn': instance.wornOn};

_WornOnEntryResponse _$WornOnEntryResponseFromJson(Map<String, dynamic> json) =>
    _WornOnEntryResponse(
      outfitId: json['outfitId'] as String,
      wardrobeId: json['wardrobeId'] as String,
      wornOn: json['wornOn'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WornOnEntryResponseToJson(
  _WornOnEntryResponse instance,
) => <String, dynamic>{
  'outfitId': instance.outfitId,
  'wardrobeId': instance.wardrobeId,
  'wornOn': instance.wornOn,
  'createdAt': instance.createdAt.toIso8601String(),
};

_WornOnListResponse _$WornOnListResponseFromJson(Map<String, dynamic> json) =>
    _WornOnListResponse(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => WornOnEntryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WornOnListResponseToJson(_WornOnListResponse instance) =>
    <String, dynamic>{'entries': instance.entries};
