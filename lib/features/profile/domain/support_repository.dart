/// Backend support contract (WARDROBE-38). Flutter never talks to Resend.
///
/// Contact and bug reports must `POST` to `/support/contact` and `/support/bug`
/// only, with `{ subject, body, replyTo?, meta? }`. Do not fall back to mailto
/// or any email SDK.
abstract interface class SupportRepository {
  Future<void> sendContact({
    required String subject,
    required String body,
    String? replyTo,
    Map<String, String>? meta,
  });

  Future<void> sendBug({
    required String subject,
    required String body,
    String? replyTo,
    Map<String, String>? meta,
  });
}
