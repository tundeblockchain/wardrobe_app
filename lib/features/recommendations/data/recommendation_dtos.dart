import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../items/domain/item.dart';
import '../../outfits/data/outfit_dtos.dart';
import '../../outfits/domain/outfit.dart';
import '../domain/recommendation.dart';

part 'recommendation_dtos.freezed.dart';
part 'recommendation_dtos.g.dart';

/// Nested slot assignment from a recommendation payload.
@freezed
abstract class RecommendationItemResponse with _$RecommendationItemResponse {
  const RecommendationItemResponse._();

  const factory RecommendationItemResponse({
    required String itemId,
    required String slot,
  }) = _RecommendationItemResponse;

  factory RecommendationItemResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationItemResponseFromJson(json);

  OutfitItem toDomain() {
    final parsedSlot = ItemCategory.tryParse(slot);
    if (parsedSlot == null) {
      throw const ApiException(
        message: 'Unexpected recommendation slot.',
        code: 'INVALID_RESPONSE',
      );
    }
    return OutfitItem(itemId: itemId, slot: parsedSlot);
  }
}

/// Suggested look from the backend. [name] is optional on the wire.
@freezed
abstract class RecommendationResponse with _$RecommendationResponse {
  const RecommendationResponse._();

  const factory RecommendationResponse({
    String? name,
    @Default([]) List<RecommendationItemResponse> items,
  }) = _RecommendationResponse;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);

  Recommendation toDomain() {
    final trimmed = name?.trim();
    return Recommendation(
      name: (trimmed == null || trimmed.isEmpty) ? 'Suggested look' : trimmed,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}

/// `GET /wardrobes/{wardrobeId}/recommendations` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class RecommendationListResponse with _$RecommendationListResponse {
  const RecommendationListResponse._();

  const factory RecommendationListResponse({
    required List<RecommendationResponse> recommendations,
  }) = _RecommendationListResponse;

  factory RecommendationListResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationListResponseFromJson(json);

  List<Recommendation> toDomain() =>
      recommendations.map((item) => item.toDomain()).toList();
}

/// Maps a suggestion onto the existing outfit-create write payload.
CreateOutfitRequest createOutfitRequestFromRecommendation(
  Recommendation recommendation,
) {
  return CreateOutfitRequest.fromDomain(
    name: recommendation.name,
    items: recommendation.items,
  );
}
