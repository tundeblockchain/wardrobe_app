import '../../../core/network/api_exception.dart';

/// Locked Backend WARDROBE-123 error codes for item reprocess.
abstract final class ItemReprocessErrorCodes {
  static const processingInProgress = 'PROCESSING_IN_PROGRESS';
  static const itemNotRetriable = 'ITEM_NOT_RETRIABLE';
  static const validation = 'VALIDATION_ERROR';
  static const notFoundItem = 'ITEM_NOT_FOUND';
  static const notFoundWardrobe = 'WARDROBE_NOT_FOUND';
  static const internal = 'INTERNAL_ERROR';

  static String normalize(String? code) => (code ?? '').trim().toUpperCase();

  /// Already queued or running — Flutter should keep polling, not snackbar.
  static bool isProcessingInProgress(ApiException error) {
    return error.statusCode == 409 &&
        normalize(error.code) == processingInProgress;
  }

  static bool isNotRetriable(ApiException error) {
    return error.statusCode == 409 && normalize(error.code) == itemNotRetriable;
  }

  /// User-facing snackbar copy for 400 / 403 / 404 / 409-not-retriable / 500.
  static String snackMessage(ApiException error) {
    final trimmed = error.message.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
    final code = normalize(error.code);
    switch (error.statusCode) {
      case 400:
      case 404:
        return 'Could not retry this item.';
      case 403:
        return 'Premium is required to retry AI processing.';
      case 409:
        if (code == itemNotRetriable) {
          return 'Only failed items can be retried.';
        }
        return 'This item cannot be retried.';
      case 500:
        return 'Could not retry processing. Please try again.';
      default:
        return 'Could not retry processing. Please try again.';
    }
  }
}
