import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/upload_repository.dart';
import '../domain/upload_ticket.dart';
import 'upload_dtos.dart';

/// Dio implementation of [UploadRepository].
///
/// Ticket creation uses the authenticated API client. The S3 PUT uses a
/// separate client so the Firebase Bearer token is not sent to S3.
class DioUploadRepository implements UploadRepository {
  DioUploadRepository({required Dio api, required Dio uploadClient})
    : _api = api,
      _uploadClient = uploadClient;

  final Dio _api;
  final Dio _uploadClient;

  static const _path = '/uploads';

  @override
  Future<UploadTicket> createWardrobeItemUpload({required String contentType}) {
    return _guard(() async {
      final response = await _api.post<dynamic>(
        _path,
        data: CreateUploadRequest(contentType: contentType).toJson(),
      );
      return _parseTicket(response.data);
    });
  }

  @override
  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  }) {
    return _guard(() async {
      await _uploadClient.put<dynamic>(
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

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

UploadTicket _parseTicket(dynamic data) {
  if (data is Map) {
    return UploadTicketResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected upload response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [UploadRepository] using authenticated API Dio + a bare upload Dio.
final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return DioUploadRepository(
    api: ref.watch(dioProvider),
    uploadClient: ref.watch(uploadDioProvider),
  );
});
