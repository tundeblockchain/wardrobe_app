// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiProfileResponse _$AiProfileResponseFromJson(Map<String, dynamic> json) =>
    _AiProfileResponse(
      aiProfileId: json['aiProfileId'] as String,
      type: json['type'] as String,
      label: json['label'] as String?,
      referenceImages: (json['referenceImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AiProfileResponseToJson(_AiProfileResponse instance) =>
    <String, dynamic>{
      'aiProfileId': instance.aiProfileId,
      'type': instance.type,
      'label': instance.label,
      'referenceImages': instance.referenceImages,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_AiProfileListResponse _$AiProfileListResponseFromJson(
  Map<String, dynamic> json,
) => _AiProfileListResponse(
  aiProfiles: (json['aiProfiles'] as List<dynamic>)
      .map((e) => AiProfileResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AiProfileListResponseToJson(
  _AiProfileListResponse instance,
) => <String, dynamic>{'aiProfiles': instance.aiProfiles};

_CreateAiProfileRequest _$CreateAiProfileRequestFromJson(
  Map<String, dynamic> json,
) => _CreateAiProfileRequest(type: json['type'] as String? ?? 'PERSONAL');

Map<String, dynamic> _$CreateAiProfileRequestToJson(
  _CreateAiProfileRequest instance,
) => <String, dynamic>{'type': instance.type};

_CreateAiProfileUploadRequest _$CreateAiProfileUploadRequestFromJson(
  Map<String, dynamic> json,
) => _CreateAiProfileUploadRequest(
  contentType: json['contentType'] as String,
  purpose: json['purpose'] as String? ?? 'AI_PROFILE_REFERENCE',
  contentLength: (json['contentLength'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateAiProfileUploadRequestToJson(
  _CreateAiProfileUploadRequest instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'purpose': instance.purpose,
  'contentLength': ?instance.contentLength,
};

_AttachAiProfileImagesRequest _$AttachAiProfileImagesRequestFromJson(
  Map<String, dynamic> json,
) => _AttachAiProfileImagesRequest(
  objectKey: json['objectKey'] as String?,
  objectKeys: (json['objectKeys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AttachAiProfileImagesRequestToJson(
  _AttachAiProfileImagesRequest instance,
) => <String, dynamic>{
  'objectKey': ?instance.objectKey,
  'objectKeys': ?instance.objectKeys,
};
