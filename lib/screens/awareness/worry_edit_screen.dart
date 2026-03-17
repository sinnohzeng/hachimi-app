import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

/// 烦恼编辑页 — 新建或编辑烦恼。
///
/// [worryId] 为 null 时新建，否则加载已有烦恼并编辑。
class WorryEditScreen extends ConsumerStatefulWidget {
  /// 待编辑的烦恼 ID — null 表示新建。
  final String? worryId;

  const WorryEditScreen({super.key, this.worryId});

  @override
  ConsumerState<WorryEditScreen> createState() => _WorryEditScreenState();
}

class _WorryEditScreenState extends ConsumerState<WorryEditScreen> {
  final _descriptionController = TextEditingController();
  final _solutionController = TextEditingController();
  bool _isSaving = false;
  bool _isLoading = false;
  Worry? _existingWorry;

  bool get _isEditMode => widget.worryId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) _loadExistingWorry();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingWorry() async {
    setState(() => _isLoading = true);
    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final worry = await ref
          .read(worryRepositoryProvider)
          .getWorry(uid, widget.worryId!);

      if (worry != null && mounted) {
        setState(() {
          _existingWorry = worry;
          _descriptionController.text = worry.description;
          _solutionController.text = worry.solution ?? '';
        });
      }
    } on Exception catch (e) {
      debugPrint('[WorryEdit] Load failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── 保存 ───

  Future<void> _save() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      AppFeedback.error(context, context.l10n.worryDescriptionRequired);
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
      final solution = _solutionController.text.trim();

      if (_isEditMode && _existingWorry != null) {
        final updated = _existingWorry!.copyWith(
          description: description,
          solution: solution.isEmpty ? null : solution,
          clearSolution: solution.isEmpty,
          updatedAt: now,
        );
        await ref.read(worryRepositoryProvider).update(uid, updated);
      } else {
        final worry = Worry(
          id: const Uuid().v4(),
          description: description,
          solution: solution.isEmpty ? null : solution,
          createdAt: now,
          updatedAt: now,
        );
        await ref.read(worryRepositoryProvider).create(uid, worry);
        // 保存成功 — 分析失败不影响用户体验
        try {
          await ref
              .read(analyticsServiceProvider)
              .logFeatureUsed(feature: 'worry_created');
        } on Exception catch (_) {
          // 分析上报失败属非关键错误
        }
      }

      if (mounted) {
        AppFeedback.success(context, context.l10n.awarenessSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[WorryEdit] Save failed: $e');
      if (mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── UI ───

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.worryProcessorTitle : l10n.worryAdd),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppSpacing.paddingScreenBodyFull,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.worryDescriptionHint,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: l10n.worryDescriptionHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.worrySolutionHint,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _solutionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: l10n.worrySolutionHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                          : Text(l10n.worrySave),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }
}
