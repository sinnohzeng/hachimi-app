import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/widgets/cat_sprite.dart';

/// Focus complete celebration screen.
/// Shows XP earned, level-up animation, and session stats.
class FocusCompleteScreen extends ConsumerWidget {
  final String habitId;
  final int minutes;
  final XpResult xpResult;
  final LevelUpResult? levelUp;
  final bool isAbandoned;

  const FocusCompleteScreen({
    super.key,
    required this.habitId,
    required this.minutes,
    required this.xpResult,
    this.levelUp,
    this.isAbandoned = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    final didLevelUp = levelUp?.didLevelUp ?? false;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Status emoji
                Text(
                  isAbandoned ? '🤗' : (didLevelUp ? '🎉' : '✨'),
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  isAbandoned
                      ? "It's okay!"
                      : (didLevelUp
                          ? '${cat?.name ?? "Your cat"} evolved!'
                          : 'Great job!'),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  isAbandoned
                      ? "${cat?.name ?? 'Your cat'} says: \"We'll try again!\""
                      : 'You focused for $minutes minutes',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Cat display
                if (cat != null) ...[
                  CatSprite.fromCat(
                    breed: cat.breed,
                    stage: cat.computedStage,
                    mood: 'happy',
                    size: 120,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cat.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (didLevelUp)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Evolved to ${levelUp!.newStageName}!',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 32),

                // XP breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _XpRow(
                          label: 'Focus time',
                          value: '+${xpResult.baseXp} XP',
                          icon: Icons.timer_outlined,
                        ),
                        if (xpResult.streakBonus > 0) ...[
                          const Divider(height: 16),
                          _XpRow(
                            label: 'Streak bonus',
                            value: '+${xpResult.streakBonus} XP',
                            icon: Icons.local_fire_department,
                          ),
                        ],
                        if (xpResult.milestoneBonus > 0) ...[
                          const Divider(height: 16),
                          _XpRow(
                            label: 'Milestone bonus',
                            value: '+${xpResult.milestoneBonus} XP',
                            icon: Icons.emoji_events,
                          ),
                        ],
                        if (xpResult.fullHouseBonus > 0) ...[
                          const Divider(height: 16),
                          _XpRow(
                            label: 'Full house bonus',
                            value: '+${xpResult.fullHouseBonus} XP',
                            icon: Icons.home,
                          ),
                        ],
                        const Divider(height: 16),
                        _XpRow(
                          label: 'Total',
                          value: '+${xpResult.totalXp} XP',
                          icon: Icons.star,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Done button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      // Pop back to home
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Done',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _XpRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isBold;

  const _XpRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
