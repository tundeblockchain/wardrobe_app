import 'dart:typed_data';

import 'upload_ticket.dart';

/// Pre-signed upload ticket plus the follow-up S3 PUT.
abstract interface class UploadRepository {
  Future<UploadTicket> createWardrobeItemUpload({required String contentType});

  Future<void> uploadFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String contentType,
  });
}
