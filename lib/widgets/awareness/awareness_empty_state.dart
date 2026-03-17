import 'package:flutter/material.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/widgets/empty_state.dart';

/// 觉知模块空态类型。
enum AwarenessEmptyType { todayLight, weeklyReview, history, worries }

/// AwarenessEmptyState — 觉知模块空态组件。
///
/// 按 [type] 委托给通用 [EmptyState]，
/// 自动匹配图标、标题、副标题和操作按钮文案。
class AwarenessEmptyState extends StatelessWidget {
  /// 空态类型。
  final AwarenessEmptyType type;

  /// 操作按钮回调。
  final VoidCallback? onAction;

  const AwarenessEmptyState({super.key, required this.type, this.onAction});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final config = _resolveConfig(l10n);

    return EmptyState(
      icon: config.icon,
      title: config.title,
      subtitle: config.subtitle,
      actionLabel: config.actionLabel,
      onAction: onAction,
    );
  }

  _EmptyConfig _resolveConfig(S l10n) {
    return switch (type) {
      AwarenessEmptyType.todayLight => _EmptyConfig(
        icon: Icons.wb_sunny_outlined,
        title: l10n.awarenessEmptyLightTitle,
        subtitle: l10n.awarenessEmptyLightSubtitle,
        actionLabel: l10n.awarenessEmptyLightAction,
      ),
      AwarenessEmptyType.weeklyReview => _EmptyConfig(
        icon: Icons.calendar_view_week_outlined,
        title: l10n.awarenessEmptyReviewTitle,
        subtitle: l10n.awarenessEmptyReviewSubtitle,
        actionLabel: l10n.awarenessEmptyReviewAction,
      ),
      AwarenessEmptyType.history => _EmptyConfig(
        icon: Icons.history_outlined,
        title: l10n.awarenessEmptyHistoryTitle,
        subtitle: l10n.awarenessEmptyHistorySubtitle,
        actionLabel: null,
      ),
      AwarenessEmptyType.worries => _EmptyConfig(
        icon: Icons.cloud_outlined,
        title: l10n.awarenessEmptyWorriesTitle,
        subtitle: l10n.awarenessEmptyWorriesSubtitle,
        actionLabel: null,
      ),
    };
  }
}

class _EmptyConfig {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;

  const _EmptyConfig({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
  });
}
