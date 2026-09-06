import 'ai_profile.dart';

/// Visual tone used by AI-profile status chips and banners.
enum AiProfileStatusTone { pending, processing, ready, failed, unknown }

/// Presentation mapping for [AiProfileStatus].
class AiProfileStatusDisplay {
  const AiProfileStatusDisplay({
    required this.status,
    required this.label,
    required this.tone,
    required this.detailMessage,
  });

  final AiProfileStatus status;
  final String label;
  final AiProfileStatusTone tone;
  final String detailMessage;

  static AiProfileStatusDisplay of(AiProfileStatus status) {
    switch (status) {
      case AiProfileStatus.pending:
        return const AiProfileStatusDisplay(
          status: AiProfileStatus.pending,
          label: 'Pending',
          tone: AiProfileStatusTone.pending,
          detailMessage: 'Queued for processing.',
        );
      case AiProfileStatus.processing:
        return const AiProfileStatusDisplay(
          status: AiProfileStatus.processing,
          label: 'Processing',
          tone: AiProfileStatusTone.processing,
          detailMessage: 'Still working on this profile.',
        );
      case AiProfileStatus.ready:
        return const AiProfileStatusDisplay(
          status: AiProfileStatus.ready,
          label: 'Ready',
          tone: AiProfileStatusTone.ready,
          detailMessage: 'Ready for try-on.',
        );
      case AiProfileStatus.failed:
        return const AiProfileStatusDisplay(
          status: AiProfileStatus.failed,
          label: 'Failed',
          tone: AiProfileStatusTone.failed,
          detailMessage: 'Processing failed. Try another photo.',
        );
      case AiProfileStatus.unknown:
        return const AiProfileStatusDisplay(
          status: AiProfileStatus.unknown,
          label: 'Unknown',
          tone: AiProfileStatusTone.unknown,
          detailMessage: 'Status is unavailable.',
        );
    }
  }
}
