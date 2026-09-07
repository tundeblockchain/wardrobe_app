import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../domain/item.dart';
import 'item_image_urls.dart';

part 'item_dtos.freezed.dart';
part 'item_dtos.g.dart';

/// Nested image keys from the backend clothing-item payload.
@freezed
abstract class ItemImageResponse with _$ItemImageResponse {
  const factory ItemImageResponse({
    required String originalKey,
    String? processedKey,
  }) = _ItemImageResponse;

  factory ItemImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemImageResponseFromJson(json);
}

/// Optional Phase-2 `ai` map. Never overwrites user category / colours.
@freezed
abstract class ItemAiResponse with _$ItemAiResponse {
  const ItemAiResponse._();

  const factory ItemAiResponse({
    String? detectedCategory,
    String? detectedSubcategory,
    List<String>? detectedColours,
    bool? backgroundRemoved,
    String? processedImageKey,
  }) = _ItemAiResponse;

  factory ItemAiResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemAiResponseFromJson(json);

  ItemAiMetadata toDomain() {
    return ItemAiMetadata(
      detectedCategory: ItemCategory.tryParse(detectedCategory),
      detectedSubcategory: detectedSubcategory,
      detectedColours: [...?detectedColours],
      backgroundRemoved: backgroundRemoved,
    );
  }
}

/// Backend clothing-item payload. [itemId] maps to domain [Item.id].
@freezed
abstract class ItemResponse with _$ItemResponse {
  const ItemResponse._();

  const factory ItemResponse({
    required String itemId,
    required String wardrobeId,
    required String name,
    required String category,
    String? subcategory,
    List<String>? colours,
    String? brand,
    ItemImageResponse? image,
    String? imageKey,
    String? originalImageUrl,
    String? processedImageUrl,
    String? processingStatus,
    String? processingError,
    String? failureReason,
    String? errorMessage,
    ItemAiResponse? ai,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ItemResponse;

  factory ItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemResponseFromJson(json);

  Item toDomain() {
    final parsedCategory = ItemCategory.tryParse(category);
    if (parsedCategory == null) {
      throw const ApiException(
        message: 'Unexpected item category.',
        code: 'INVALID_RESPONSE',
      );
    }
    return Item(
      id: itemId,
      wardrobeId: wardrobeId,
      name: name,
      category: parsedCategory,
      subcategory: subcategory,
      colours: [...?colours],
      brand: brand,
      originalImageKey:
          asHttpUrl(originalImageUrl) ?? image?.originalKey ?? imageKey,
      processedImageKey:
          asHttpUrl(processedImageUrl) ??
          image?.processedKey ??
          ai?.processedImageKey,
      processingStatus: ItemProcessingStatus.parse(processingStatus),
      processingError: _optionalError(
        // WARDROBE-59: optional worker reason; present on FAILED only.
        processingError ?? failureReason ?? errorMessage,
      ),
      ai: ai?.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

String? _optionalError(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

/// `GET /wardrobes/{wardrobeId}/items` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ItemListResponse with _$ItemListResponse {
  const ItemListResponse._();

  const factory ItemListResponse({required List<ItemResponse> items}) =
      _ItemListResponse;

  factory ItemListResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemListResponseFromJson(json);

  List<Item> toDomain() => items.map((item) => item.toDomain()).toList();
}

/// `POST /wardrobes/{wardrobeId}/items` body.
@freezed
abstract class CreateItemRequest with _$CreateItemRequest {
  const factory CreateItemRequest({
    required String name,
    required String category,
    @JsonKey(includeIfNull: false) String? subcategory,
    @JsonKey(includeIfNull: false) List<String>? colours,
    @JsonKey(includeIfNull: false) String? brand,
    required String imageKey,
  }) = _CreateItemRequest;

  factory CreateItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateItemRequestFromJson(json);
}

/// `PATCH /wardrobes/{wardrobeId}/items/{itemId}` body.
@freezed
abstract class UpdateItemRequest with _$UpdateItemRequest {
  const factory UpdateItemRequest({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) String? category,
    @JsonKey(includeIfNull: false) String? subcategory,
    @JsonKey(includeIfNull: false) List<String>? colours,
    @JsonKey(includeIfNull: false) String? brand,
    @JsonKey(includeIfNull: false) String? imageKey,
  }) = _UpdateItemRequest;

  factory UpdateItemRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateItemRequestFromJson(json);
}
