import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../domain/share.dart';
import '../domain/share_errors.dart';
import '../domain/share_url.dart';

part 'share_dtos.freezed.dart';
part 'share_dtos.g.dart';

String? _optionalString(dynamic value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

DateTime? _optionalDateTime(dynamic value) {
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is! String) {
    return null;
  }
  return DateTime.tryParse(value.trim())?.toUtc();
}

/// Backend create-share payload. Unused `itemId` / `outfitId` are omitted.
@freezed
abstract class ShareResponse with _$ShareResponse {
  const ShareResponse._();

  @JsonSerializable(includeIfNull: false)
  const factory ShareResponse({
    required String token,
    required String resourceType,
    required String wardrobeId,
    String? itemId,
    String? outfitId,
    required String sharePath,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _ShareResponse;

  factory ShareResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseFromJson(json);

  Share? toDomain() {
    final type = ShareResourceType.tryParse(resourceType);
    final path = ShareLandingUrl.normalizePath(sharePath);
    if (type == null || path == null) {
      return null;
    }
    final trimmedToken = token.trim();
    final trimmedWardrobe = wardrobeId.trim();
    if (trimmedToken.isEmpty || trimmedWardrobe.isEmpty) {
      return null;
    }
    final item = _optionalString(itemId);
    final outfit = _optionalString(outfitId);
    if (type == ShareResourceType.item && item == null) {
      return null;
    }
    if (type == ShareResourceType.outfit && outfit == null) {
      return null;
    }
    return Share(
      token: trimmedToken,
      resourceType: type,
      wardrobeId: trimmedWardrobe,
      itemId: type == ShareResourceType.item ? item : null,
      outfitId: type == ShareResourceType.outfit ? outfit : null,
      sharePath: path,
      expiresAt: expiresAt.toUtc(),
      createdAt: createdAt.toUtc(),
    );
  }
}

/// Parses a create-share body. Soft-omits unused ids; never invents them.
Share parseShare(dynamic data) {
  if (data is! Map) {
    throw const ApiException(
      message: ShareErrors.invalidResponse,
      code: 'INVALID_RESPONSE',
    );
  }
  final json = Map<String, dynamic>.from(data);
  final token = _optionalString(json['token']);
  final type = ShareResourceType.tryParse(
    _optionalString(json['resourceType']),
  );
  final wardrobeId = _optionalString(json['wardrobeId']);
  final sharePath = ShareLandingUrl.normalizePath(
    _optionalString(json['sharePath']) ?? '',
  );
  final expiresAt = _optionalDateTime(json['expiresAt']);
  final createdAt = _optionalDateTime(json['createdAt']);
  if (token == null ||
      type == null ||
      wardrobeId == null ||
      sharePath == null ||
      expiresAt == null ||
      createdAt == null) {
    throw const ApiException(
      message: ShareErrors.invalidResponse,
      code: 'INVALID_RESPONSE',
    );
  }
  final itemId = _optionalString(json['itemId']);
  final outfitId = _optionalString(json['outfitId']);
  if (type == ShareResourceType.item && itemId == null) {
    throw const ApiException(
      message: ShareErrors.invalidResponse,
      code: 'INVALID_RESPONSE',
    );
  }
  if (type == ShareResourceType.outfit && outfitId == null) {
    throw const ApiException(
      message: ShareErrors.invalidResponse,
      code: 'INVALID_RESPONSE',
    );
  }
  return Share(
    token: token,
    resourceType: type,
    wardrobeId: wardrobeId,
    itemId: type == ShareResourceType.item ? itemId : null,
    outfitId: type == ShareResourceType.outfit ? outfitId : null,
    sharePath: sharePath,
    expiresAt: expiresAt,
    createdAt: createdAt,
  );
}
