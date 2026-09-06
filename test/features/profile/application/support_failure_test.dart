import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/profile/application/support_failure.dart';

void main() {
  test('maps missing support endpoints to a friendly message', () {
    expect(
      messageForSupportFailure(
        const ApiException(
          message: 'Not found.',
          code: 'NOT_FOUND',
          statusCode: 404,
        ),
      ),
      "Support isn't available yet. Please try again later.",
    );
    expect(
      messageForSupportFailure(
        const ApiException(message: 'Nope', statusCode: 501),
      ),
      "Support isn't available yet. Please try again later.",
    );
  });

  test('keeps other API messages', () {
    expect(
      messageForSupportFailure(
        const ApiException(
          message: 'Unable to reach the server. Check your connection.',
          code: 'NETWORK_ERROR',
        ),
      ),
      'Unable to reach the server. Check your connection.',
    );
  });

  test('maps unexpected errors', () {
    expect(
      messageForSupportFailure(StateError('boom')),
      'Something went wrong. Please try again.',
    );
  });
}
