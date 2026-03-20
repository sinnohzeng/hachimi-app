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

/// 我的夸夸群 — 写下自己的 5 个优点。
class SelfPraiseScreen extends ConsumerStatefulWidget {
  const SelfPraiseScreen({super.key});

  @override
  ConsumerState<SelfPraiseScreen> createState() => _SelfPraiseScreenState();
}

class _SelfPraiseScreenState extends ConsumerState<SelfPraiseScreen> {
  static const _prefsKeySuffix = 'self_praise';

  String get _prefsKey {
    final uid = ref.read(currentUidProvider) ?? 'guest';
    return 'lumi_${uid}_$_prefsKeySuffix';
  }

  static const _count = 5;

  List<String> _prompts(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.selfPraisePrompt1,
      l10n.selfPraisePrompt2,
      l10n.selfPraisePrompt3,
      l10n.selfPraisePrompt4,
      l10n.selfPraisePrompt5,
    ];
  }

  late final List<TextEditingController> _controllers;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_count, (_) => TextEditingController());
    _load();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (var i = 0; i < list.length && i < _count; i++) {
        _controllers[i].text = list[i] as String? ?? '';
      }
      setState(() {});
    } on FormatException {
      // 损坏数据忽略
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final values = _controllers.map((c) => c.text.trim()).toList();
      await prefs.setString(_prefsKey, jsonEncode(values));

      if (mounted) {
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[SelfPraiseScreen] Save failed: $e');
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
      appBar: AppBar(title: Text(context.l10n.selfPraiseScreenTitle)),
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
            Text(context.l10n.selfPraiseSubtitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.selfPraiseHint,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            ...List.generate(
              _count,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TextField(
                  controller: _controllers[i],
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: context.l10n.selfPraiseStrengthLabel(i + 1),
                    hintText: _prompts(context)[i],
                    border: OutlineInputBorder(
                      borderRadius: AppShape.borderSmall,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }
}
