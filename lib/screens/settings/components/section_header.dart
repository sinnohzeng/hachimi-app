import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';

/// Section header label used in settings groups.
///
/// 自动感知 UI 风格：当 [PixelThemeExtension] 存在时使用像素字体 +
/// "━━━" 装饰线；否则保持 Material 3 默认样式。
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
    final pixelExt = Theme.of(context).extension<PixelThemeExtension>();
    final isRetro = pixelExt?.isRetro ?? false;

    if (isRetro && pixelExt != null) {
      final labelStyle = pixelExt.pixelLabel;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: [
            Text(
              '━━ ',
              style: labelStyle.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            Text(
              title,
              style: labelStyle.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '━━━━━━━━━━━━━━━━━━━━',
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: labelStyle.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
