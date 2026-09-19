// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareResponse _$ShareResponseFromJson(Map<String, dynamic> json) =>
    _ShareResponse(
      token: json['token'] as String,
      resourceType: json['resourceType'] as String,
      wardrobeId: json['wardrobeId'] as String,
      itemId: json['itemId'] as String?,
      outfitId: json['outfitId'] as String?,
      sharePath: json['sharePath'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ShareResponseToJson(_ShareResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'resourceType': instance.resourceType,
      'wardrobeId': instance.wardrobeId,
      'itemId': ?instance.itemId,
      'outfitId': ?instance.outfitId,
      'sharePath': instance.sharePath,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
