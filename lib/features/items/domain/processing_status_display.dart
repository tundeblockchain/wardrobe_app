import 'item.dart';

/// Visual tone used by status chips and the item-detail banner.
enum ProcessingStatusTone { pending, processing, ready, failed, unknown }

/// Presentation mapping for [ItemProcessingStatus].
class ProcessingStatusDisplay {
  const ProcessingStatusDisplay({
    required this.status,
    required this.label,
    required this.tone,
    required this.detailMessage,
  });

  final ItemProcessingStatus status;
  final String label;
  final ProcessingStatusTone tone;
  final String detailMessage;

  /// Maps a wire/domain status (and optional failure text) to UI copy.
  static ProcessingStatusDisplay of(
    ItemProcessingStatus status, {
    String? processingError,
  }) {
    switch (status) {
      case ItemProcessingStatus.pending:
        return const ProcessingStatusDisplay(
          status: ItemProcessingStatus.pending,
          label: 'Pending',
          tone: ProcessingStatusTone.pending,
          detailMessage: 'Queued for processing.',
        );
      case ItemProcessingStatus.processing:
        return const ProcessingStatusDisplay(
          status: ItemProcessingStatus.processing,
          label: 'Processing',
          tone: ProcessingStatusTone.processing,
          detailMessage: 'Still working on this item.',
        );
      case ItemProcessingStatus.ready:
        return const ProcessingStatusDisplay(
          status: ItemProcessingStatus.ready,
          label: 'Ready',
          tone: ProcessingStatusTone.ready,
          detailMessage: 'Processing complete.',
        );
      case ItemProcessingStatus.failed:
        return ProcessingStatusDisplay(
          status: ItemProcessingStatus.failed,
          label: 'Failed',
          tone: ProcessingStatusTone.failed,
          detailMessage: _failedMessage(processingError),
        );
      case ItemProcessingStatus.unknown:
        return const ProcessingStatusDisplay(
          status: ItemProcessingStatus.unknown,
          label: 'Unknown',
          tone: ProcessingStatusTone.unknown,
          detailMessage: 'Status is unavailable.',
        );
    }
  }

  static String _failedMessage(String? processingError) {
    final trimmed = processingError?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Processing failed.';
    }
    return trimmed;
  }
}
