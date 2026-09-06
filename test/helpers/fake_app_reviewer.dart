import 'package:wardrobe_app/features/profile/domain/app_reviewer.dart';

/// Records [requestReview] calls for tests.
class FakeAppReviewer implements AppReviewer {
  int requestCalls = 0;
  Object? nextError;

  @override
  Future<void> requestReview() async {
    requestCalls++;
    final error = nextError;
    if (error != null) {
      nextError = null;
      throw error;
    }
  }
}
