// ---
// 📘 文件说明：
// 分组标题组件 — 设置页面各区块的标题栏。
//
// 🧩 文件结构：
// - SectionHeader：分组标题 StatelessWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';

/// Section header label used in settings groups.
class SectionHeader extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;

  const SectionHeader({
    super.key,
    required this.title,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
