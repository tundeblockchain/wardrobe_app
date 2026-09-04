import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../items/domain/item.dart';
import '../domain/outfit.dart';

part 'outfit_dtos.freezed.dart';
part 'outfit_dtos.g.dart';

/// Nested slot assignment from the backend outfit payload.
@freezed
abstract class OutfitItemResponse with _$OutfitItemResponse {
  const OutfitItemResponse._();

  const factory OutfitItemResponse({
    required String itemId,
    required String slot,
  }) = _OutfitItemResponse;

  factory OutfitItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OutfitItemResponseFromJson(json);

  OutfitItem toDomain() {
    final parsedSlot = ItemCategory.tryParse(slot);
    if (parsedSlot == null) {
      throw const ApiException(
        message: 'Unexpected outfit slot.',
        code: 'INVALID_RESPONSE',
      );
    }
    return OutfitItem(itemId: itemId, slot: parsedSlot);
  }
}

/// Write payload for one slot assignment. Wire keys stay `itemId` / `slot`.
@freezed
abstract class OutfitItemRequest with _$OutfitItemRequest {
  const factory OutfitItemRequest({
    required String itemId,
    required String slot,
  }) = _OutfitItemRequest;

  factory OutfitItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OutfitItemRequestFromJson(json);

  factory OutfitItemRequest.fromDomain(OutfitItem item) {
    return OutfitItemRequest(itemId: item.itemId, slot: item.slot.wireValue);
  }
}

/// Backend outfit payload. [outfitId] maps to domain [Outfit.id].
@freezed
abstract class OutfitResponse with _$OutfitResponse {
  const OutfitResponse._();

  const factory OutfitResponse({
    required String outfitId,
    required String wardrobeId,
    required String name,
    @Default([]) List<OutfitItemResponse> items,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OutfitResponse;

  factory OutfitResponse.fromJson(Map<String, dynamic> json) =>
      _$OutfitResponseFromJson(json);

  Outfit toDomain() {
    return Outfit(
      id: outfitId,
      wardrobeId: wardrobeId,
      name: name,
      items: items.map((item) => item.toDomain()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// `GET /wardrobes/{wardrobeId}/outfits` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class OutfitListResponse with _$OutfitListResponse {
  const OutfitListResponse._();

  const factory OutfitListResponse({required List<OutfitResponse> outfits}) =
      _OutfitListResponse;

  factory OutfitListResponse.fromJson(Map<String, dynamic> json) =>
      _$OutfitListResponseFromJson(json);

  List<Outfit> toDomain() =>
      outfits.map((outfit) => outfit.toDomain()).toList();
}

/// `POST /wardrobes/{wardrobeId}/outfits` body.
@freezed
abstract class CreateOutfitRequest with _$CreateOutfitRequest {
  const factory CreateOutfitRequest({
    required String name,
    required List<OutfitItemRequest> items,
  }) = _CreateOutfitRequest;

  factory CreateOutfitRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOutfitRequestFromJson(json);

  factory CreateOutfitRequest.fromDomain({
    required String name,
    required List<OutfitItem> items,
  }) {
    return CreateOutfitRequest(
      name: name,
      items: [for (final item in items) OutfitItemRequest.fromDomain(item)],
    );
  }
}

/// `PATCH /wardrobes/{wardrobeId}/outfits/{outfitId}` body.
@freezed
abstract class UpdateOutfitRequest with _$UpdateOutfitRequest {
  const factory UpdateOutfitRequest({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) List<OutfitItemRequest>? items,
  }) = _UpdateOutfitRequest;

  factory UpdateOutfitRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOutfitRequestFromJson(json);
}
