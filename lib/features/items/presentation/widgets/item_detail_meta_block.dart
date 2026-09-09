import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/item.dart';
import '../../domain/item_detail_meta.dart';
import '../../domain/item_taxonomy.dart';

/// Stylish burgundy/plum card for category, colours, brand, wardrobes, outfits.
///
/// The four attribute rows always render. Empty values use
/// [ItemDetailMeta.emptyPlaceholder] instead of hiding.
class ItemDetailMetaBlock extends StatelessWidget {
  const ItemDetailMetaBlock({
    super.key,
    required this.item,
    this.wardrobes = const [],
    this.outfits = const [],
    this.onWardrobeTap,
    this.onOutfitTap,
  });

  final Item item;
  final List<ItemDetailMetaLink> wardrobes;
  final List<ItemDetailMetaLink> outfits;
  final ValueChanged<String>? onWardrobeTap;
  final ValueChanged<String>? onOutfitTap;

  static const blockKey = Key('item_detail_meta');
  static const categoryRowKey = Key('item_detail_meta_category');
  static const subcategoryRowKey = Key('item_detail_meta_subcategory');
  static const coloursRowKey = Key('item_detail_meta_colours');
  static const brandRowKey = Key('item_detail_meta_brand');
  static const wardrobesSectionKey = Key('item_detail_meta_wardrobes');
  static const outfitsSectionKey = Key('item_detail_meta_outfits');

  static Key wardrobeChipKey(String id) => Key('item_detail_meta_wardrobe_$id');

  static Key outfitChipKey(String id) => Key('item_detail_meta_outfit_$id');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colourWires = ItemDetailMeta.colourWires(item);
    final brand = ItemDetailMeta.brandLabel(item);
    final subcategory = ItemDetailMeta.subcategoryLabel(item);

    return Card(
      key: blockKey,
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionHeader(icon: Icons.style_outlined, label: 'Details'),
            const SizedBox(height: AppSpacing.md),
            _MetaRow(
              rowKey: categoryRowKey,
              label: 'Category',
              child: _ValueText(ItemDetailMeta.categoryLabel(item)),
            ),
            const _MetaDivider(),
            _MetaRow(
              rowKey: subcategoryRowKey,
              label: 'Subcategory',
              child: _ValueText(subcategory),
            ),
            const _MetaDivider(),
            _MetaRow(
              rowKey: coloursRowKey,
              label: 'Colours',
              child: colourWires.isEmpty
                  ? const _ValueText(ItemDetailMeta.emptyPlaceholder)
                  : Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final wire in colourWires) _ColourChip(wire: wire),
                      ],
                    ),
            ),
            const _MetaDivider(),
            _MetaRow(
              rowKey: brandRowKey,
              label: 'Brand',
              child: _ValueText(brand),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionHeader(
              icon: Icons.checkroom_outlined,
              label: 'Wardrobes',
            ),
            const SizedBox(height: AppSpacing.sm),
            _LinkWrap(
              sectionKey: wardrobesSectionKey,
              links: wardrobes,
              chipKey: wardrobeChipKey,
              onTap: onWardrobeTap,
              icon: Icons.door_sliding_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionHeader(
              icon: Icons.dry_cleaning_outlined,
              label: 'Outfits',
            ),
            const SizedBox(height: AppSpacing.sm),
            _LinkWrap(
              sectionKey: outfitsSectionKey,
              links: outfits,
              chipKey: outfitChipKey,
              onTap: onOutfitTap,
              icon: Icons.checkroom_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: Icon(icon, size: 18, color: scheme.onPrimaryContainer),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: scheme.primary,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _MetaDivider extends StatelessWidget {
  const _MetaDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outlineVariant
            .withValues(alpha: 0.7),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.rowKey,
    required this.label,
    required this.child,
  });

  final Key rowKey;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KeyedSubtree(
      key: rowKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final empty = ItemDetailMeta.isPlaceholder(value);
    return Text(
      value,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: empty
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
        fontStyle: empty ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}

class _ColourChip extends StatelessWidget {
  const _ColourChip({required this.wire});

  final String wire;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parsed = ItemColour.tryParse(wire);
    final label = ItemDetailMeta.colourLabel(wire);
    final fill = parsed == null ? null : _swatchFor(parsed, scheme);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: AppRadii.chip,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fill != null) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: scheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

class _LinkWrap extends StatelessWidget {
  const _LinkWrap({
    required this.sectionKey,
    required this.links,
    required this.chipKey,
    required this.icon,
    this.onTap,
  });

  final Key sectionKey;
  final List<ItemDetailMetaLink> links;
  final Key Function(String id) chipKey;
  final IconData icon;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: links.isEmpty
          ? const _ValueText(ItemDetailMeta.emptyPlaceholder)
          : Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final link in links)
                  ActionChip(
                    key: chipKey(link.id),
                    avatar: Icon(icon, size: 16),
                    label: Text(link.label),
                    onPressed: () => onTap?.call(link.id),
                  ),
              ],
            ),
    );
  }
}

Color _swatchFor(ItemColour colour, ColorScheme scheme) {
  switch (colour) {
    case ItemColour.black:
      return const Color(0xFF1A1214);
    case ItemColour.white:
      return const Color(0xFFF7F2F4);
    case ItemColour.grey:
      return const Color(0xFF8A7A80);
    case ItemColour.red:
      return const Color(0xFFC62828);
    case ItemColour.blue:
      return const Color(0xFF1565C0);
    case ItemColour.green:
      return const Color(0xFF2E7D32);
    case ItemColour.yellow:
      return const Color(0xFFF9A825);
    case ItemColour.orange:
      return const Color(0xFFEF6C00);
    case ItemColour.pink:
      return const Color(0xFFD81B60);
    case ItemColour.purple:
      return scheme.secondary;
    case ItemColour.brown:
      return const Color(0xFF6D4C41);
    case ItemColour.beige:
      return const Color(0xFFD7C4A3);
    case ItemColour.navy:
      return const Color(0xFF1A237E);
    case ItemColour.cream:
      return const Color(0xFFF3E6D0);
    case ItemColour.gold:
      return const Color(0xFFC9A227);
    case ItemColour.silver:
      return const Color(0xFFB0BEC5);
    case ItemColour.burgundy:
      return scheme.primary;
    case ItemColour.khaki:
      return const Color(0xFFC3B091);
    case ItemColour.teal:
      return const Color(0xFF00796B);
    case ItemColour.olive:
      return const Color(0xFF6B7B3A);
    case ItemColour.multicolour:
      return scheme.tertiary;
  }
}
