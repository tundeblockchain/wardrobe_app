// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecommendationItemResponse _$RecommendationItemResponseFromJson(
  Map<String, dynamic> json,
) => _RecommendationItemResponse(
  itemId: json['itemId'] as String,
  slot: json['slot'] as String,
);

Map<String, dynamic> _$RecommendationItemResponseToJson(
  _RecommendationItemResponse instance,
) => <String, dynamic>{'itemId': instance.itemId, 'slot': instance.slot};

_RecommendationResponse _$RecommendationResponseFromJson(
  Map<String, dynamic> json,
) => _RecommendationResponse(
  name: json['name'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) =>
                RecommendationItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$RecommendationResponseToJson(
  _RecommendationResponse instance,
) => <String, dynamic>{'name': instance.name, 'items': instance.items};

_RecommendationListResponse _$RecommendationListResponseFromJson(
  Map<String, dynamic> json,
) => _RecommendationListResponse(
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => RecommendationResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecommendationListResponseToJson(
  _RecommendationListResponse instance,
) => <String, dynamic>{'recommendations': instance.recommendations};
