import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_status_display.dart';

void main() {
  test('maps READY / PROCESSING / FAILED for the UI', () {
    expect(AiProfileStatusDisplay.of(AiProfileStatus.ready).label, 'Ready');
    expect(
      AiProfileStatusDisplay.of(AiProfileStatus.processing).tone,
      AiProfileStatusTone.processing,
    );
    expect(AiProfileStatusDisplay.of(AiProfileStatus.failed).label, 'Failed');
    expect(AiProfileStatusDisplay.of(AiProfileStatus.pending).label, 'Pending');
  });
}
