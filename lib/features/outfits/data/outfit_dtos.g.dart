// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutfitItemResponse _$OutfitItemResponseFromJson(Map<String, dynamic> json) =>
    _OutfitItemResponse(
      itemId: json['itemId'] as String,
      slot: json['slot'] as String,
    );

Map<String, dynamic> _$OutfitItemResponseToJson(_OutfitItemResponse instance) =>
    <String, dynamic>{'itemId': instance.itemId, 'slot': instance.slot};

_OutfitItemRequest _$OutfitItemRequestFromJson(Map<String, dynamic> json) =>
    _OutfitItemRequest(
      itemId: json['itemId'] as String,
      slot: json['slot'] as String,
    );

Map<String, dynamic> _$OutfitItemRequestToJson(_OutfitItemRequest instance) =>
    <String, dynamic>{'itemId': instance.itemId, 'slot': instance.slot};

_OutfitRenderResponse _$OutfitRenderResponseFromJson(
  Map<String, dynamic> json,
) => _OutfitRenderResponse(
  status: json['status'] as String,
  aiProfileId: json['aiProfileId'] as String,
  imageKey: json['imageKey'] as String?,
  imageUrl: json['imageUrl'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$OutfitRenderResponseToJson(
  _OutfitRenderResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'aiProfileId': instance.aiProfileId,
  'imageKey': instance.imageKey,
  'imageUrl': instance.imageUrl,
  'error': instance.error,
};

_OutfitResponse _$OutfitResponseFromJson(
  Map<String, dynamic> json,
) => _OutfitResponse(
  outfitId: json['outfitId'] as String,
  wardrobeId: json['wardrobeId'] as String,
  name: json['name'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OutfitItemResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  render: json['render'] == null
      ? null
      : OutfitRenderResponse.fromJson(json['render'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OutfitResponseToJson(_OutfitResponse instance) =>
    <String, dynamic>{
      'outfitId': instance.outfitId,
      'wardrobeId': instance.wardrobeId,
      'name': instance.name,
      'items': instance.items,
      'render': instance.render,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_OutfitListResponse _$OutfitListResponseFromJson(Map<String, dynamic> json) =>
    _OutfitListResponse(
      outfits: (json['outfits'] as List<dynamic>)
          .map((e) => OutfitResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutfitListResponseToJson(_OutfitListResponse instance) =>
    <String, dynamic>{'outfits': instance.outfits};

_CreateOutfitRequest _$CreateOutfitRequestFromJson(Map<String, dynamic> json) =>
    _CreateOutfitRequest(
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OutfitItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateOutfitRequestToJson(
  _CreateOutfitRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

_UpdateOutfitRequest _$UpdateOutfitRequestFromJson(Map<String, dynamic> json) =>
    _UpdateOutfitRequest(
      name: json['name'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OutfitItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateOutfitRequestToJson(
  _UpdateOutfitRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
};

_RequestOutfitRenderRequest _$RequestOutfitRenderRequestFromJson(
  Map<String, dynamic> json,
) => _RequestOutfitRenderRequest(
  aiProfileId: json['aiProfileId'] as String,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OutfitItemRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  itemIds: (json['itemIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RequestOutfitRenderRequestToJson(
  _RequestOutfitRenderRequest instance,
) => <String, dynamic>{
  'aiProfileId': instance.aiProfileId,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
  'itemIds': ?instance.itemIds,
};
