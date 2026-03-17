import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_button.dart';
import 'package:hachimi_app/widgets/pixel_ui/retro_tiled_background.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// Step 2: 从 3 只猫中选择一只作为伙伴。
class AdoptionStep2CatPreview extends StatelessWidget {
  final String habitName;
  final List<Cat> previewCats;
  final int selectedCatIndex;
  final ValueChanged<int> onSelectCat;
  final ValueChanged<int> onRegenerateCat;
  final VoidCallback onRerollAll;

  const AdoptionStep2CatPreview({
    super.key,
    required this.habitName,
    required this.previewCats,
    required this.selectedCatIndex,
    required this.onSelectCat,
    required this.onRegenerateCat,
    required this.onRerollAll,
  });

  Cat? get _selectedCat =>
      previewCats.isEmpty ? null : previewCats[selectedCatIndex];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cat = _selectedCat;

    return RetroTiledBackground(
      pattern: PatternType.grid,
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: [
            _buildHeader(theme, context),
            const SizedBox(height: AppSpacing.lg),
            if (cat != null) _buildSelectedCatDetail(theme, context, cat),
            const SizedBox(height: AppSpacing.lg),
            _buildCatSelectionRow(theme, context),
            const SizedBox(height: AppSpacing.base),
            PixelButton(
              label: context.l10n.adoptionRerollAll,
              icon: Icons.refresh,
              onPressed: onRerollAll,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    final pixel = context.pixel;
    return Column(
      children: [
        Text(
          context.l10n.adoptionChooseKitten,
          style: pixel.pixelTitle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.adoptionCompanionFor(habitName),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectedCatDetail(
    ThemeData theme,
    BuildContext context,
    Cat cat,
  ) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final pixel = context.pixel;
    return Column(
      children: [
        TappableCatSprite(cat: cat, size: 120),
        const SizedBox(height: AppSpacing.md),
        Text(
          cat.name,
          style: pixel.pixelHeading.copyWith(fontWeight: FontWeight.bold),
        ),
        if (cat.personalityData != null) ...[
          const SizedBox(height: AppSpacing.xs),
          PixelBadge(
            text:
                '${cat.personalityData!.emoji} '
                '${context.l10n.personalityName(cat.personalityData!.id)}',
            animate: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.personalityFlavor(cat.personalityData!.id),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildCatSelectionRow(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index >= previewCats.length) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _buildCatCard(theme, context, index),
        );
      }),
    );
  }

  Widget _buildCatCard(ThemeData theme, BuildContext context, int index) {
    final colorScheme = theme.colorScheme;
    final isSelected = selectedCatIndex == index;
    final cat = previewCats[index];

    return Semantics(
      button: true,
      label: isSelected
          ? '${cat.name}, selected'
          : '${cat.name}, tap to select',
      child: GestureDetector(
        onTap: () => onSelectCat(index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildCatCardBody(theme, cat, isSelected),
            _buildRefreshButton(context, colorScheme, cat, index),
          ],
        ),
      ),
    );
  }

  Widget _buildCatCardBody(ThemeData theme, Cat cat, bool isSelected) {
    final colorScheme = theme.colorScheme;
    final pixel = theme.extension<PixelThemeExtension>()!;

    return AnimatedContainer(
      duration: AppMotion.durationShort4,
      width: 80,
      height: 96,
      padding: AppSpacing.paddingXs,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primaryContainer : pixel.retroSurface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? colorScheme.primary : pixel.pixelBorder,
          width: isSelected ? 3 : 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelCatSprite.fromCat(cat: cat, size: 56),
          const SizedBox(height: AppSpacing.xs),
          Text(
            cat.name,
            style: pixel.pixelLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(
      BuildContext context, ColorScheme colorScheme, Cat cat, int index) {
    return Positioned(
      top: -6,
      right: -6,
      child: Semantics(
        button: true,
        label: context.l10n.a11yRegenerateCat(cat.name),
        child: GestureDetector(
          onTap: () => onRegenerateCat(index),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Icon(
              Icons.refresh,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
