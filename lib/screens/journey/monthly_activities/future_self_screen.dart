import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 未来照见我 — 3 种未来版本 + 反思。
class FutureSelfScreen extends StatefulWidget {
  const FutureSelfScreen({super.key});

  @override
  State<FutureSelfScreen> createState() => _FutureSelfScreenState();
}

class _FutureSelfScreenState extends State<FutureSelfScreen> {
  static const _prefsKey = 'lumi_future_self';

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
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[FutureSelfScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('未来照见我')),
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
            Text('想象 3 种未来的自己', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '不需要完美答案，让想象自由流动',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _futureField(
              icon: Icons.home_outlined,
              label: '稳定的未来',
              hint: '如果一切顺利，稳定发展，你的生活会是什么样？',
              controller: _stableController,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _futureField(
              icon: Icons.flight_outlined,
              label: '自由的未来',
              hint: '如果没有任何限制，你最想做什么？',
              controller: _freeController,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _futureField(
              icon: Icons.self_improvement_outlined,
              label: '按自己节奏发展的未来',
              hint: '不急不缓，你理想中的节奏是什么样的？',
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
                Text('你真正在意的是什么？', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _coreController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '看看上面的 3 个版本，它们有什么共同点？那可能就是你内心最在意的...',
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
