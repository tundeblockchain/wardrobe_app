import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit_render.freezed.dart';

/// Backend `render.status` values (WARDROBE-47).
enum OutfitRenderStatus {
  pending('PENDING', 'Pending'),
  processing('PROCESSING', 'Processing'),
  ready('READY', 'Ready'),
  failed('FAILED', 'Failed'),
  unknown('UNKNOWN', 'Unknown');

  const OutfitRenderStatus(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static OutfitRenderStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return OutfitRenderStatus.unknown;
    }
    for (final status in OutfitRenderStatus.values) {
      if (status.wireValue == value) {
        return status;
      }
    }
    return OutfitRenderStatus.unknown;
  }

  bool get isInProgress =>
      this == OutfitRenderStatus.pending ||
      this == OutfitRenderStatus.processing;

  bool get isTerminal =>
      this == OutfitRenderStatus.ready || this == OutfitRenderStatus.failed;
}

/// Latest try-on render for an outfit. Backend `imageUrl` is a short-lived
/// presigned GET — display that, never invent a URL from [imageKey].
@freezed
abstract class OutfitRender with _$OutfitRender {
  const OutfitRender._();

  const factory OutfitRender({
    required OutfitRenderStatus status,
    required String aiProfileId,
    String? imageKey,
    String? imageUrl,
    String? error,
  }) = _OutfitRender;

  bool get hasDisplayImage {
    final url = imageUrl?.trim();
    return status == OutfitRenderStatus.ready && url != null && url.isNotEmpty;
  }
}
