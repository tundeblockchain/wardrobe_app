import 'dart:typed_data';

import '../../items/domain/upload_ticket.dart';
import 'ai_profile.dart';
import 'ai_profile_body_context.dart';

/// AI profile CRUD, generic-model catalog, and PERSONAL reference uploads.
abstract interface class AiProfileRepository {
  Future<List<AiProfile>> listPersonal();

  Future<List<AiProfile>> listGenericModels();

  Future<AiProfile> getProfile(String aiProfileId);

  /// `POST /ai-profiles`. Empty [body] is soft-omitted (type PERSONAL only).
  Future<AiProfile> createPersonal({
    AiProfileBodyContext body = AiProfileBodyContext.empty,
  });

  /// `PATCH /ai-profiles/{aiProfileId}` for PERSONAL body/context updates.
  Future<AiProfile> updatePersonal({
    required String aiProfileId,
    required AiProfileBodyContext body,
  });

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
