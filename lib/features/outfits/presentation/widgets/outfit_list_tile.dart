import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/entity_delete.dart';
import '../../domain/outfit.dart';

/// Saved-outfit row with an optional delete control on the trailing edge.
class OutfitListTile extends StatelessWidget {
  const OutfitListTile({
    super.key,
    required this.wardrobeId,
    required this.outfit,
    this.tileKey,
    this.onDelete,
  });

  final String wardrobeId;
  final Outfit outfit;
  final Key? tileKey;
  final VoidCallback? onDelete;

  static Key defaultTileKey(String outfitId) => Key('outfit_tile_$outfitId');

  static Key deleteKey(String outfitId) => Key('outfit_tile_delete_$outfitId');

  @override
  Widget build(BuildContext context) {
    final slotCount = outfit.items.length;
    return Card(
      child: ListTile(
        key: tileKey ?? defaultTileKey(outfit.id),
        leading: const CircleAvatar(child: Icon(Icons.checkroom_outlined)),
        title: Text(outfit.name),
        subtitle: Text(slotCount == 1 ? '1 item' : '$slotCount items'),
        trailing: onDelete == null
            ? const Icon(Icons.chevron_right)
            : EntityDeleteIconButton(
                key: deleteKey(outfit.id),
                tooltip: 'Delete outfit',
                onPressed: onDelete,
              ),
        onTap: () =>
            context.push(AppRoutes.outfitDetail(wardrobeId, outfit.id)),
      ),
    );
  }
}
