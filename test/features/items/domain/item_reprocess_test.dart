import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item_reprocess.dart';

void main() {
  group('ItemReprocessErrorCodes', () {
    test('detects 409 PROCESSING_IN_PROGRESS only', () {
      expect(
        ItemReprocessErrorCodes.isProcessingInProgress(
          const ApiException(
            message: 'Item is already processing.',
            code: 'PROCESSING_IN_PROGRESS',
            statusCode: 409,
          ),
        ),
        isTrue,
      );
      expect(
        ItemReprocessErrorCodes.isProcessingInProgress(
          const ApiException(
            message: 'Only FAILED items can be retried.',
            code: 'ITEM_NOT_RETRIABLE',
            statusCode: 409,
          ),
        ),
        isFalse,
      );
      expect(
        ItemReprocessErrorCodes.isNotRetriable(
          const ApiException(
            message: 'Only FAILED items can be retried.',
            code: 'item_not_retriable',
            statusCode: 409,
          ),
        ),
        isTrue,
      );
    });

    test('prefers the backend message for snackbars', () {
      expect(
        ItemReprocessErrorCodes.snackMessage(
          const ApiException(
            message: 'Item has no original image to reprocess.',
            code: 'VALIDATION_ERROR',
            statusCode: 400,
          ),
        ),
        'Item has no original image to reprocess.',
      );
      expect(
        ItemReprocessErrorCodes.snackMessage(
          const ApiException(
            message: '   ',
            code: 'INTERNAL_ERROR',
            statusCode: 500,
          ),
        ),
        'Could not retry processing. Please try again.',
      );
    });
  });
}
