import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 我身边的人 — 记录支持你的人。
class SupportMapScreen extends StatefulWidget {
  const SupportMapScreen({super.key});

  @override
  State<SupportMapScreen> createState() => _SupportMapScreenState();
}

class _SupportMapScreenState extends State<SupportMapScreen> {
  static const _prefsKey = 'lumi_support_map';

  final _entries = <_SupportEntry>[];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) {
      // 默认 3 个空条目
      setState(() {
        for (var i = 0; i < 3; i++) {
          _entries.add(_SupportEntry());
        }
      });
      return;
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      setState(() {
        for (final item in list) {
          final map = item as Map<String, dynamic>;
          _entries.add(
            _SupportEntry(
              name: map['name'] as String? ?? '',
              relationship: map['relationship'] as String? ?? '',
            ),
          );
        }
        if (_entries.isEmpty) {
          for (var i = 0; i < 3; i++) {
            _entries.add(_SupportEntry());
          }
        }
      });
    } on FormatException {
      setState(() {
        for (var i = 0; i < 3; i++) {
          _entries.add(_SupportEntry());
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _entries
          .where((e) => e.nameController.text.trim().isNotEmpty)
          .map(
            (e) => {
              'name': e.nameController.text.trim(),
              'relationship': e.relationshipController.text.trim(),
            },
          )
          .toList();
      await prefs.setString(_prefsKey, jsonEncode(data));

      if (mounted) {
        AppFeedback.success(context, '已保存');
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[SupportMapScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, '保存失败');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addEntry() {
    setState(() => _entries.add(_SupportEntry()));
  }

  void _removeEntry(int index) {
    setState(() {
      _entries[index].dispose();
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('我身边的人')),
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
            Text('谁在支持你？', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '记录身边重要的人，提醒自己并不孤单',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            ...List.generate(
              _entries.length,
              (i) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _entries[i].nameController,
                              decoration: InputDecoration(
                                labelText: '姓名',
                                border: OutlineInputBorder(
                                  borderRadius: AppShape.borderSmall,
                                ),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextField(
                              controller: _entries[i].relationshipController,
                              decoration: InputDecoration(
                                labelText: '关系',
                                hintText: '例：朋友/家人/同事',
                                border: OutlineInputBorder(
                                  borderRadius: AppShape.borderSmall,
                                ),
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: colorScheme.error,
                        ),
                        onPressed: () => _removeEntry(i),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
            Center(
              child: TextButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ),

            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }
}

class _SupportEntry {
  final TextEditingController nameController;
  final TextEditingController relationshipController;

  _SupportEntry({String name = '', String relationship = ''})
    : nameController = TextEditingController(text: name),
      relationshipController = TextEditingController(text: relationship);

  void dispose() {
    nameController.dispose();
    relationshipController.dispose();
  }
}
