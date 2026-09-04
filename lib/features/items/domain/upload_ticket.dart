import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_ticket.freezed.dart';

/// Pre-signed S3 upload ticket from `POST /uploads`.
@freezed
abstract class UploadTicket with _$UploadTicket {
  const factory UploadTicket({
    required String uploadUrl,
    required String objectKey,
    required int expiresIn,
  }) = _UploadTicket;
}
