import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/auth/login_screen.dart';

/// 显示访客升级提示底部弹窗。
void showGuestUpgradePrompt(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
    builder: (_) => const _GuestUpgradeContent(),
  );
}

class _GuestUpgradeContent extends StatelessWidget {
  const _GuestUpgradeContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 48, color: colorScheme.primary),
            const SizedBox(height: AppSpacing.base),
            Text(
              l10n.guestUpgradeTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.guestUpgradeMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(linkMode: true),
                    ),
                  );
                },
                icon: const Icon(Icons.link),
                label: Text(l10n.guestUpgradeLinkButton),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.guestUpgradeLater),
            ),
          ],
        ),
      ),
    );
  }
}
