import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/theme_provider.dart';

/// 主题色选择 dialog，包含「动态壁纸色」和 8 个预设色。
class ThemeColorDialog extends ConsumerWidget {
  const ThemeColorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final themeSettings = ref.watch(themeProvider);
    final isDynamic = themeSettings.useDynamicColor;

    return AlertDialog(
      title: Text(l10n.settingsThemeColor),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // 「动态壁纸色」选项
          _DynamicColorOption(
            isSelected: isDynamic,
            onTap: () {
              ref.read(themeProvider.notifier).setDynamicColor(true);
              Navigator.of(context).pop();
            },
            label: l10n.settingsThemeColorDynamic,
            colorScheme: colorScheme,
          ),
          // 8 个预设色
          ...AppTheme.presetColors.map((color) {
            final isSelected =
                !isDynamic &&
                color.toARGB32() == themeSettings.seedColor.toARGB32();
            return Semantics(
              button: true,
              label: isSelected ? 'Theme color, selected' : 'Theme color',
              selected: isSelected,
              child: GestureDetector(
                onTap: () {
                  ref.read(themeProvider.notifier).setDynamicColor(false);
                  ref.read(themeProvider.notifier).setSeedColor(color);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: colorScheme.onSurface, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 24,
                          semanticLabel: 'Selected',
                        )
                      : null,
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ],
    );
  }
}

/// 动态壁纸色选项：渐变圆圈 + wallpaper 图标。
class _DynamicColorOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final ColorScheme colorScheme;

  const _DynamicColorOption({
    required this.isSelected,
    required this.onTap,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  colors: [
                    Color(0xFF4285F4),
                    Color(0xFF34A853),
                    Color(0xFFFBBC05),
                    Color(0xFFEA4335),
                    Color(0xFF4285F4),
                  ],
                ),
                border: isSelected
                    ? Border.all(color: colorScheme.onSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                      size: 24,
                      semanticLabel: 'Selected',
                    )
                  : Icon(
                      Icons.wallpaper_outlined,
                      color: colorScheme.onPrimary.withValues(alpha: 0.9),
                      size: 22,
                      semanticLabel: 'Dynamic wallpaper color',
                    ),
            ),
            const SizedBox(height: 4),
            ExcludeSemantics(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
