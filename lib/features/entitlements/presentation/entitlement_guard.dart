import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../items/application/items_controller.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../application/entitlements_controller.dart';
import '../data/paywall_gateway_provider.dart';
import '../domain/entitlement_action.dart';

/// Soft-gate: present Superwall when the current entitlement blocks [action].
///
/// Returns `true` when the user may continue (already entitled, or entitled
/// after purchase/restore).
Future<bool> ensureEntitled(
  BuildContext context,
  WidgetRef ref,
  EntitlementAction action, {
  String? wardrobeId,
}) async {
  final count = entitlementCountFor(ref, action, wardrobeId: wardrobeId);
  final entitlement = ref.read(entitlementsControllerProvider).current;
  if (action.isAllowed(entitlement, currentCount: count)) {
    return true;
  }
  await ref
      .read(paywallGatewayProvider)
      .present(placement: action.placement, context: context);
  if (!context.mounted) {
    return false;
  }
  await ref.read(entitlementsControllerProvider.notifier).refresh();
  final next = ref.read(entitlementsControllerProvider).current;
  return action.isAllowed(next, currentCount: count);
}

/// Pushes [location] only when [action] is allowed (after an optional paywall).
Future<void> pushIfEntitled(
  BuildContext context,
  WidgetRef ref,
  EntitlementAction action,
  String location, {
  String? wardrobeId,
}) async {
  final allowed = await ensureEntitled(
    context,
    ref,
    action,
    wardrobeId: wardrobeId,
  );
  if (!allowed || !context.mounted) {
    return;
  }
  context.push(location);
}

int entitlementCountFor(
  WidgetRef ref,
  EntitlementAction action, {
  String? wardrobeId,
}) {
  switch (action) {
    case EntitlementAction.createWardrobe:
      return ref.read(wardrobesControllerProvider).wardrobes.length;
    case EntitlementAction.createItem:
      if (wardrobeId == null) {
        return 0;
      }
      return ref.read(itemsControllerProvider(wardrobeId)).items.length;
    case EntitlementAction.createOutfit:
      if (wardrobeId == null) {
        return 0;
      }
      return ref.read(outfitsControllerProvider(wardrobeId)).outfits.length;
    case EntitlementAction.aiTryOn:
    case EntitlementAction.otherAi:
      return 0;
  }
}
