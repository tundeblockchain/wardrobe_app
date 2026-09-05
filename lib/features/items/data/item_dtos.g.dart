// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemImageResponse _$ItemImageResponseFromJson(Map<String, dynamic> json) =>
    _ItemImageResponse(
      originalKey: json['originalKey'] as String,
      processedKey: json['processedKey'] as String?,
    );

Map<String, dynamic> _$ItemImageResponseToJson(_ItemImageResponse instance) =>
    <String, dynamic>{
      'originalKey': instance.originalKey,
      'processedKey': instance.processedKey,
    };

_ItemAiResponse _$ItemAiResponseFromJson(Map<String, dynamic> json) =>
    _ItemAiResponse(
      detectedCategory: json['detectedCategory'] as String?,
      detectedSubcategory: json['detectedSubcategory'] as String?,
      detectedColours: (json['detectedColours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      backgroundRemoved: json['backgroundRemoved'] as bool?,
      processedImageKey: json['processedImageKey'] as String?,
    );

Map<String, dynamic> _$ItemAiResponseToJson(_ItemAiResponse instance) =>
    <String, dynamic>{
      'detectedCategory': instance.detectedCategory,
      'detectedSubcategory': instance.detectedSubcategory,
      'detectedColours': instance.detectedColours,
      'backgroundRemoved': instance.backgroundRemoved,
      'processedImageKey': instance.processedImageKey,
    };

_ItemResponse _$ItemResponseFromJson(Map<String, dynamic> json) =>
    _ItemResponse(
      itemId: json['itemId'] as String,
      wardrobeId: json['wardrobeId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      colours: (json['colours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      brand: json['brand'] as String?,
      image: json['image'] == null
          ? null
          : ItemImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      imageKey: json['imageKey'] as String?,
      processingStatus: json['processingStatus'] as String?,
      processingError: json['processingError'] as String?,
      failureReason: json['failureReason'] as String?,
      errorMessage: json['errorMessage'] as String?,
      ai: json['ai'] == null
          ? null
          : ItemAiResponse.fromJson(json['ai'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemResponseToJson(_ItemResponse instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'wardrobeId': instance.wardrobeId,
      'name': instance.name,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'colours': instance.colours,
      'brand': instance.brand,
      'image': instance.image,
      'imageKey': instance.imageKey,
      'processingStatus': instance.processingStatus,
      'processingError': instance.processingError,
      'failureReason': instance.failureReason,
      'errorMessage': instance.errorMessage,
      'ai': instance.ai,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_ItemListResponse _$ItemListResponseFromJson(Map<String, dynamic> json) =>
    _ItemListResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemListResponseToJson(_ItemListResponse instance) =>
    <String, dynamic>{'items': instance.items};

_CreateItemRequest _$CreateItemRequestFromJson(Map<String, dynamic> json) =>
    _CreateItemRequest(
      name: json['name'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      colours: (json['colours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      brand: json['brand'] as String?,
      imageKey: json['imageKey'] as String,
    );

Map<String, dynamic> _$CreateItemRequestToJson(_CreateItemRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'subcategory': ?instance.subcategory,
      'colours': ?instance.colours,
      'brand': ?instance.brand,
      'imageKey': instance.imageKey,
    };

_UpdateItemRequest _$UpdateItemRequestFromJson(Map<String, dynamic> json) =>
    _UpdateItemRequest(
      name: json['name'] as String?,
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      colours: (json['colours'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      brand: json['brand'] as String?,
      imageKey: json['imageKey'] as String?,
    );

Map<String, dynamic> _$UpdateItemRequestToJson(_UpdateItemRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'category': ?instance.category,
      'subcategory': ?instance.subcategory,
      'colours': ?instance.colours,
      'brand': ?instance.brand,
      'imageKey': ?instance.imageKey,
    };
