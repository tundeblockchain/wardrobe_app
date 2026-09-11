import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../items/domain/item.dart';
import '../domain/outfit.dart';
import '../domain/outfit_render.dart';
import '../domain/try_on_history.dart';

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

/// Backend `OutfitRender` (WARDROBE-47). GET `/render` returns this object.
@freezed
abstract class OutfitRenderResponse with _$OutfitRenderResponse {
  const OutfitRenderResponse._();

  const factory OutfitRenderResponse({
    required String status,
    required String aiProfileId,
    String? imageKey,
    String? imageUrl,
    String? error,
  }) = _OutfitRenderResponse;

  factory OutfitRenderResponse.fromJson(Map<String, dynamic> json) =>
      _$OutfitRenderResponseFromJson(json);

  OutfitRender toDomain() {
    return OutfitRender(
      status: OutfitRenderStatus.parse(status),
      aiProfileId: aiProfileId,
      imageKey: _optional(imageKey),
      imageUrl: _optional(imageUrl),
      error: _optional(error),
    );
  }
}

String? _optional(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
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
    OutfitRenderResponse? render,
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
      render: render?.toDomain(),
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
  @JsonSerializable(explicitToJson: true)
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
  @JsonSerializable(explicitToJson: true)
  const factory UpdateOutfitRequest({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) List<OutfitItemRequest>? items,
  }) = _UpdateOutfitRequest;

  factory UpdateOutfitRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOutfitRequestFromJson(json);
}

/// `POST /wardrobes/{wardrobeId}/outfits/{outfitId}/render` body.
@freezed
abstract class RequestOutfitRenderRequest with _$RequestOutfitRenderRequest {
  @JsonSerializable(explicitToJson: true)
  const factory RequestOutfitRenderRequest({
    required String aiProfileId,
    @JsonKey(includeIfNull: false) List<OutfitItemRequest>? items,
    @JsonKey(includeIfNull: false) List<String>? itemIds,
  }) = _RequestOutfitRenderRequest;

  factory RequestOutfitRenderRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestOutfitRenderRequestFromJson(json);
}

/// Expected WARDROBE-85 payload: `{ "renders": [...] }`, `{ "history": [...] }`,
/// or a bare array of [OutfitRenderResponse] objects. Extra keys such as
/// `renderId` / `createdAt` are read when present and never written onto Outfit.
List<TryOnHistoryEntry> parseTryOnHistory(dynamic data) {
  if (data == null) {
    return const [];
  }
  if (data is List) {
    return _entriesFromList(data);
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final nested = map['renders'] ?? map['history'] ?? map['tryOns'];
    if (nested is List) {
      return _entriesFromList(nested);
    }
    if (nested == null) {
      return const [];
    }
  }
  throw const ApiException(
    message: 'Unexpected try-on history response.',
    code: 'INVALID_RESPONSE',
  );
}

List<TryOnHistoryEntry> _entriesFromList(List<dynamic> raw) {
  final entries = <TryOnHistoryEntry>[];
  for (final item in raw) {
    if (item is! Map) {
      continue;
    }
    final json = Map<String, dynamic>.from(item);
    final render = OutfitRenderResponse.fromJson(json).toDomain();
    final id = _optionalString(json['renderId'] ?? json['id']);
    final createdAt = _optionalDate(json['createdAt'] ?? json['updatedAt']);
    entries.add(
      TryOnHistoryEntry(render: render, id: id, createdAt: createdAt),
    );
  }
  final dated = entries.where((entry) => entry.createdAt != null).toList();
  if (dated.length == entries.length && entries.length > 1) {
    entries.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }
  return entries;
}

String? _optionalString(dynamic value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

DateTime? _optionalDate(dynamic value) {
  if (value is! String) {
    return null;
  }
  return DateTime.tryParse(value.trim());
}
