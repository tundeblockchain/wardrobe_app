import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/processing_status_display.dart';

void main() {
  group('ProcessingStatusDisplay', () {
    test('maps PENDING to pending copy', () {
      final display = ProcessingStatusDisplay.of(ItemProcessingStatus.pending);
      expect(display.label, 'Pending');
      expect(display.tone, ProcessingStatusTone.pending);
      expect(display.detailMessage, 'Queued for processing.');
    });

    test('maps PROCESSING to processing copy', () {
      final display = ProcessingStatusDisplay.of(
        ItemProcessingStatus.processing,
      );
      expect(display.label, 'Processing');
      expect(display.tone, ProcessingStatusTone.processing);
      expect(display.detailMessage, 'Still working on this item.');
    });

    test('maps READY to ready copy', () {
      final display = ProcessingStatusDisplay.of(ItemProcessingStatus.ready);
      expect(display.label, 'Ready');
      expect(display.tone, ProcessingStatusTone.ready);
      expect(display.detailMessage, 'Processing complete.');
    });

    test('maps FAILED to a default message when none is provided', () {
      final display = ProcessingStatusDisplay.of(ItemProcessingStatus.failed);
      expect(display.label, 'Failed');
      expect(display.tone, ProcessingStatusTone.failed);
      expect(display.detailMessage, 'Processing failed.');
    });

    test('uses the failed message when available', () {
      final display = ProcessingStatusDisplay.of(
        ItemProcessingStatus.failed,
        processingError: '  rembg rejected the image  ',
      );
      expect(display.detailMessage, 'rembg rejected the image');
    });

    test('maps UNKNOWN for unexpected wire values', () {
      expect(
        ItemProcessingStatus.parse('NOT_A_STATUS'),
        ItemProcessingStatus.unknown,
      );
      final display = ProcessingStatusDisplay.of(ItemProcessingStatus.unknown);
      expect(display.label, 'Unknown');
      expect(display.tone, ProcessingStatusTone.unknown);
    });

    test('FAILED is terminal and ERROR is not treated as processing', () {
      expect(ItemProcessingStatus.parse('FAILED').isTerminal, isTrue);
      expect(ItemProcessingStatus.parse('FAILED').isInProgress, isFalse);
      expect(ItemProcessingStatus.parse('READY').isTerminal, isTrue);
      expect(ItemProcessingStatus.parse('PROCESSING').isInProgress, isTrue);
      expect(ItemProcessingStatus.parse('PENDING').isInProgress, isTrue);
      expect(ItemProcessingStatus.parse('ERROR'), ItemProcessingStatus.unknown);
      expect(ItemProcessingStatus.parse('ERROR').isInProgress, isFalse);

      final display = ProcessingStatusDisplay.of(ItemProcessingStatus.failed);
      expect(display.label, isNot('Processing'));
      expect(display.tone, ProcessingStatusTone.failed);
    });
  });
}
