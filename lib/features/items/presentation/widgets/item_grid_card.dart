import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/item.dart';

/// Grid tile showing name and category.
class ItemGridCard extends StatelessWidget {
  const ItemGridCard({super.key, required this.wardrobeId, required this.item});

  final String wardrobeId;
  final Item item;

  static Key cardKey(String itemId) => Key('item_card_$itemId');

  @override
  Widget build(BuildContext context) {
    return Card(
      key: cardKey(item.id),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.itemDetail(wardrobeId, item.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(child: Text(item.category.label[0])),
              const Spacer(),
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                [
                  item.category.label,
                  if (item.brand != null && item.brand!.isNotEmpty) item.brand,
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
