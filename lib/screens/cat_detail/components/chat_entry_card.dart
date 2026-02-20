// ---
// 📘 文件说明：
// Chat Entry Card — 聊天入口卡片组件。
// 在 Diary Preview 下方，提升聊天功能可发现性。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 catId 和 catName；
// 2. 渲染聊天图标 + 标题 + 副标题 + 箭头；
// 3. 点击跳转到猫猫聊天页；
//
// 🧩 文件结构：
// - ChatEntryCard：聊天入口卡片 StatelessWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// 聊天入口卡片 — 在 Diary Preview 下方，提升聊天功能可发现性。
class ChatEntryCard extends StatelessWidget {
  final String catId;
  final String catName;

  const ChatEntryCard({super.key, required this.catId, required this.catName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRouter.catChat, arguments: catId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Row(
            children: [
              const Text('\u{1F4AC}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.catDetailChatWith(catName),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.catDetailChatSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
