import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';

/// Activity heatmap card — last 91 days of focus data.
class HabitHeatmapCard extends ConsumerStatefulWidget {
  final String habitId;

  const HabitHeatmapCard({super.key, required this.habitId});

  @override
  ConsumerState<HabitHeatmapCard> createState() => _HabitHeatmapCardState();
}

class _HabitHeatmapCardState extends ConsumerState<HabitHeatmapCard> {
  Map<String, int>? _dailyMinutes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final data = await ref
          .read(firestoreServiceProvider)
          .getDailyMinutesForHabit(
            uid: uid,
            habitId: widget.habitId,
            lastNDays: 91,
          );

      if (mounted) {
        setState(() {
          _dailyMinutes = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.catDetailActivity,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        color: colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        context.l10n.catDetailActivityError,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(context.l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              )
            else
              StreakHeatmap(dailyMinutes: _dailyMinutes ?? {}),
          ],
        ),
      ),
    );
  }
}

/// Growth stage milestone indicator dot + label.
class StageMilestone extends StatelessWidget {
  final String name;
  final bool isReached;
  final Color color;

  const StageMilestone({
    super.key,
    required this.name,
    required this.isReached,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached
                ? color
                : colorScheme.outlineVariant.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.7
                        : 0.4,
                  ),
          ),
          child: isReached
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          style: textTheme.labelSmall?.copyWith(
            color: isReached ? color : colorScheme.onSurfaceVariant,
            fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
