import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/core/theme/pixel_border_shape.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// UI 风格选择对话框 — Material 3 与 Retro Pixel 两种模式。
///
/// 每个选项附带小型视觉预览卡片，帮助用户直观感受差异：
/// - Material 3：圆角卡片
/// - Retro Pixel：像素阶梯角卡片
class UiStyleDialog extends StatelessWidget {
  const UiStyleDialog({super.key, required this.currentStyle});

  final AppUiStyle currentStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsUiStyle),
      contentPadding: const EdgeInsets.only(top: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StyleOption(
            title: l10n.settingsUiStyleMaterial,
            subtitle: l10n.settingsUiStyleMaterialSubtitle,
            style: AppUiStyle.material,
            isSelected: currentStyle == AppUiStyle.material,
            onTap: () => Navigator.of(context).pop(AppUiStyle.material),
            preview: _MaterialPreview(),
          ),
          _StyleOption(
            title: l10n.settingsUiStyleRetroPixel,
            subtitle: l10n.settingsUiStyleRetroPixelSubtitle,
            style: AppUiStyle.retroPixel,
            isSelected: currentStyle == AppUiStyle.retroPixel,
            onTap: () => Navigator.of(context).pop(AppUiStyle.retroPixel),
            preview: _PixelPreview(),
          ),
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

class _StyleOption extends StatelessWidget {
  const _StyleOption({
    required this.title,
    required this.subtitle,
    required this.style,
    required this.isSelected,
    required this.onTap,
    required this.preview,
  });

  final String title;
  final String subtitle;
  final AppUiStyle style;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: preview,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

/// 圆角卡片预览 — 代表 Material 3 风格。
class _MaterialPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 32,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
    );
  }
}

/// 像素阶梯角卡片预览 — 代表 Retro Pixel 风格。
class _PixelPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 40,
      height: 32,
      child: CustomPaint(
        painter: _PixelPreviewPainter(
          fillColor: isDark
              ? PixelThemeExtension.darkSurface
              : PixelThemeExtension.lightSurface,
          borderColor: colorScheme.outline,
        ),
      ),
    );
  }
}

class _PixelPreviewPainter extends CustomPainter {
  const _PixelPreviewPainter({
    required this.fillColor,
    required this.borderColor,
  });

  final Color fillColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const step = 4.0;
    final path = PixelBorderShape.steppedPath(rect, step);

    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(_PixelPreviewPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        borderColor != oldDelegate.borderColor;
  }
}
