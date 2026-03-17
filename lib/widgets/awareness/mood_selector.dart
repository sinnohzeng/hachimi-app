import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/mood.dart';

/// MoodSelector — 水平排列的 5 级心情选择器。
///
/// [compact] 为 true 时使用 40x40 尺寸且不显示文字标签。
class MoodSelector extends StatelessWidget {
  /// 当前选中的心情等级（0-4），null 表示未选择。
  final int? selectedMood;

  /// 心情选中回调。
  final ValueChanged<int> onMoodSelected;

  /// 紧凑模式（隐藏标签，缩小尺寸）。
  final bool compact;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    this.compact = false,
  });

  /// 根据 Mood 枚举获取本地化标签。
  static String _moodLabel(Mood mood, S l10n) {
    return switch (mood) {
      Mood.veryHappy => l10n.moodVeryHappy,
      Mood.happy => l10n.moodHappy,
      Mood.calm => l10n.moodCalm,
      Mood.down => l10n.moodDown,
      Mood.veryDown => l10n.moodVeryDown,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Mood.values.map((m) => _buildMoodButton(context, m)).toList(),
    );
  }

  Widget _buildMoodButton(BuildContext context, Mood mood) {
    final isSelected = selectedMood == mood.value;
    final size = compact ? 40.0 : 56.0;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ringColor = mood.themeColor(colorScheme);

    return GestureDetector(
      onTap: () => onMoodSelected(mood.value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? ringColor.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHigh,
                border: isSelected
                    ? Border.all(color: ringColor, width: 2.5)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                mood.emoji,
                style: TextStyle(fontSize: compact ? 18 : 24),
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _moodLabel(mood, context.l10n),
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? ringColor : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
