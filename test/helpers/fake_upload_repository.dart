import 'dart:typed_data';

import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/upload_repository.dart';
import 'package:wardrobe_app/features/items/domain/upload_ticket.dart';

/// In-memory [UploadRepository] for unit tests.
class FakeUploadRepository implements UploadRepository {
  ApiException? nextFailure;
  int? failOnCreateCall;
  int createCalls = 0;
  int uploadCalls = 0;
  String? lastContentType;
  String? lastUploadUrl;
  Uint8List? lastBytes;

  @override
  Future<UploadTicket> createWardrobeItemUpload({
    required String contentType,
  }) async {
    createCalls++;
    lastContentType = contentType;
    if (failOnCreateCall == createCalls) {
      throw nextFailure ??
          const ApiException(
            message: 'Upload ticket failed.',
            code: 'UPLOAD_INVALID',
          );
    }
    _maybeFail();
    final suffix = createCalls == 1 ? '' : '$createCalls';
    return UploadTicket(
      uploadUrl: 'https://s3.example.com/uploads/uuid$suffix.jpg',
      objectKey: 'users/uid/uploads/uuid$suffix.jpg',
      expiresIn: 900,
    );
  }

  @override
  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  }) async {
    uploadCalls++;
    lastUploadUrl = uploadUrl;
    lastBytes = bytes;
    lastContentType = contentType;
    _maybeFail();
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}
