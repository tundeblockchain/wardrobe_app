import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../items/domain/upload_ticket.dart';
import '../domain/ai_profile.dart';
import '../domain/ai_profile_repository.dart';
import 'ai_profile_body_mapping.dart';
import 'ai_profile_dtos.dart';
import 'ai_profile_image_urls.dart';

/// Dio implementation of [AiProfileRepository] against `/ai-profiles`.
class DioAiProfileRepository implements AiProfileRepository {
  DioAiProfileRepository({required this.api, required this.uploadClient});

  final Dio api;
  final Dio uploadClient;

  static const _collection = '/ai-profiles';
  static const _models = '/ai-profiles/models';

  String _profilePath(String aiProfileId) => '$_collection/$aiProfileId';

  String _uploadsPath(String aiProfileId) =>
      '${_profilePath(aiProfileId)}/uploads';

  String _referenceImagesPath(String aiProfileId) =>
      '${_profilePath(aiProfileId)}/reference-images';

  @override
  Future<List<AiProfile>> listPersonal() {
    return _guard(() async {
      final response = await api.get<dynamic>(_collection);
      return parseAiProfileList(response.data);
    });
  }

  @override
  Future<List<AiProfile>> listGenericModels() {
    return _guard(() async {
      final response = await api.get<dynamic>(_models);
      return parseAiProfileList(response.data);
    });
  }

  @override
  Future<AiProfile> getProfile(String aiProfileId) {
    return _guard(() async {
      final response = await api.get<dynamic>(_profilePath(aiProfileId));
      return parseAiProfile(response.data);
    });
  }

  @override
  Future<AiProfile> createPersonal() {
    return _guard(() async {
      final response = await api.post<dynamic>(
        _collection,
        data: const CreateAiProfileRequest().toJson(),
      );
      return parseAiProfile(response.data);
    });
  }

  @override
  Future<void> deletePersonal(String aiProfileId) {
    return _guard(() async {
      await api.delete<dynamic>(_profilePath(aiProfileId));
    });
  }

  @override
  Future<UploadTicket> createReferenceUpload({
    required String aiProfileId,
    required String contentType,
    int? contentLength,
  }) {
    return _guard(() async {
      final response = await api.post<dynamic>(
        _uploadsPath(aiProfileId),
        data: CreateAiProfileUploadRequest(
          contentType: contentType,
          contentLength: contentLength,
        ).toJson(),
      );
      return parseAiProfileUpload(response.data);
    });
  }

  @override
  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  }) {
    return _guard(() async {
      await uploadClient.put<dynamic>(
        uploadUrl,
        data: bytes,
        options: Options(
          contentType: contentType,
          headers: <String, dynamic>{
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: bytes.length,
          },
        ),
      );
    });
  }

  @override
  Future<AiProfile> attachReferenceImages({
    required String aiProfileId,
    String? objectKey,
    List<String>? objectKeys,
  }) {
    return _guard(() async {
      final response = await api.post<dynamic>(
        _referenceImagesPath(aiProfileId),
        data: AttachAiProfileImagesRequest(
          objectKey: objectKey,
          objectKeys: objectKeys,
        ).toJson(),
      );
      return parseAiProfile(response.data);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

/// Parses `{ "aiProfiles": [...] }` or a bare array.
List<AiProfile> parseAiProfileList(dynamic data) {
  if (data is List) {
    return data.whereType<Map>().map(mapAiProfileJson).toList();
  }
  if (data is Map) {
    final json = Map<String, dynamic>.from(data);
    final profiles = json['aiProfiles'];
    if (profiles is List) {
      return profiles.whereType<Map>().map(mapAiProfileJson).toList();
    }
    return AiProfileListResponse.fromJson(json).toDomain();
  }
  throw const ApiException(
    message: 'Unexpected AI profiles response.',
    code: 'INVALID_RESPONSE',
  );
}

AiProfile parseAiProfile(dynamic data) {
  if (data is Map) {
    return mapAiProfileJson(data);
  }
  throw const ApiException(
    message: 'Unexpected AI profile response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Maps get/list JSON, including optional WARDROBE-72 image URL aliases.
AiProfile mapAiProfileJson(Map<dynamic, dynamic> data) {
  final json = Map<String, dynamic>.from(data);
  final normalized = Map<String, dynamic>.from(json);
  normalized['referenceImages'] = parseReferenceImageKeys(
    json['referenceImages'],
  );
  final domain = AiProfileResponse.fromJson(normalized).toDomain();
  return domain.copyWith(
    previewImageUrl: extractAiProfileImageUrl(json),
    bodyContext: parseAiProfileBodyContext(json),
  );
}

UploadTicket parseAiProfileUpload(dynamic data) {
  if (data is Map) {
    return parseAiProfileUploadTicket(Map<String, dynamic>.from(data));
  }
  throw const ApiException(
    message: 'Unexpected upload response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [AiProfileRepository] using authenticated API Dio + a bare upload Dio.
final aiProfileRepositoryProvider = Provider<AiProfileRepository>((ref) {
  return DioAiProfileRepository(
    api: ref.watch(dioProvider),
    uploadClient: ref.watch(uploadDioProvider),
  );
});
