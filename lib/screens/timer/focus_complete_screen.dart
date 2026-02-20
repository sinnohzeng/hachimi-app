// ---
// 📘 文件说明：
// 专注完成庆祝页面 — 展示本次专注的时长、XP 奖励明细、猫猫阶段跃迁提示。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 habitId、分钟数、XpResult、StageUpResult 参数；
// 2. 从 Provider 加载关联的 habit 和 cat 数据；
// 3. 显示像素猫 sprite + 阶段跃迁标签（若有）；
// 4. XP 明细卡片；
// 5. Done 按钮返回首页；
//
// 🧩 文件结构：
// - FocusCompleteScreen：主页面 ConsumerWidget；
// - _XpRow：XP 明细行组件；
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// Focus complete celebration screen.
/// Shows minutes earned, XP breakdown, stage-up animation, and session stats.
class FocusCompleteScreen extends ConsumerWidget {
  final String habitId;
  final int minutes;
  final XpResult xpResult;
  final StageUpResult? stageUp;
  final bool isAbandoned;
  final int coinsEarned;

  const FocusCompleteScreen({
    super.key,
    required this.habitId,
    required this.minutes,
    required this.xpResult,
    this.stageUp,
    this.isAbandoned = false,
    this.coinsEarned = 0,
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

    final didStageUp = stageUp?.didStageUp ?? false;

    // Trigger haptic feedback on screen build (celebration moment)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.heavyImpact();
    });

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
                  isAbandoned ? '🤗' : (didStageUp ? '🎉' : '✨'),
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  isAbandoned
                      ? "It's okay!"
                      : (didStageUp
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
                  TappableCatSprite(cat: cat, size: 120),
                  const SizedBox(height: 12),
                  Text(
                    cat.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (didStageUp)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: stageColor(stageUp!.newStage)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Evolved to ${stageUp!.newStage[0].toUpperCase()}${stageUp!.newStage.substring(1)}!',
                          style: textTheme.labelLarge?.copyWith(
                            color: stageColor(stageUp!.newStage),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 32),

                // Session stats breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _StatRow(
                          label: 'Focus time',
                          value: '+$minutes min',
                          icon: Icons.timer_outlined,
                        ),
                        if (coinsEarned > 0) ...[
                          const Divider(height: 16),
                          _StatRow(
                            label: 'Coins earned',
                            value: '+$coinsEarned',
                            icon: Icons.monetization_on,
                          ),
                        ],
                        const Divider(height: 16),
                        _StatRow(
                          label: 'Base XP',
                          value: '+${xpResult.baseXp} XP',
                          icon: Icons.star_outline,
                        ),
                        if (xpResult.streakBonus > 0) ...[
                          const Divider(height: 16),
                          _StatRow(
                            label: 'Streak bonus',
                            value: '+${xpResult.streakBonus} XP',
                            icon: Icons.local_fire_department,
                          ),
                        ],
                        if (xpResult.milestoneBonus > 0) ...[
                          const Divider(height: 16),
                          _StatRow(
                            label: 'Milestone bonus',
                            value: '+${xpResult.milestoneBonus} XP',
                            icon: Icons.emoji_events,
                          ),
                        ],
                        if (xpResult.fullHouseBonus > 0) ...[
                          const Divider(height: 16),
                          _StatRow(
                            label: 'Full house bonus',
                            value: '+${xpResult.fullHouseBonus} XP',
                            icon: Icons.home,
                          ),
                        ],
                        const Divider(height: 16),
                        _StatRow(
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isBold;

  const _StatRow({
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
