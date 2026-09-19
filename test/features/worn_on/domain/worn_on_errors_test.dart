import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';

void main() {
  test('maps 401 / 404 / 400 codes to clear copy', () {
    expect(
      WornOnErrors.messageFor(
        const ApiException(message: 'nope', code: 'UNAUTHENTICATED'),
      ),
      WornOnErrors.unauthenticated,
    );
    expect(
      WornOnErrors.messageFor(
        const ApiException(message: 'missing', code: 'WARDROBE_NOT_FOUND'),
      ),
      WornOnErrors.wardrobeNotFound,
    );
    expect(
      WornOnErrors.messageFor(
        const ApiException(message: 'missing', code: 'OUTFIT_NOT_FOUND'),
      ),
      WornOnErrors.outfitNotFound,
    );
    expect(
      WornOnErrors.messageFor(
        const ApiException(
          message: 'wornOn must be an ISO date (YYYY-MM-DD).',
          code: 'VALIDATION_ERROR',
        ),
      ),
      'wornOn must be an ISO date (YYYY-MM-DD).',
    );
  });

  test('maps status codes when the envelope has no known code', () {
    expect(
      WornOnErrors.messageFor(
        const ApiException(message: 'denied', statusCode: 401),
      ),
      WornOnErrors.unauthenticated,
    );
    expect(
      WornOnErrors.messageFor(
        const ApiException(message: 'bad date', statusCode: 400),
      ),
      'bad date',
    );
  });

  test('undeployed route is a 404 without ownership codes', () {
    expect(
      WornOnErrors.isUndeployedRoute(
        const ApiException(message: 'Not Found', statusCode: 404),
      ),
      isTrue,
    );
    expect(
      WornOnErrors.isUndeployedRoute(
        const ApiException(
          message: 'missing',
          code: 'OUTFIT_NOT_FOUND',
          statusCode: 404,
        ),
      ),
      isFalse,
    );
  });
}
