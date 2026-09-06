/// Swipe directions that advance the wardrobe item card stack.
enum ItemSwipeDirection { left, right, up }

/// A single item stays a static large card (WARDROBE-55). Swipe needs 2+.
bool itemBrowseSwipeEnabled(int itemCount) => itemCount > 1;

/// Distance fraction of the card size that counts as a completed swipe.
const itemSwipeDistanceFraction = 0.25;

/// Velocity (logical px/s) that counts as a fling even if distance is short.
const itemSwipeFlingVelocity = 800.0;

/// Resolves a pan into a stack-advance swipe, or `null` to snap back.
///
/// Left, right, and up all mean "next item". Down is ignored so it does not
/// fight pull-to-refresh on the wardrobe detail screen.
ItemSwipeDirection? resolveItemSwipe({
  required double dx,
  required double dy,
  required double vx,
  required double vy,
  required double width,
  required double height,
}) {
  final absDx = dx.abs();
  final absDy = dy.abs();
  final cardWidth = width <= 0 ? 320.0 : width;
  final cardHeight = height <= 0 ? 420.0 : height;

  final crossedHorizontal = absDx >= cardWidth * itemSwipeDistanceFraction;
  final crossedVertical = absDy >= cardHeight * itemSwipeDistanceFraction;
  final flungHorizontal = vx.abs() >= itemSwipeFlingVelocity;
  final flungUp = vy <= -itemSwipeFlingVelocity;

  if (absDx >= absDy) {
    if (crossedHorizontal || flungHorizontal) {
      return dx < 0 ? ItemSwipeDirection.left : ItemSwipeDirection.right;
    }
    return null;
  }
  if (dy < 0 && (crossedVertical || flungUp)) {
    return ItemSwipeDirection.up;
  }
  return null;
}

/// Off-screen translation used to finish a dismiss animation.
({double dx, double dy}) itemSwipeExitOffset({
  required ItemSwipeDirection direction,
  required double width,
  required double height,
  required double currentDx,
  required double currentDy,
}) {
  final cardWidth = width <= 0 ? 320.0 : width;
  final cardHeight = height <= 0 ? 420.0 : height;
  switch (direction) {
    case ItemSwipeDirection.left:
      return (dx: -cardWidth * 1.4, dy: currentDy);
    case ItemSwipeDirection.right:
      return (dx: cardWidth * 1.4, dy: currentDy);
    case ItemSwipeDirection.up:
      return (dx: currentDx, dy: -cardHeight * 1.4);
  }
}
