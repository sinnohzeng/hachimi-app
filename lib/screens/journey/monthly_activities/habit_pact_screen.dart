import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 我与习惯的约定 — 基于原子习惯四定律的习惯设计。
class HabitPactScreen extends StatefulWidget {
  const HabitPactScreen({super.key});

  @override
  State<HabitPactScreen> createState() => _HabitPactScreenState();
}

class _HabitPactScreenState extends State<HabitPactScreen> {
  static const _prefsKey = 'lumi_habit_pact';

  String? _selectedCategory;
  final _habitController = TextEditingController();
  final _cueController = TextEditingController();
  final _cravingController = TextEditingController();
  final _responseController = TextEditingController();
  final _rewardController = TextEditingController();
  bool _isSaving = false;

  static const _categories = ['学习', '健康', '关系', '兴趣'];

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
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[HabitPactScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String get _declaration {
    final habit = _habitController.text.trim();
    final cue = _cueController.text.trim();
    final response = _responseController.text.trim();
    final reward = _rewardController.text.trim();

    if (habit.isEmpty) return '';
    final parts = <String>['我决定养成「$habit」的习惯'];
    if (cue.isNotEmpty) parts.add('当$cue时');
    if (response.isNotEmpty) parts.add('我会$response');
    if (reward.isNotEmpty) parts.add('然后$reward');
    return '${parts.join('，')}。';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('我与习惯的约定')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: const Text('保存'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step 1: 选择类别
            _sectionTitle(textTheme, colorScheme, '1', '我想养成什么习惯？'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: _categories.map((cat) {
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
                labelText: '具体习惯',
                hintText: '例：每天读 20 页书',
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Step 2: 四定律
            _sectionTitle(textTheme, colorScheme, '2', '习惯四定律设计'),
            const SizedBox(height: AppSpacing.sm),
            _lawField(
              label: '看得见',
              hint: '我会把提示放在...',
              controller: _cueController,
            ),
            _lawField(
              label: '想去做',
              hint: '我会把它和...连在一起',
              controller: _cravingController,
            ),
            _lawField(
              label: '易上手',
              hint: '我设计的最小版本是...',
              controller: _responseController,
            ),
            _lawField(
              label: '有奖励',
              hint: '完成后我会奖励自己...',
              controller: _rewardController,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Step 3: 宣言
            _sectionTitle(textTheme, colorScheme, '3', '行动宣言'),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingBase,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: AppShape.borderMedium,
              ),
              child: Text(
                _declaration.isEmpty ? '填写上方内容，自动生成宣言...' : _declaration,
                style: textTheme.bodyLarge?.copyWith(
                  color: _declaration.isEmpty
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  fontStyle: _declaration.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
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
