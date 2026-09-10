import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_profile_body_context.dart';
import 'ai_profile_preview.dart';

part 'ai_profile.freezed.dart';

/// Backend `type` values for an AI try-on profile.
enum AiProfileType {
  personal('PERSONAL', 'Personal'),
  genericModel('GENERIC_MODEL', 'Model');

  const AiProfileType(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static AiProfileType? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final type in AiProfileType.values) {
      if (type.wireValue == value) {
        return type;
      }
    }
    return null;
  }
}

/// Backend `status` values for an AI profile (WARDROBE-43/44).
enum AiProfileStatus {
  pending('PENDING', 'Pending'),
  processing('PROCESSING', 'Processing'),
  ready('READY', 'Ready'),
  failed('FAILED', 'Failed'),
  unknown('UNKNOWN', 'Unknown');

  const AiProfileStatus(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static AiProfileStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return AiProfileStatus.ready;
    }
    for (final status in AiProfileStatus.values) {
      if (status.wireValue == value) {
        return status;
      }
    }
    return AiProfileStatus.unknown;
  }
}

/// Maximum reference photos the backend accepts on a PERSONAL profile.
const maxAiProfileReferenceImages = 10;

/// AI try-on profile as used by controllers and UI. Backend `aiProfileId` is [id].
@freezed
abstract class AiProfile with _$AiProfile {
  const AiProfile._();

  const factory AiProfile({
    required String id,
    required AiProfileType type,
    String? label,
    @Default([]) List<String> referenceImages,
    @Default(AiProfileStatus.ready) AiProfileStatus status,
    String? previewImageUrl,
    @Default(AiProfileBodyContext.empty) AiProfileBodyContext bodyContext,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AiProfile;

  /// HTTP(S) photo for the model/persona picker. Null when get/list has no URL.
  String? get pickerImageUrl {
    final explicit = previewImageUrl?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    return pickFrontalHttpUrl(referenceImages);
  }

  /// Picker title: seeded [label] when present, otherwise a type fallback.
  String get displayName {
    final trimmed = label?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }
    return type == AiProfileType.genericModel ? 'Model' : 'Your profile';
  }

  bool get isPersonal => type == AiProfileType.personal;

  bool get isGenericModel => type == AiProfileType.genericModel;

  bool get canAddReferenceImage =>
      isPersonal && referenceImages.length < maxAiProfileReferenceImages;

  /// Backend WARDROBE-47: profile must be READY PERSONAL or GENERIC_MODEL.
  /// PERSONAL also needs at least one reference photo.
  /// Empty [bodyContext] never blocks try-on (WARDROBE-81).
  bool get canUseForTryOn {
    if (status != AiProfileStatus.ready) {
      return false;
    }
    if (isGenericModel) {
      return true;
    }
    return isPersonal && referenceImages.isNotEmpty;
  }
}
