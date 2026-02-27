import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// Step 3: 为猫取名。
class AdoptionStep3NameCat extends StatelessWidget {
  final Cat? selectedCat;
  final TextEditingController catNameController;
  final bool isUnlimitedMode;
  final String habitName;
  final int? targetHours;

  const AdoptionStep3NameCat({
    super.key,
    required this.selectedCat,
    required this.catNameController,
    required this.isUnlimitedMode,
    required this.habitName,
    required this.targetHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cat = selectedCat;

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          if (cat != null) _buildCatPreview(theme, context, cat),
          const SizedBox(height: AppSpacing.xl),
          _buildNameInput(theme, context),
          const SizedBox(height: AppSpacing.base),
          _buildGrowthHint(theme, context),
        ],
      ),
    );
  }

  Widget _buildCatPreview(ThemeData theme, BuildContext context, Cat cat) {
    final personality = cat.personalityData;

    return Column(
      children: [
        TappableCatSprite(cat: cat, size: 120),
        const SizedBox(height: AppSpacing.md),
        if (personality != null)
          Text(
            '${personality.emoji} '
            '${context.l10n.personalityName(personality.id)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildNameInput(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.adoptionNameYourCat2,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        TextFormField(
          controller: catNameController,
          maxLength: Cat.maxNameLength,
          decoration: InputDecoration(
            labelText: context.l10n.adoptionCatName,
            hintText: context.l10n.adoptionCatHint,
            prefixIcon: const Icon(Icons.pets),
            suffixIcon: IconButton(
              icon: const Icon(Icons.casino),
              tooltip: context.l10n.adoptionRandomTooltip,
              onPressed: () {
                const names = randomCatNames;
                catNameController.text = (names.toList()..shuffle()).first;
              },
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildGrowthHint(ThemeData theme, BuildContext context) {
    return Text(
      isUnlimitedMode
          ? context.l10n.adoptionGrowthHint
          : context.l10n.adoptionGrowthTarget(habitName, targetHours ?? 100),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}
