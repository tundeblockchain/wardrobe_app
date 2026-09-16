import 'entitlement.dart';
import 'paywall_placement.dart';

/// Soft-gate actions the UI checks before mutating or opening AI flows.
enum EntitlementAction {
  createWardrobe,
  createItem,
  createOutfit,
  aiTryOn,
  otherAi,
}

extension EntitlementActionX on EntitlementAction {
  PaywallPlacement get placement {
    switch (this) {
      case EntitlementAction.createWardrobe:
        return PaywallPlacement.wardrobeLimit;
      case EntitlementAction.createItem:
        return PaywallPlacement.itemLimit;
      case EntitlementAction.createOutfit:
        return PaywallPlacement.outfitLimit;
      case EntitlementAction.aiTryOn:
        return PaywallPlacement.aiTryOn;
      case EntitlementAction.otherAi:
        return PaywallPlacement.otherAi;
    }
  }

  bool isAllowed(Entitlement entitlement, {int currentCount = 0}) {
    switch (this) {
      case EntitlementAction.createWardrobe:
        return entitlement.canCreateWardrobe(currentCount);
      case EntitlementAction.createItem:
        return entitlement.canCreateItem(currentCount);
      case EntitlementAction.createOutfit:
        return entitlement.canCreateOutfit(currentCount);
      case EntitlementAction.aiTryOn:
        return entitlement.canUseAiTryOn;
      case EntitlementAction.otherAi:
        return entitlement.canUseOtherAi;
    }
  }
}
