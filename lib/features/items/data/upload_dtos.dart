import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/upload_ticket.dart';

part 'upload_dtos.freezed.dart';
part 'upload_dtos.g.dart';

/// `POST /uploads` body.
@freezed
abstract class CreateUploadRequest with _$CreateUploadRequest {
  const factory CreateUploadRequest({
    required String contentType,
    @Default('WARDROBE_ITEM') String purpose,
  }) = _CreateUploadRequest;

  factory CreateUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUploadRequestFromJson(json);
}

/// `POST /uploads` response. Maps onto domain [UploadTicket].
@freezed
abstract class UploadTicketResponse with _$UploadTicketResponse {
  const UploadTicketResponse._();

  const factory UploadTicketResponse({
    required String uploadUrl,
    required String objectKey,
    required int expiresIn,
  }) = _UploadTicketResponse;

  factory UploadTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadTicketResponseFromJson(json);

  UploadTicket toDomain() {
    return UploadTicket(
      uploadUrl: uploadUrl,
      objectKey: objectKey,
      expiresIn: expiresIn,
    );
  }
}
