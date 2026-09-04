// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateUploadRequest _$CreateUploadRequestFromJson(Map<String, dynamic> json) =>
    _CreateUploadRequest(
      contentType: json['contentType'] as String,
      purpose: json['purpose'] as String? ?? 'WARDROBE_ITEM',
    );

Map<String, dynamic> _$CreateUploadRequestToJson(
  _CreateUploadRequest instance,
) => <String, dynamic>{
  'contentType': instance.contentType,
  'purpose': instance.purpose,
};

_UploadTicketResponse _$UploadTicketResponseFromJson(
  Map<String, dynamic> json,
) => _UploadTicketResponse(
  uploadUrl: json['uploadUrl'] as String,
  objectKey: json['objectKey'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
);

Map<String, dynamic> _$UploadTicketResponseToJson(
  _UploadTicketResponse instance,
) => <String, dynamic>{
  'uploadUrl': instance.uploadUrl,
  'objectKey': instance.objectKey,
  'expiresIn': instance.expiresIn,
};
