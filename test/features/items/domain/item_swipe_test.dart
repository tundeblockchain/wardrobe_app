import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_swipe.dart';

void main() {
  const width = 320.0;
  const height = 400.0;

  group('resolveItemSwipe', () {
    test('advances on a left swipe past the distance threshold', () {
      expect(
        resolveItemSwipe(
          dx: -width * 0.4,
          dy: 8,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.left,
      );
    });

    test('advances on a right swipe past the distance threshold', () {
      expect(
        resolveItemSwipe(
          dx: width * 0.4,
          dy: -6,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.right,
      );
    });

    test('advances on an upward swipe', () {
      expect(
        resolveItemSwipe(
          dx: 10,
          dy: -height * 0.4,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.up,
      );
    });

    test('ignores a downward drag so pull-to-refresh can win', () {
      expect(
        resolveItemSwipe(
          dx: 0,
          dy: height * 0.5,
          vx: 0,
          vy: 900,
          width: width,
          height: height,
        ),
        isNull,
      );
    });

    test('snaps back when the drag is too short', () {
      expect(
        resolveItemSwipe(
          dx: -20,
          dy: 4,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        isNull,
      );
    });

    test('accepts a fast horizontal fling below the distance threshold', () {
      expect(
        resolveItemSwipe(
          dx: -30,
          dy: 2,
          vx: -900,
          vy: 0,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.left,
      );
    });

    test('accepts a fast upward fling', () {
      expect(
        resolveItemSwipe(
          dx: 4,
          dy: -20,
          vx: 0,
          vy: -900,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.up,
      );
    });
  });

  group('itemSwipeExitOffset', () {
    test('sends the card off-screen in the swipe direction', () {
      expect(
        itemSwipeExitOffset(
          direction: ItemSwipeDirection.left,
          width: width,
          height: height,
          currentDx: -40,
          currentDy: 12,
        ).dx,
        -width * 1.4,
      );
      expect(
        itemSwipeExitOffset(
          direction: ItemSwipeDirection.up,
          width: width,
          height: height,
          currentDx: 8,
          currentDy: -20,
        ).dy,
        -height * 1.4,
      );
    });
  });
}
