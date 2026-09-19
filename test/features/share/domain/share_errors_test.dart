import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/share/domain/share.dart';
import 'package:wardrobe_app/features/share/domain/share_errors.dart';

void main() {
  test('maps ownership and auth codes to clear copy', () {
    expect(
      ShareErrors.messageFor(
        const ApiException(message: 'x', code: 'UNAUTHENTICATED'),
      ),
      ShareErrors.unauthenticated,
    );
    expect(
      ShareErrors.messageFor(
        const ApiException(
          message: 'x',
          code: 'ITEM_NOT_FOUND',
          statusCode: 404,
        ),
      ),
      ShareErrors.itemNotFound,
    );
    expect(
      ShareErrors.messageFor(
        const ApiException(
          message: 'x',
          code: 'OUTFIT_NOT_FOUND',
          statusCode: 404,
        ),
      ),
      ShareErrors.outfitNotFound,
    );
    expect(
      ShareErrors.messageFor(
        const ApiException(message: 'Not Found', statusCode: 404),
      ),
      ShareErrors.unavailable,
    );
  });

  test('ShareResourceType parses ITEM and OUTFIT only', () {
    expect(ShareResourceType.tryParse('ITEM'), ShareResourceType.item);
    expect(ShareResourceType.tryParse('OUTFIT'), ShareResourceType.outfit);
    expect(ShareResourceType.tryParse('WARDROBE'), isNull);
    expect(ShareResourceType.tryParse(''), isNull);
  });
}
