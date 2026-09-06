import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_dtos.freezed.dart';
part 'support_dtos.g.dart';

/// `POST /support/contact` and `POST /support/bug` body.
///
/// Backend WARDROBE-38 owns delivery (Resend). Flutter only posts this DTO.
@freezed
abstract class SupportRequest with _$SupportRequest {
  const factory SupportRequest({
    required String subject,
    required String message,
    @JsonKey(includeIfNull: false) String? device,
    @JsonKey(includeIfNull: false) String? appVersion,
  }) = _SupportRequest;

  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);
}
