// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WardrobeResponse _$WardrobeResponseFromJson(Map<String, dynamic> json) =>
    _WardrobeResponse(
      wardrobeId: json['wardrobeId'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WardrobeResponseToJson(_WardrobeResponse instance) =>
    <String, dynamic>{
      'wardrobeId': instance.wardrobeId,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_WardrobeListResponse _$WardrobeListResponseFromJson(
  Map<String, dynamic> json,
) => _WardrobeListResponse(
  wardrobes: (json['wardrobes'] as List<dynamic>)
      .map((e) => WardrobeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WardrobeListResponseToJson(
  _WardrobeListResponse instance,
) => <String, dynamic>{'wardrobes': instance.wardrobes};

_CreateWardrobeRequest _$CreateWardrobeRequestFromJson(
  Map<String, dynamic> json,
) => _CreateWardrobeRequest(name: json['name'] as String);

Map<String, dynamic> _$CreateWardrobeRequestToJson(
  _CreateWardrobeRequest instance,
) => <String, dynamic>{'name': instance.name};

_UpdateWardrobeRequest _$UpdateWardrobeRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateWardrobeRequest(name: json['name'] as String);

Map<String, dynamic> _$UpdateWardrobeRequestToJson(
  _UpdateWardrobeRequest instance,
) => <String, dynamic>{'name': instance.name};
