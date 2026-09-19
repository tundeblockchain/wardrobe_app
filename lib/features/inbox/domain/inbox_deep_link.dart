import '../../../core/router/app_routes.dart';
import 'job_event.dart';

/// Maps a job-done payload to an in-app route (WARDROBE-115).
///
/// Item jobs open item detail. Try-on jobs open the outfit render route.
abstract final class InboxDeepLink {
  static String? locationFor(JobEvent event) {
    final wardrobeId = event.wardrobeId.trim();
    if (wardrobeId.isEmpty) {
      return null;
    }
    final itemId = event.itemId?.trim();
    if (itemId != null && itemId.isNotEmpty) {
      return AppRoutes.itemDetail(wardrobeId, itemId);
    }
    final outfitId = event.outfitId?.trim();
    if (outfitId != null && outfitId.isNotEmpty) {
      return AppRoutes.tryOn(wardrobeId, outfitId);
    }
    return AppRoutes.wardrobeDetail(wardrobeId);
  }

  /// Push data values are all strings (WARDROBE-114).
  static JobEvent? fromPushData(Map<String, String> data) {
    final eventId = _trim(data['eventId']);
    final wardrobeId = _trim(data['wardrobeId']);
    if (eventId == null || wardrobeId == null) {
      return null;
    }
    return JobEvent(
      eventId: eventId,
      jobType: JobEventType.parse(data['jobType']),
      status: JobEventStatus.parse(data['status']),
      wardrobeId: wardrobeId,
      itemId: _trim(data['itemId']),
      outfitId: _trim(data['outfitId']),
      renderId: _trim(data['renderId']),
      aiProfileId: _trim(data['aiProfileId']),
      error: _trim(data['error']),
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  static String? _trim(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
