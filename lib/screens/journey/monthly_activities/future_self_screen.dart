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

/// 未来照见我 — 3 种未来版本 + 反思。
class FutureSelfScreen extends ConsumerStatefulWidget {
  const FutureSelfScreen({super.key});

  @override
  ConsumerState<FutureSelfScreen> createState() => _FutureSelfScreenState();
}

class _FutureSelfScreenState extends ConsumerState<FutureSelfScreen> {
  static const _prefsKeySuffix = 'future_self';

  String get _prefsKey {
    final uid = ref.read(currentUidProvider) ?? 'guest';
    return 'lumi_${uid}_$_prefsKeySuffix';
  }

  final _stableController = TextEditingController();
  final _freeController = TextEditingController();
  final _paceController = TextEditingController();
  final _coreController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stableController.dispose();
    _freeController.dispose();
    _paceController.dispose();
    _coreController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _stableController.text = data['stable'] as String? ?? '';
      _freeController.text = data['free'] as String? ?? '';
      _paceController.text = data['pace'] as String? ?? '';
      _coreController.text = data['core'] as String? ?? '';
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
          'stable': _stableController.text.trim(),
          'free': _freeController.text.trim(),
          'pace': _paceController.text.trim(),
          'core': _coreController.text.trim(),
          'savedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (mounted) {
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[FutureSelfScreen] Save failed: $e');
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
      appBar: AppBar(title: Text(context.l10n.futureSelfScreenTitle)),
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
            Text(context.l10n.futureSelfSubtitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.futureSelfHint,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _futureField(
              icon: Icons.home_outlined,
              label: context.l10n.futureSelfStable,
              hint: context.l10n.futureSelfStableHint,
              controller: _stableController,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _futureField(
              icon: Icons.flight_outlined,
              label: context.l10n.futureSelfFree,
              hint: context.l10n.futureSelfFreeHint,
              controller: _freeController,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _futureField(
              icon: Icons.self_improvement_outlined,
              label: context.l10n.futureSelfPace,
              hint: context.l10n.futureSelfPaceHint,
              controller: _paceController,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.futureSelfCoreLabel,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _coreController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: context.l10n.futureSelfCoreHint,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }

  Widget _futureField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
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
              Text(label, style: textTheme.titleSmall),
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
