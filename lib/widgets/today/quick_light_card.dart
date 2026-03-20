import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/awareness/mood_selector.dart';
import 'package:uuid/uuid.dart';

/// 今日一光快捷卡 — 未记录时显示内联输入，已记录时显示摘要。
class QuickLightCard extends ConsumerStatefulWidget {
  const QuickLightCard({super.key});

  @override
  ConsumerState<QuickLightCard> createState() => _QuickLightCardState();
}

class _QuickLightCardState extends ConsumerState<QuickLightCard> {
  Mood? _selectedMood;
  final _textController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedMood == null) return;
    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final now = DateTime.now();
      final light = DailyLight(
        id: const Uuid().v4(),
        date: AppDateUtils.formatDay(now),
        mood: _selectedMood!,
        lightText: _textController.text.trim().isEmpty
            ? null
            : _textController.text.trim(),
        tags: [],
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(awarenessRepositoryProvider).saveDailyLight(uid, light);

      if (mounted) {
        AppFeedback.success(context, context.l10n.quickLightSaveSuccess);
        _textController.clear();
        setState(() => _selectedMood = null);
      }
    } on Exception catch (e) {
      debugPrint('[QuickLight] Save failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.quickLightSaveError);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayLight = ref.watch(todayLightProvider);

    return todayLight.when(
      data: (light) =>
          light != null ? _buildSummary(context, light) : _buildInput(context),
      loading: () => const Card(
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) {
        debugPrint('[QuickLight] Load error: $e');
        return _buildInput(context);
      },
    );
  }

  /// 已记录 — 显示心情 emoji + 文本摘要，点击进入详情编辑。
  Widget _buildSummary(BuildContext context, DailyLight light) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: () => Navigator.of(context).pushNamed(
          AppRouter.dailyLight,
          arguments: <String, dynamic>{'quickMode': false},
        ),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Row(
            children: [
              Text(light.mood.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.quickLightTitle,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (light.lightText != null && light.lightText!.isNotEmpty)
                      Text(
                        light.lightText!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 未记录 — 内联心情选择 + 文本输入 + 记录按钮。
  Widget _buildInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quickLightTitle,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) => setState(() => _selectedMood = mood),
              compact: true,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: l10n.quickLightHint,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
                contentPadding: AppSpacing.paddingSm,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _selectedMood != null && !_isSaving ? _save : null,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.quickLightRecord),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
