import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/wardrobe.dart';

part 'wardrobe_dtos.freezed.dart';
part 'wardrobe_dtos.g.dart';

/// Backend wardrobe payload. [wardrobeId] maps to domain [Wardrobe.id].
@freezed
abstract class WardrobeResponse with _$WardrobeResponse {
  const WardrobeResponse._();

  const factory WardrobeResponse({
    required String wardrobeId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WardrobeResponse;

  factory WardrobeResponse.fromJson(Map<String, dynamic> json) =>
      _$WardrobeResponseFromJson(json);

  Wardrobe toDomain() {
    return Wardrobe(
      id: wardrobeId,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// `GET /wardrobes` envelope used by the backend contract.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WardrobeListResponse with _$WardrobeListResponse {
  const WardrobeListResponse._();

  const factory WardrobeListResponse({
    required List<WardrobeResponse> wardrobes,
  }) = _WardrobeListResponse;

  factory WardrobeListResponse.fromJson(Map<String, dynamic> json) =>
      _$WardrobeListResponseFromJson(json);

  List<Wardrobe> toDomain() {
    return wardrobes.map((wardrobe) => wardrobe.toDomain()).toList();
  }
}

/// `POST /wardrobes` body.
@freezed
abstract class CreateWardrobeRequest with _$CreateWardrobeRequest {
  const factory CreateWardrobeRequest({required String name}) =
      _CreateWardrobeRequest;

  factory CreateWardrobeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWardrobeRequestFromJson(json);
}

/// `PATCH /wardrobes/{wardrobeId}` body.
@freezed
abstract class UpdateWardrobeRequest with _$UpdateWardrobeRequest {
  const factory UpdateWardrobeRequest({required String name}) =
      _UpdateWardrobeRequest;

  factory UpdateWardrobeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWardrobeRequestFromJson(json);
}
