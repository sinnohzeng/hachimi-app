import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_card.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// 可折叠相册 section — 展示已归档的猫猫。
/// 由 SliverToBoxAdapter（标题）+ SliverPadding（Grid）组成。
class ArchivedCatsSection extends StatelessWidget {
  final List<Cat> cats;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<Cat> onTap;
  final ValueChanged<Cat> onLongPress;

  const ArchivedCatsSection({
    super.key,
    required this.cats,
    required this.expanded,
    required this.onToggle,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // 标题栏 — 点击折叠/展开
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: context.l10n.catRoomAlbumSection(cats.length),
            expanded: expanded,
            onToggle: onToggle,
          ),
        ),
        // 归档猫 Grid
        if (expanded)
          SliverPadding(
            padding: AppSpacing.paddingMd,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ArchivedCatCard(
                  cat: cats[index],
                  onTap: () => onTap(cats[index]),
                  onLongPress: () => onLongPress(cats[index]),
                ),
                childCount: cats.length,
              ),
            ),
          ),
      ],
    );
  }
}

/// 可折叠 section 标题。
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionHeader({
    required this.title,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label:
          '$title, ${expanded ? MaterialLocalizations.of(context).expandedIconTapHint : MaterialLocalizations.of(context).collapsedIconTapHint}',
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.photo_album_outlined,
                size: 20,
                color: pixel.pixelAccentWarm,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: pixel.pixelHeading)),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: AppMotion.durationShort4,
                child: Icon(
                  Icons.expand_more,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 归档猫卡片 — 半透明像素风 + "已归档" 像素徽章。
class _ArchivedCatCard extends StatelessWidget {
  final Cat cat;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ArchivedCatCard({
    required this.cat,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;

    return Opacity(
      opacity: 0.5,
      child: PixelCard(
        onTap: onTap,
        onLongPress: onLongPress,
        padding: AppSpacing.paddingSm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TappableCatSprite(cat: cat, size: 64, enableTap: false),
            const SizedBox(height: AppSpacing.xs),
            Text(
              cat.name,
              style: pixel.pixelHeading.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            PixelBadge(text: context.l10n.catRoomArchivedLabel),
          ],
        ),
      ),
    );
  }
}
