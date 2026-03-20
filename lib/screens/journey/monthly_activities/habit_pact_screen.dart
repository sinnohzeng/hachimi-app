import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 我与习惯的约定 — 基于原子习惯四定律的习惯设计。
class HabitPactScreen extends ConsumerStatefulWidget {
  const HabitPactScreen({super.key});

  @override
  ConsumerState<HabitPactScreen> createState() => _HabitPactScreenState();
}

class _HabitPactScreenState extends ConsumerState<HabitPactScreen> {
  static const _prefsKeySuffix = 'habit_pact';

  String get _prefsKey {
    final uid = ref.read(currentUidProvider) ?? 'guest';
    return 'lumi_${uid}_$_prefsKeySuffix';
  }

  String? _selectedCategory;
  final _habitController = TextEditingController();
  final _cueController = TextEditingController();
  final _cravingController = TextEditingController();
  final _responseController = TextEditingController();
  final _rewardController = TextEditingController();
  bool _isSaving = false;

  List<String> _categories(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.habitPactCategoryLearning,
      l10n.habitPactCategoryHealth,
      l10n.habitPactCategoryRelationship,
      l10n.habitPactCategoryHobby,
    ];
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _habitController.dispose();
    _cueController.dispose();
    _cravingController.dispose();
    _responseController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        _selectedCategory = data['category'] as String?;
        _habitController.text = data['habit'] as String? ?? '';
        _cueController.text = data['cue'] as String? ?? '';
        _cravingController.text = data['craving'] as String? ?? '';
        _responseController.text = data['response'] as String? ?? '';
        _rewardController.text = data['reward'] as String? ?? '';
      });
    } on FormatException {
      // 损坏数据忽略
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKey,
        jsonEncode({
          'category': _selectedCategory,
          'habit': _habitController.text.trim(),
          'cue': _cueController.text.trim(),
          'craving': _cravingController.text.trim(),
          'response': _responseController.text.trim(),
          'reward': _rewardController.text.trim(),
          'savedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (mounted) {
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[HabitPactScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, context.l10n.commonSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _declaration(BuildContext context) {
    final habit = _habitController.text.trim();
    final cue = _cueController.text.trim();
    final response = _responseController.text.trim();
    final reward = _rewardController.text.trim();
    final l10n = context.l10n;

    if (habit.isEmpty) return '';
    final parts = <String>[l10n.habitPactDeclarationPrefix(habit)];
    if (cue.isNotEmpty) parts.add(l10n.habitPactDeclarationWhen(cue));
    if (response.isNotEmpty) parts.add(l10n.habitPactDeclarationWill(response));
    if (reward.isNotEmpty) parts.add(l10n.habitPactDeclarationThen(reward));
    return '${parts.join(', ')}.';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: Text(context.l10n.habitPactScreenTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: Text(context.l10n.commonSave),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step 1: 选择类别
            _sectionTitle(
              textTheme,
              colorScheme,
              '1',
              context.l10n.habitPactStep1,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: _categories(context).map((cat) {
                final selected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (v) =>
                      setState(() => _selectedCategory = v ? cat : null),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _habitController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: context.l10n.habitPactHabitLabel,
                hintText: context.l10n.habitPactHabitHint,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Step 2: 四定律
            _sectionTitle(
              textTheme,
              colorScheme,
              '2',
              context.l10n.habitPactStep2,
            ),
            const SizedBox(height: AppSpacing.sm),
            _lawField(
              label: context.l10n.habitPactLawVisible,
              hint: context.l10n.habitPactLawVisibleHint,
              controller: _cueController,
            ),
            _lawField(
              label: context.l10n.habitPactLawAttractive,
              hint: context.l10n.habitPactLawAttractiveHint,
              controller: _cravingController,
            ),
            _lawField(
              label: context.l10n.habitPactLawEasy,
              hint: context.l10n.habitPactLawEasyHint,
              controller: _responseController,
            ),
            _lawField(
              label: context.l10n.habitPactLawRewarding,
              hint: context.l10n.habitPactLawRewardingHint,
              controller: _rewardController,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Step 3: 宣言
            _sectionTitle(
              textTheme,
              colorScheme,
              '3',
              context.l10n.habitPactStep3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Builder(
              builder: (ctx) {
                final decl = _declaration(ctx);
                return Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingBase,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: AppShape.borderMedium,
                  ),
                  child: Text(
                    decl.isEmpty ? ctx.l10n.habitPactDeclarationEmpty : decl,
                    style: textTheme.bodyLarge?.copyWith(
                      color: decl.isEmpty
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      fontStyle: decl.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }

  Widget _lawField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextField(
        controller: controller,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String step,
    String title,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: colorScheme.primary,
          child: Text(
            step,
            style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: textTheme.titleSmall),
      ],
    );
  }
}
