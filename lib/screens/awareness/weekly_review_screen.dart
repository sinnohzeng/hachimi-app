import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/awareness_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/awareness/happy_moment_card.dart';
import 'package:hachimi_app/widgets/awareness/worry_item_card.dart';
import 'package:uuid/uuid.dart';

/// 周回顾页 — 三个幸福时刻 + 感恩 + 学习 + 烦恼更新。
class WeeklyReviewScreen extends ConsumerStatefulWidget {
  const WeeklyReviewScreen({super.key});

  @override
  ConsumerState<WeeklyReviewScreen> createState() => _WeeklyReviewScreenState();
}

class _WeeklyReviewScreenState extends ConsumerState<WeeklyReviewScreen> {
  // 三个幸福时刻
  String _moment1 = '';
  Set<String> _moment1Tags = {};
  String _moment2 = '';
  Set<String> _moment2Tags = {};
  String _moment3 = '';
  Set<String> _moment3Tags = {};

  // 感恩 + 学习
  final _gratitudeController = TextEditingController();
  final _learningController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _gratitudeController.dispose();
    _learningController.dispose();
    super.dispose();
  }

  // ─── 周 ID 计算 ───

  String _currentWeekId() {
    final now = DateTime.now();
    final thursday = now.add(Duration(days: DateTime.thursday - now.weekday));
    final isoYear = thursday.year;
    final jan4 = DateTime(isoYear, 1, 4);
    final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));
    final weekNumber = (thursday.difference(week1Monday).inDays ~/ 7) + 1;
    return '$isoYear-W${weekNumber.toString().padLeft(2, '0')}';
  }

  String _weekStartDate() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return _formatDate(monday);
  }

  String _weekEndDate() {
    final now = DateTime.now();
    final sunday = now.add(Duration(days: 7 - now.weekday));
    return _formatDate(sunday);
  }

  String _formatDate(DateTime d) {
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // ─── 保存 ───

  Future<void> _save() async {
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
      final weekId = _currentWeekId();

      final review = WeeklyReview(
        id: const Uuid().v4(),
        weekId: weekId,
        weekStartDate: _weekStartDate(),
        weekEndDate: _weekEndDate(),
        happyMoment1: _moment1.isEmpty ? null : _moment1,
        happyMoment1Tags: _moment1Tags.toList(),
        happyMoment2: _moment2.isEmpty ? null : _moment2,
        happyMoment2Tags: _moment2Tags.toList(),
        happyMoment3: _moment3.isEmpty ? null : _moment3,
        happyMoment3Tags: _moment3Tags.toList(),
        gratitude: _gratitudeController.text.trim().isEmpty
            ? null
            : _gratitudeController.text.trim(),
        learning: _learningController.text.trim().isEmpty
            ? null
            : _learningController.text.trim(),
        catWeeklySummary: _generateCatSummary(),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(awarenessRepositoryProvider).saveWeeklyReview(uid, review);

      // 保存成功 — 分析失败不影响用户体验
      if (review.isComplete) {
        try {
          await ref
              .read(analyticsServiceProvider)
              .logFeatureUsed(feature: 'weekly_review_completed');
        } on Exception catch (_) {
          // 分析上报失败属非关键错误
        }
      }

      if (mounted) {
        AppFeedback.success(context, context.l10n.weeklyReviewSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[WeeklyReview] Save failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// 简单种子文案 — Track 4 会替换为 AI 生成。
  String _generateCatSummary() {
    const responses = AwarenessConstants.seedCatResponses;
    // 取中间档位（平静）的默认回复
    return responses[Mood.calm] ?? '';
  }

  // ─── UI ───

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.weeklyReviewTitle)),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 三个幸福时刻
            HappyMomentCard(
              momentNumber: 1,
              text: _moment1.isEmpty ? null : _moment1,
              tags: _moment1Tags,
              onTextChanged: (t) => _moment1 = t,
              onTagsChanged: (tags) => setState(() => _moment1Tags = tags),
            ),
            const SizedBox(height: AppSpacing.md),
            HappyMomentCard(
              momentNumber: 2,
              text: _moment2.isEmpty ? null : _moment2,
              tags: _moment2Tags,
              onTextChanged: (t) => _moment2 = t,
              onTagsChanged: (tags) => setState(() => _moment2Tags = tags),
            ),
            const SizedBox(height: AppSpacing.md),
            HappyMomentCard(
              momentNumber: 3,
              text: _moment3.isEmpty ? null : _moment3,
              tags: _moment3Tags,
              onTextChanged: (t) => _moment3 = t,
              onTagsChanged: (tags) => setState(() => _moment3Tags = tags),
            ),
            const Divider(height: AppSpacing.xl),
            // 感恩
            Text(
              l10n.weeklyReviewGratitude,
              style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _gratitudeController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.weeklyReviewGratitudeHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // 学习
            Text(
              l10n.weeklyReviewLearning,
              style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _learningController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.weeklyReviewLearningHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const Divider(height: AppSpacing.xl),
            // 烦恼更新
            _buildWorriesSection(textTheme, colorScheme),
            const SizedBox(height: AppSpacing.lg),
            // 保存
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.weeklyReviewSave),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildWorriesSection(TextTheme textTheme, ColorScheme colorScheme) {
    final worriesAsync = ref.watch(activeWorriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.worryProcessorTitle,
          style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        worriesAsync.when(
          data: (worries) {
            if (worries.isEmpty) {
              return Text(
                context.l10n.awarenessEmptyWorriesTitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: worries
                  .map(
                    (w) => Padding(
                      padding: AppSpacing.paddingVXs,
                      child: WorryItemCard(
                        worry: w,
                        onStatusChanged: (status) =>
                            _resolveWorry(w.id, status),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.awarenessSaveFailed,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _resolveWorry(String worryId, WorryStatus status) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    try {
      await ref.read(worryRepositoryProvider).resolve(uid, worryId, status);
    } on Exception catch (e) {
      debugPrint('[WeeklyReview] Resolve worry failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    }
  }
}
