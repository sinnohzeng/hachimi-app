import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// HabitCard — displays a single habit with progress, streak, and today's time.
///
/// Provides a subtle scale-down feedback on long press for tactile response.
class HabitCard extends StatefulWidget {
  final Habit habit;
  final int todayMinutes;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.todayMinutes,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.98);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  void _onLongPress() {
    HapticFeedback.selectionClick();
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final habit = widget.habit;

    return AnimatedScale(
      scale: _scale,
      duration: AppMotion.durationShort3,
      curve: AppMotion.standard,
      child: Semantics(
        label: '${habit.name}, ${habit.progressText}',
        button: true,
        child: Card(
          margin: AppSpacing.paddingCard,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onLongPress: _onLongPress,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: AppShape.borderMedium,
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Row(
                  children: [
                    // Icon + Progress ring
                    ProgressRing(
                      progress: habit.progressPercent,
                      size: 56,
                      child: Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),

                    // Name + progress text + today
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(habit.name, style: textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            habit.progressText,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (widget.todayMinutes > 0) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              context.l10n.habitTodayMinutes(
                                widget.todayMinutes,
                              ),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 累计天数
                    if (habit.totalCheckInDays > 0)
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 14),
                        label: Text(
                          context.l10n.habitDetailDaysUnit(
                            habit.totalCheckInDays,
                          ),
                        ),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide.none,
                      ),

                    // Delete button
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: widget.onDelete,
                      tooltip: context.l10n.habitDeleteTooltip,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
