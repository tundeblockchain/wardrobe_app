import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/profile/data/support_dtos.dart';
import 'package:wardrobe_app/features/profile/domain/support_repository.dart';

/// In-memory [SupportRepository] for unit and widget tests.
class FakeSupportRepository implements SupportRepository {
  int contactCalls = 0;
  int bugCalls = 0;
  SupportRequest? lastRequest;
  ApiException? nextFailure;

  @override
  Future<void> sendContact({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  }) {
    return _record(
      isBug: false,
      subject: subject,
      message: message,
      device: device,
      appVersion: appVersion,
    );
  }

  @override
  Future<void> sendBug({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  }) {
    return _record(
      isBug: true,
      subject: subject,
      message: message,
      device: device,
      appVersion: appVersion,
    );
  }

  Future<void> _record({
    required bool isBug,
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  }) async {
    lastRequest = SupportRequest(
      subject: subject,
      message: message,
      device: device,
      appVersion: appVersion,
    );
    if (isBug) {
      bugCalls++;
    } else {
      contactCalls++;
    }
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}
