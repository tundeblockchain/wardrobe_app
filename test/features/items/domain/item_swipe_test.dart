import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_swipe.dart';

void main() {
  const width = 320.0;
  const height = 400.0;

  group('itemBrowseSwipeEnabled', () {
    test('is false for an empty or single-item list', () {
      expect(itemBrowseSwipeEnabled(0), isFalse);
      expect(itemBrowseSwipeEnabled(1), isFalse);
    });

    test('is true when two or more items can be browsed', () {
      expect(itemBrowseSwipeEnabled(2), isTrue);
      expect(itemBrowseSwipeEnabled(5), isTrue);
    });
  });

  group('resolveItemSwipe', () {
    test('advances only on a right swipe past the distance threshold', () {
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

    test('ignores an upward swipe so a vertical scroll cannot advance', () {
      expect(
        resolveItemSwipe(
          dx: 10,
          dy: -height * 0.4,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        isNull,
      );
    });

    test('ignores a downward drag so pull-to-refresh and scroll can win', () {
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

    test('ignores a vertical-dominant drag that also moves a little right', () {
      expect(
        resolveItemSwipe(
          dx: 40,
          dy: -height * 0.5,
          vx: 200,
          vy: -900,
          width: width,
          height: height,
        ),
        isNull,
      );
    });

    test('snaps back when the drag is too short', () {
      expect(
        resolveItemSwipe(
          dx: 20,
          dy: 4,
          vx: 0,
          vy: 0,
          width: width,
          height: height,
        ),
        isNull,
      );
    });

    test('accepts a fast rightward fling below the distance threshold', () {
      expect(
        resolveItemSwipe(
          dx: 30,
          dy: 2,
          vx: 900,
          vy: 0,
          width: width,
          height: height,
        ),
        ItemSwipeDirection.right,
      );
    });

    test('accepts a fast leftward fling below the distance threshold', () {
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

    test('ignores a fast upward fling', () {
      expect(
        resolveItemSwipe(
          dx: 4,
          dy: -20,
          vx: 0,
          vy: -900,
          width: width,
          height: height,
        ),
        isNull,
      );
    });
  });

  group('itemSwipeExitOffset', () {
    test('sends the card off-screen to the left for an accepted swipe', () {
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
    });

    test('sends the card off-screen to the right for an accepted swipe', () {
      expect(
        itemSwipeExitOffset(
          direction: ItemSwipeDirection.right,
          width: width,
          height: height,
          currentDx: 40,
          currentDy: 12,
        ).dx,
        width * 1.4,
      );
    });
  });
}
