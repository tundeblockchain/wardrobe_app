/// Backend support contract (WARDROBE-38). Flutter never talks to Resend.
///
/// Contact and bug reports must `POST` to `/support/contact` and `/support/bug`
/// only. Do not fall back to mailto or any email SDK.
abstract interface class SupportRepository {
  Future<void> sendContact({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  });

  Future<void> sendBug({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  });
}
