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
  final usage = ref.read(entitlementsControllerProvider).current.usage;
  switch (action) {
    case EntitlementAction.createWardrobe:
      return _max(
        ref.read(wardrobesControllerProvider).wardrobes.length,
        usage.wardrobes,
      );
    case EntitlementAction.createItem:
      if (wardrobeId == null) {
        return usage.items;
      }
      return _max(
        ref.read(itemsControllerProvider(wardrobeId)).items.length,
        usage.items,
      );
    case EntitlementAction.createOutfit:
      if (wardrobeId == null) {
        return usage.outfits;
      }
      return _max(
        ref.read(outfitsControllerProvider(wardrobeId)).outfits.length,
        usage.outfits,
      );
    case EntitlementAction.aiTryOn:
    case EntitlementAction.otherAi:
      return 0;
  }
}

int _max(int a, int b) => a > b ? a : b;
