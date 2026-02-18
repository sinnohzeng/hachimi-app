import 'package:flutter/material.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';

/// Displays a cat candidate during the adoption draft.
/// Shows breed name, personality badge, flavor text, and a color-coded preview.
class CatPreviewCard extends StatelessWidget {
  final Cat cat;
  final bool isSelected;
  final VoidCallback onTap;

  const CatPreviewCard({
    super.key,
    required this.cat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final breed = breedMap[cat.breed];
    final personality = personalityMap[cat.personality];
    final breedColor = breed?.colors.base ?? colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2.5)
              : Border.all(color: colorScheme.outlineVariant, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cat avatar circle with breed color
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: breedColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: breedColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '🐱',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Breed name
            Text(
              breed?.name ?? cat.breed,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _rarityColor(cat.rarity).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cat.rarity.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: _rarityColor(cat.rarity),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Personality badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  personality?.emoji ?? '🐱',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    personality?.name ?? cat.personality,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Flavor text
            Text(
              personality?.flavorText ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'rare':
        return const Color(0xFFE040FB);
      case 'uncommon':
        return const Color(0xFF448AFF);
      default:
        return const Color(0xFF66BB6A);
    }
  }
}
