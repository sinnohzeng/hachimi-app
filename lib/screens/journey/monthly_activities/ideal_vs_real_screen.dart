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

/// 理想的我 vs. 现在的我 — 双栏对比 + 反思。
class IdealVsRealScreen extends ConsumerStatefulWidget {
  const IdealVsRealScreen({super.key});

  @override
  ConsumerState<IdealVsRealScreen> createState() => _IdealVsRealScreenState();
}

class _IdealVsRealScreenState extends ConsumerState<IdealVsRealScreen> {
  static const _prefsKeySuffix = 'ideal_vs_real';

  String get _prefsKey {
    final uid = ref.read(currentUidProvider) ?? 'guest';
    return 'lumi_${uid}_$_prefsKeySuffix';
  }

  final _idealController = TextEditingController();
  final _realController = TextEditingController();
  final _sameController = TextEditingController();
  final _diffController = TextEditingController();
  final _stepController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _idealController.dispose();
    _realController.dispose();
    _sameController.dispose();
    _diffController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _idealController.text = data['ideal'] as String? ?? '';
      _realController.text = data['real'] as String? ?? '';
      _sameController.text = data['same'] as String? ?? '';
      _diffController.text = data['diff'] as String? ?? '';
      _stepController.text = data['step'] as String? ?? '';
      setState(() {});
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
          'ideal': _idealController.text.trim(),
          'real': _realController.text.trim(),
          'same': _sameController.text.trim(),
          'diff': _diffController.text.trim(),
          'step': _stepController.text.trim(),
          'savedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (mounted) {
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[IdealVsRealScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, context.l10n.commonSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: Text(context.l10n.idealVsRealScreenTitle)),
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
            // 双栏对比
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _columnCard(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    title: context.l10n.idealVsRealIdeal,
                    icon: Icons.auto_awesome_outlined,
                    controller: _idealController,
                    hint: context.l10n.idealVsRealIdealHint,
                    color: colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _columnCard(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    title: context.l10n.idealVsRealReal,
                    icon: Icons.person_outline,
                    controller: _realController,
                    hint: context.l10n.idealVsRealRealHint,
                    color: colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // 反思部分
            _reflectionField(
              textTheme: textTheme,
              colorScheme: colorScheme,
              icon: Icons.compare_arrows,
              label: context.l10n.idealVsRealSame,
              hint: context.l10n.idealVsRealSameHint,
              controller: _sameController,
            ),
            _reflectionField(
              textTheme: textTheme,
              colorScheme: colorScheme,
              icon: Icons.swap_horiz,
              label: context.l10n.idealVsRealDiff,
              hint: context.l10n.idealVsRealDiffHint,
              controller: _diffController,
            ),
            _reflectionField(
              textTheme: textTheme,
              colorScheme: colorScheme,
              icon: Icons.trending_up,
              label: context.l10n.idealVsRealStep,
              hint: context.l10n.idealVsRealStepHint,
              controller: _stepController,
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }

  Widget _columnCard({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required Color color,
  }) {
    return Container(
      padding: AppSpacing.paddingBase,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: AppShape.borderMedium,
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: colorScheme.onSurface),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
            ),
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _reflectionField({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: textTheme.titleSmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
            ),
          ),
        ],
      ),
    );
  }
}
