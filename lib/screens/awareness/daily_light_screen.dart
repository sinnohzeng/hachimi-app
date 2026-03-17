import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/awareness_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/awareness/light_input_card.dart';
import 'package:hachimi_app/widgets/awareness/mood_selector.dart';
import 'package:hachimi_app/widgets/awareness/tag_selector.dart';
import 'package:uuid/uuid.dart';

/// 每日一光记录页 — 心情选择 + 文本输入 + 标签选择。
///
/// [quickMode] 为 true 时以紧凑模式渲染（通常在 BottomSheet 内），
/// 为 false 时显示完整表单页。
class DailyLightScreen extends ConsumerStatefulWidget {
  /// 快捷模式 — 仅心情 + 文本 + 内联保存。
  final bool quickMode;

  const DailyLightScreen({super.key, this.quickMode = false});

  @override
  ConsumerState<DailyLightScreen> createState() => _DailyLightScreenState();
}

class _DailyLightScreenState extends ConsumerState<DailyLightScreen> {
  int? _selectedMood;
  String _lightText = '';
  Set<String> _selectedTags = {};
  bool _isSaving = false;

  // ─── 保存 ───

  Future<void> _save() async {
    if (_selectedMood == null) {
      AppFeedback.error(context, context.l10n.awarenessMoodRequired);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) {
        if (mounted) {
          AppFeedback.error(context, context.l10n.awarenessSaveFailed);
        }
        return;
      }

      final now = DateTime.now();
      final date =
          '${now.year}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';

      final light = DailyLight(
        id: const Uuid().v4(),
        date: date,
        mood: Mood.fromValue(_selectedMood!),
        lightText: _lightText.trim().isEmpty ? null : _lightText.trim(),
        tags: _selectedTags.toList(),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(awarenessRepositoryProvider).saveDailyLight(uid, light);

      // 保存成功 — 分析失败不影响用户体验
      try {
        await ref
            .read(analyticsServiceProvider)
            .logFeatureUsed(feature: 'light_recorded');
      } on Exception catch (_) {
        // 分析上报失败属非关键错误
      }

      if (!widget.quickMode && mounted) {
        await _showCatBedtimeDialog();
      }

      if (mounted) {
        AppFeedback.success(context, context.l10n.awarenessLightSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[DailyLight] Save failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// 猫咪睡前动画对话框 — 3 秒自动关闭。返回 Future 以便调用方 await。
  Future<void> _showCatBedtimeDialog() {
    final response =
        AwarenessConstants.seedCatResponses[Mood.fromValue(_selectedMood!)] ??
        '';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 3), () {
          if (ctx.mounted) Navigator.of(ctx).pop();
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🐱', style: TextStyle(fontSize: 48)),
              const SizedBox(height: AppSpacing.md),
              Text(
                response,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── UI ───

  @override
  Widget build(BuildContext context) {
    if (widget.quickMode) return _buildQuickMode(context);
    return _buildFullMode(context);
  }

  /// 完整模式 — AppScaffold + 滚动表单 + FAB。
  Widget _buildFullMode(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.awarenessTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: Text(l10n.worrySave),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) => setState(() => _selectedMood = mood),
            ),
            const SizedBox(height: AppSpacing.lg),
            LightInputCard(
              initialText: _lightText.isEmpty ? null : _lightText,
              onTextChanged: (text) => _lightText = text,
            ),
            const SizedBox(height: AppSpacing.md),
            TagSelector(
              presetTags: AwarenessConstants.presetTags,
              selectedTags: _selectedTags,
              onTagsChanged: (tags) => setState(() => _selectedTags = tags),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  /// 快捷模式 — 紧凑心情 + 文本 + 内联保存按钮。
  Widget _buildQuickMode(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingBase,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoodSelector(
            selectedMood: _selectedMood,
            onMoodSelected: (mood) => setState(() => _selectedMood = mood),
            compact: true,
          ),
          const SizedBox(height: AppSpacing.md),
          LightInputCard(
            initialText: _lightText.isEmpty ? null : _lightText,
            onTextChanged: (text) => _lightText = text,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.worrySave),
            ),
          ),
        ],
      ),
    );
  }
}
