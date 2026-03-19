import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 我的夸夸群 — 写下自己的 5 个优点。
class SelfPraiseScreen extends StatefulWidget {
  const SelfPraiseScreen({super.key});

  @override
  State<SelfPraiseScreen> createState() => _SelfPraiseScreenState();
}

class _SelfPraiseScreenState extends State<SelfPraiseScreen> {
  static const _prefsKey = 'lumi_self_praise';
  static const _count = 5;

  static const _prompts = [
    '我最温暖的品质是...',
    '我擅长的一件事是...',
    '别人常夸我的是...',
    '我为自己骄傲的地方是...',
    '我的独特之处是...',
  ];

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
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[SelfPraiseScreen] Save failed: $e');
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
      appBar: AppBar(title: const Text('我的夸夸群')),
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
            Text('写下你的 5 个优点', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '每个人都值得被看见，尤其是自己',
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
                    labelText: '优点 ${i + 1}',
                    hintText: _prompts[i],
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
