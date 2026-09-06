import 'dart:typed_data';

import '../../items/domain/upload_ticket.dart';
import 'ai_profile.dart';

/// AI profile CRUD, generic-model catalog, and PERSONAL reference uploads.
abstract interface class AiProfileRepository {
  Future<List<AiProfile>> listPersonal();

  Future<List<AiProfile>> listGenericModels();

  Future<AiProfile> getProfile(String aiProfileId);

  Future<AiProfile> createPersonal();

  Future<void> deletePersonal(String aiProfileId);

  Future<UploadTicket> createReferenceUpload({
    required String aiProfileId,
    required String contentType,
    int? contentLength,
  });

  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  });

  Future<AiProfile> attachReferenceImages({
    required String aiProfileId,
    String? objectKey,
    List<String>? objectKeys,
  });
}
