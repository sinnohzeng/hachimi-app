import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
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

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          _buildHeader(theme, context),
          const SizedBox(height: AppSpacing.lg),
          if (cat != null) _buildSelectedCatDetail(theme, context, cat),
          const SizedBox(height: AppSpacing.lg),
          _buildCatSelectionRow(theme, context),
          const SizedBox(height: AppSpacing.base),
          TextButton.icon(
            onPressed: onRerollAll,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.adoptionRerollAll),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.adoptionChooseKitten,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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

    return Column(
      children: [
        TappableCatSprite(cat: cat, size: 120),
        const SizedBox(height: AppSpacing.md),
        Text(
          cat.name,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (cat.personalityData != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildPersonalityBadge(theme, context, cat),
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

  Widget _buildPersonalityBadge(
    ThemeData theme,
    BuildContext context,
    Cat cat,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: AppShape.borderLarge,
      ),
      child: Text(
        '${cat.personalityData!.emoji} '
        '${context.l10n.personalityName(cat.personalityData!.id)}',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
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
            _buildRefreshButton(colorScheme, cat, index),
          ],
        ),
      ),
    );
  }

  Widget _buildCatCardBody(ThemeData theme, Cat cat, bool isSelected) {
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: AppMotion.durationShort4,
      width: 80,
      height: 96,
      padding: AppSpacing.paddingXs,
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: AppShape.borderMedium,
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelCatSprite.fromCat(cat: cat, size: 56),
          const SizedBox(height: AppSpacing.xs),
          Text(
            cat.name,
            style: theme.textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(ColorScheme colorScheme, Cat cat, int index) {
    return Positioned(
      top: -6,
      right: -6,
      child: Semantics(
        button: true,
        label: 'Regenerate ${cat.name}',
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
