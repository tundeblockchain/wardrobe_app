import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';

void main() {
  test('parses known wire statuses', () {
    expect(OutfitRenderStatus.parse('PENDING'), OutfitRenderStatus.pending);
    expect(
      OutfitRenderStatus.parse('PROCESSING'),
      OutfitRenderStatus.processing,
    );
    expect(OutfitRenderStatus.parse('READY'), OutfitRenderStatus.ready);
    expect(OutfitRenderStatus.parse('FAILED'), OutfitRenderStatus.failed);
    expect(OutfitRenderStatus.parse('nope'), OutfitRenderStatus.unknown);
  });

  test('in-progress vs terminal', () {
    expect(OutfitRenderStatus.pending.isInProgress, isTrue);
    expect(OutfitRenderStatus.processing.isInProgress, isTrue);
    expect(OutfitRenderStatus.ready.isTerminal, isTrue);
    expect(OutfitRenderStatus.failed.isTerminal, isTrue);
  });

  test('hasDisplayImage requires READY imageUrl', () {
    const ready = OutfitRender(
      status: OutfitRenderStatus.ready,
      aiProfileId: 'profile_generic_01',
      imageUrl: 'https://cdn.example.com/look.png',
    );
    const pending = OutfitRender(
      status: OutfitRenderStatus.pending,
      aiProfileId: 'profile_generic_01',
    );
    expect(ready.hasDisplayImage, isTrue);
    expect(pending.hasDisplayImage, isFalse);
  });
}
