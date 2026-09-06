import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_dtos.freezed.dart';
part 'support_dtos.g.dart';

/// `POST /support/contact` and `POST /support/bug` body (WARDROBE-38).
///
/// Backend owns Resend. Flutter only posts this DTO — never mailto or a
/// Resend SDK.
@freezed
abstract class SupportRequest with _$SupportRequest {
  const factory SupportRequest({
    required String subject,
    required String body,
    @JsonKey(includeIfNull: false) String? replyTo,
    @JsonKey(includeIfNull: false) Map<String, String>? meta,
  }) = _SupportRequest;

  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);
}
