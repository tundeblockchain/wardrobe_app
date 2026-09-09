import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../items/data/upload_dtos.dart';
import '../../items/domain/upload_ticket.dart';
import '../domain/ai_profile.dart';
import '../domain/ai_profile_preview.dart';

part 'ai_profile_dtos.freezed.dart';
part 'ai_profile_dtos.g.dart';

/// Backend AI-profile payload. [aiProfileId] maps to domain [AiProfile.id].
@freezed
abstract class AiProfileResponse with _$AiProfileResponse {
  const AiProfileResponse._();

  const factory AiProfileResponse({
    required String aiProfileId,
    required String type,
    String? label,
    List<String>? referenceImages,
    String? status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AiProfileResponse;

  factory AiProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$AiProfileResponseFromJson(json);

  AiProfile toDomain() {
    final parsedType = AiProfileType.tryParse(type);
    if (parsedType == null) {
      throw const ApiException(
        message: 'Unexpected AI profile type.',
        code: 'INVALID_RESPONSE',
      );
    }
    return AiProfile(
      id: aiProfileId,
      type: parsedType,
      label: _optional(label),
      referenceImages: [...?referenceImages],
      status: AiProfileStatus.parse(status),
      previewImageUrl: pickFrontalHttpUrl([...?referenceImages]),
      createdAt: createdAt,
      updatedAt: updatedAt,
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

/// `GET /ai-profiles` and `GET /ai-profiles/models` envelope.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AiProfileListResponse with _$AiProfileListResponse {
  const AiProfileListResponse._();

  const factory AiProfileListResponse({
    required List<AiProfileResponse> aiProfiles,
  }) = _AiProfileListResponse;

  factory AiProfileListResponse.fromJson(Map<String, dynamic> json) =>
      _$AiProfileListResponseFromJson(json);

  List<AiProfile> toDomain() =>
      aiProfiles.map((profile) => profile.toDomain()).toList();
}

/// `POST /ai-profiles` body. GENERIC_MODEL create is rejected by the API.
@freezed
abstract class CreateAiProfileRequest with _$CreateAiProfileRequest {
  const factory CreateAiProfileRequest({@Default('PERSONAL') String type}) =
      _CreateAiProfileRequest;

  factory CreateAiProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAiProfileRequestFromJson(json);
}

/// `POST /ai-profiles/{aiProfileId}/uploads` body.
@freezed
abstract class CreateAiProfileUploadRequest
    with _$CreateAiProfileUploadRequest {
  const factory CreateAiProfileUploadRequest({
    required String contentType,
    @Default('AI_PROFILE_REFERENCE') String purpose,
    @JsonKey(includeIfNull: false) int? contentLength,
  }) = _CreateAiProfileUploadRequest;

  factory CreateAiProfileUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAiProfileUploadRequestFromJson(json);
}

/// `POST /ai-profiles/{aiProfileId}/reference-images` body.
@freezed
abstract class AttachAiProfileImagesRequest
    with _$AttachAiProfileImagesRequest {
  const factory AttachAiProfileImagesRequest({
    @JsonKey(includeIfNull: false) String? objectKey,
    @JsonKey(includeIfNull: false) List<String>? objectKeys,
  }) = _AttachAiProfileImagesRequest;

  factory AttachAiProfileImagesRequest.fromJson(Map<String, dynamic> json) =>
      _$AttachAiProfileImagesRequestFromJson(json);
}

/// Maps a presign payload onto the shared [UploadTicket] domain.
UploadTicket parseAiProfileUploadTicket(Map<String, dynamic> json) {
  return UploadTicketResponse.fromJson(json).toDomain();
}
