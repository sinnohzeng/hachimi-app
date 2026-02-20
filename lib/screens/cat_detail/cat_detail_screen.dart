// ---
// 📘 文件说明：
// Cat Detail 页面 — 猫猫和关联任务的核心信息中枢。
// 展示猫猫形象、成长进度、专注统计、每日提醒、活动热力图、饰品和详细外观信息。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 Provider 加载猫猫和关联 Habit 数据；
// 2. SliverAppBar：TappableCatSprite + 猫名 + 性格标签；
// 3. 心情标签；
// 4. 成长进度卡片（时间制进度条 + 阶段里程碑）；
// 5. 专注统计卡片（替代旧 "Bound Habit" 卡片）；
// 6. 每日提醒卡片（设置/修改/移除提醒）；
// 7. 活动热力图卡片；
// 8. 饰品装备卡片；
// 9. 增强版猫猫信息卡片（性格 + 外观详情 + 状态）；
//
// 🧩 文件结构：
// - CatDetailScreen：主页面 ConsumerStatefulWidget；
// - _FocusStatsCard：专注统计卡片；
// - _ReminderCard：每日提醒卡片；
// - _EditQuestSheet：编辑任务 BottomSheet；
// - _EnhancedCatInfoCard：增强版猫猫信息卡片；
// - _StageMilestone / _HabitHeatmapCard / _AccessoriesCard / _InfoRow / _StatCell：辅助组件；
//
// 🕒 创建时间：2026-02-18
// 🕒 重构时间：2026-02-19
// ---

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/utils/appearance_descriptions.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/inventory_provider.dart';
import 'package:hachimi_app/widgets/streak_heatmap.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show accessoryDisplayName, peltColorToMaterial;

/// Cat detail page — the central hub for a cat and its bound quest.
class CatDetailScreen extends ConsumerStatefulWidget {
  final String catId;

  const CatDetailScreen({super.key, required this.catId});

  @override
  ConsumerState<CatDetailScreen> createState() => _CatDetailScreenState();
}

class _CatDetailScreenState extends ConsumerState<CatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final cat = ref.watch(catByIdProvider(widget.catId));
    if (cat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Cat not found')),
      );
    }

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit =
        habits.where((h) => h.id == cat.boundHabitId).firstOrNull;
    final personality = personalityMap[cat.personality];
    final moodData = moodById(cat.computedMood);
    final stageClr = stageColor(cat.computedStage);

    // Pelt color themed gradient: 70% pelt + 30% stage
    final peltClr = peltColorToMaterial(cat.appearance.peltColor);
    final headerColor = Color.lerp(peltClr, stageClr, 0.3)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient app bar with pixel cat
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      headerColor.withValues(alpha: 0.25),
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      // Tappable cat sprite with bounce animation
                      TappableCatSprite(cat: cat, size: 120),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat.name,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showRenameDialog(context, cat),
                            tooltip: 'Rename',
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (personality != null)
                        Text(
                          '${personality.emoji} ${personality.name}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Mood badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${moodData.emoji} ${moodData.name}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Growth progress (time-based)
                _buildGrowthCard(context, cat, stageClr),
                const SizedBox(height: 16),

                // Focus statistics card (replaces old "Bound Habit" card)
                if (habit != null) ...[
                  _FocusStatsCard(habit: habit, cat: cat),
                  const SizedBox(height: 16),
                ],

                // Reminder card
                if (habit != null) ...[
                  _ReminderCard(habit: habit, cat: cat),
                  const SizedBox(height: 16),
                ],

                // Streak heatmap
                if (habit != null) _HabitHeatmapCard(habitId: habit.id),
                const SizedBox(height: 16),

                // Accessories card
                _AccessoriesCard(cat: cat),
                const SizedBox(height: 16),

                // Enhanced cat info card
                _EnhancedCatInfoCard(cat: cat),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, Cat cat, Color stageClr) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Growth Progress',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  cat.stageName,
                  style: textTheme.labelLarge?.copyWith(
                    color: stageClr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: cat.growthProgress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(stageClr),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cat.totalMinutes ~/ 60}h ${cat.totalMinutes % 60}m',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Target: ${cat.targetMinutes ~/ 60}h',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            // Stage milestones
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StageMilestone(
                  name: 'Kitten',
                  isReached: true,
                  color: stageColor('kitten'),
                ),
                _StageMilestone(
                  name: 'Adolescent',
                  isReached: cat.growthProgress >= 0.20,
                  color: stageColor('adolescent'),
                ),
                _StageMilestone(
                  name: 'Adult',
                  isReached: cat.growthProgress >= 0.45,
                  color: stageColor('adult'),
                ),
                _StageMilestone(
                  name: 'Senior',
                  isReached: cat.growthProgress >= 0.75,
                  color: stageColor('senior'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, Cat cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Cat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New name',
            prefixIcon: Icon(Icons.pets),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              final uid = ref.read(currentUidProvider);
              if (uid == null) return;
              HapticFeedback.mediumImpact();
              await ref.read(catFirestoreServiceProvider).renameCat(
                    uid: uid,
                    catId: cat.id,
                    newName: newName,
                  );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Cat renamed!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}

// ─── Focus Statistics Card ───

/// Shows quest info, 2-column stats grid, and Start Focus button.
class _FocusStatsCard extends ConsumerWidget {
  final Habit habit;
  final Cat cat;

  const _FocusStatsCard({required this.habit, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final todayMap = ref.watch(todayMinutesPerHabitProvider);
    final todayMinutes = todayMap[habit.id] ?? 0;
    final daysActive =
        max(1, DateTime.now().difference(habit.createdAt).inDays);
    final avgDaily = habit.totalMinutes ~/ daysActive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: icon + name + Quest badge + edit button
            Row(
              children: [
                Text(habit.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habit.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Quest',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _showEditQuestSheet(context),
                  tooltip: 'Edit quest',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2-column stats grid
            Table(
              children: [
                _statRow(
                  context,
                  Icons.flag_outlined,
                  'Daily goal',
                  '${habit.goalMinutes} min',
                  Icons.today,
                  "Today's focus",
                  '$todayMinutes min',
                ),
                _statRow(
                  context,
                  Icons.timer_outlined,
                  'Total focus',
                  '${habit.totalMinutes ~/ 60}h ${habit.totalMinutes % 60}m',
                  Icons.emoji_events_outlined,
                  'Target',
                  '${habit.targetHours}h',
                ),
                _statRow(
                  context,
                  Icons.pie_chart_outline,
                  'Completion',
                  '${(habit.progressPercent * 100).toStringAsFixed(0)}%',
                  Icons.local_fire_department,
                  'Current streak',
                  '${habit.currentStreak}d',
                ),
                _statRow(
                  context,
                  Icons.star_outline,
                  'Best streak',
                  '${habit.bestStreak}d',
                  Icons.trending_up,
                  'Avg daily',
                  '${avgDaily}m',
                ),
                _statRow(
                  context,
                  Icons.calendar_today_outlined,
                  'Days active',
                  '$daysActive',
                  null,
                  null,
                  null,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Start Focus button
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.focusSetup,
                    arguments: habit.id,
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Focus'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _statRow(
    BuildContext context,
    IconData icon1,
    String label1,
    String value1,
    IconData? icon2,
    String? label2,
    String? value2,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _StatCell(icon: icon1, label: label1, value: value1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: icon2 != null
              ? _StatCell(icon: icon2, label: label2!, value: value2!)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showEditQuestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _EditQuestSheet(habit: habit),
      ),
    );
  }
}

// ─── Reminder Card ───

/// Shows/sets/removes a daily reminder for this quest.
class _ReminderCard extends ConsumerWidget {
  final Habit habit;
  final Cat cat;

  const _ReminderCard({required this.habit, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final hasReminder =
        habit.reminderTime != null && habit.reminderTime!.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              hasReminder
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              color: hasReminder
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Reminder',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    hasReminder
                        ? '${habit.reminderTime} every day'
                        : 'No reminder set',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (hasReminder) ...[
              TextButton(
                onPressed: () => _setReminder(context, ref),
                child: const Text('Change'),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: colorScheme.error),
                onPressed: () => _removeReminder(context, ref),
                tooltip: 'Remove reminder',
                visualDensity: VisualDensity.compact,
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => _setReminder(context, ref),
                icon: const Icon(Icons.add_alarm, size: 18),
                label: const Text('Set'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _setReminder(BuildContext context, WidgetRef ref) async {
    final initial = habit.reminderTime != null
        ? _parseTime(habit.reminderTime!)
        : const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !context.mounted) return;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final timeStr = _formatTimeOfDay(picked);

    await ref.read(firestoreServiceProvider).updateHabit(
          uid: uid,
          habitId: habit.id,
          reminderTime: timeStr,
        );
    await ref.read(notificationServiceProvider).scheduleDailyReminder(
          habitId: habit.id,
          habitName: habit.name,
          catName: cat.name,
          hour: picked.hour,
          minute: picked.minute,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for $timeStr'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _removeReminder(BuildContext context, WidgetRef ref) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    await ref.read(firestoreServiceProvider).updateHabit(
          uid: uid,
          habitId: habit.id,
          clearReminder: true,
        );
    await ref.read(notificationServiceProvider).cancelDailyReminder(habit.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder removed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _formatTimeOfDay(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Edit Quest Sheet ───

/// Modal bottom sheet for editing quest: emoji, name, goal, target.
class _EditQuestSheet extends ConsumerStatefulWidget {
  final Habit habit;

  const _EditQuestSheet({required this.habit});

  @override
  ConsumerState<_EditQuestSheet> createState() => _EditQuestSheetState();
}

class _EditQuestSheetState extends ConsumerState<_EditQuestSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _iconController;
  late int _selectedGoal;
  late int _selectedTarget;
  bool _isSaving = false;

  static const _defaultGoalOptions = [15, 25, 40, 60];
  static const _defaultTargetOptions = [50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _iconController = TextEditingController(text: widget.habit.icon);
    _selectedGoal = widget.habit.goalMinutes;
    _selectedTarget = widget.habit.targetHours;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Include current value in chips if non-standard
    final goalChips = _buildChipValues(_defaultGoalOptions, _selectedGoal);
    final targetChips = _buildChipValues(_defaultTargetOptions, _selectedTarget);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Edit Quest',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Emoji field
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(
                labelText: 'Icon (emoji)',
                prefixIcon: Icon(Icons.emoji_emotions_outlined),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Quest name',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 24),

            // Daily goal chips
            Text('Daily goal (minutes)', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: goalChips.map((mins) {
                return ChoiceChip(
                  label: Text('$mins'),
                  selected: _selectedGoal == mins,
                  onSelected: (_) => setState(() => _selectedGoal = mins),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Target hours chips
            Text('Target total (hours)', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: targetChips.map((hrs) {
                return ChoiceChip(
                  label: Text('$hrs'),
                  selected: _selectedTarget == hrs,
                  onSelected: (_) => setState(() => _selectedTarget = hrs),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _buildChipValues(List<int> defaults, int current) {
    final chips = [...defaults];
    if (!chips.contains(current)) {
      chips.add(current);
      chips.sort();
    }
    return chips;
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final icon = _iconController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    HapticFeedback.mediumImpact();
    await ref.read(firestoreServiceProvider).updateHabit(
          uid: uid,
          habitId: widget.habit.id,
          name: name != widget.habit.name ? name : null,
          icon: icon.isNotEmpty && icon != widget.habit.icon ? icon : null,
          goalMinutes: _selectedGoal != widget.habit.goalMinutes
              ? _selectedGoal
              : null,
          targetHours: _selectedTarget != widget.habit.targetHours
              ? _selectedTarget
              : null,
        );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quest updated!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ─── Enhanced Cat Info Card ───

/// About card — personality, appearance summary, expandable details, status.
class _EnhancedCatInfoCard extends StatelessWidget {
  final Cat cat;

  const _EnhancedCatInfoCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final personality = personalityMap[cat.personality];
    final a = cat.appearance;
    final summary = fullSummary(a);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About ${cat.name}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Personality
            if (personality != null) ...[
              Row(
                children: [
                  Text(
                    '${personality.emoji} ',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    personality.name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                personality.flavorText,
                style: textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Summary line
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(summary, style: textTheme.bodyMedium),
            ),
            const SizedBox(height: 8),

            // Expandable appearance details
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text('Appearance details', style: textTheme.labelLarge),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                children: _buildAppearanceDetails(a),
              ),
            ),

            const Divider(height: 24),
            _InfoRow(
              label: 'Status',
              value:
                  cat.state[0].toUpperCase() + cat.state.substring(1),
            ),
            _InfoRow(label: 'Adopted', value: _formatDate(cat.createdAt)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppearanceDetails(CatAppearance a) {
    final details = <Widget>[
      _InfoRow(label: 'Fur pattern', value: peltTypeDescription(a.peltType)),
      _InfoRow(label: 'Fur color', value: peltColorDescription(a.peltColor)),
      _InfoRow(
          label: 'Fur length', value: furLengthDescription(a.isLonghair)),
      _InfoRow(
          label: 'Eyes', value: eyeDescription(a.eyeColor, a.eyeColor2)),
    ];

    if (a.whitePatches != null) {
      details.add(_InfoRow(label: 'White patches', value: a.whitePatches!));
    }
    final patchesTint = whitePatchesTintDescription(a.whitePatchesTint);
    if (patchesTint != null) {
      details.add(_InfoRow(label: 'Patches tint', value: patchesTint));
    }
    if (a.tint != 'none') {
      details.add(_InfoRow(
        label: 'Tint',
        value: a.tint[0].toUpperCase() + a.tint.substring(1),
      ));
    }
    if (a.points != null) {
      details.add(_InfoRow(label: 'Points', value: a.points!));
    }
    if (a.vitiligo != null) {
      details.add(_InfoRow(label: 'Vitiligo', value: a.vitiligo!));
    }
    if (a.isTortie) {
      details.add(const _InfoRow(label: 'Tortoiseshell', value: 'Yes'));
      if (a.tortiePattern != null) {
        details
            .add(_InfoRow(label: 'Tortie pattern', value: a.tortiePattern!));
      }
      if (a.tortieColor != null) {
        details.add(_InfoRow(
          label: 'Tortie color',
          value: peltColorDescription(a.tortieColor!),
        ));
      }
    }
    details
        .add(_InfoRow(label: 'Skin', value: skinColorDescription(a.skinColor)));

    return details;
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

// ─── Helper Widgets ───

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StageMilestone extends StatelessWidget {
  final String name;
  final bool isReached;
  final Color color;

  const _StageMilestone({
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
            color: isReached ? color : colorScheme.surfaceContainerHighest,
          ),
          child: isReached
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
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

class _HabitHeatmapCard extends ConsumerStatefulWidget {
  final String habitId;

  const _HabitHeatmapCard({required this.habitId});

  @override
  ConsumerState<_HabitHeatmapCard> createState() => _HabitHeatmapCardState();
}

class _HabitHeatmapCardState extends ConsumerState<_HabitHeatmapCard> {
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

      final data =
          await ref.read(firestoreServiceProvider).getDailyMinutesForHabit(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_off,
                          color: colorScheme.onSurfaceVariant, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load activity data',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Retry'),
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

/// 饰品装备/卸下卡片 — 数据来源为 inventoryProvider。
class _AccessoriesCard extends ConsumerWidget {
  final Cat cat;
  const _AccessoriesCard({required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasEquipped = cat.equippedAccessory != null &&
        cat.equippedAccessory!.isNotEmpty;
    final inventory = ref.watch(inventoryProvider).value ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessories',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 当前装备
            Row(
              children: [
                Text(
                  'Equipped: ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (hasEquipped)
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          accessoryDisplayName(cat.equippedAccessory!),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _unequip(context, ref),
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 16),
                          label: const Text('Unequip'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'None',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),

            // 道具箱中可装备的饰品
            if (inventory.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'From Inventory (${inventory.length})',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: inventory.map((id) {
                  return ActionChip(
                    label: Text(
                      accessoryDisplayName(id),
                      style: textTheme.labelSmall,
                    ),
                    onPressed: () => _equip(context, ref, id),
                  );
                }).toList(),
              ),
            ] else if (!hasEquipped)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'No accessories yet. Visit the shop!',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _equip(BuildContext context, WidgetRef ref, String accessoryId) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref.read(inventoryServiceProvider).equipAccessory(
          uid: uid,
          catId: cat.id,
          accessoryId: accessoryId,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Equipped ${accessoryDisplayName(accessoryId)}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _unequip(BuildContext context, WidgetRef ref) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    HapticFeedback.selectionClick();
    ref.read(inventoryServiceProvider).unequipAccessory(
          uid: uid,
          catId: cat.id,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unequipped'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
