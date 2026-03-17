import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';
import 'pixel_badge.dart';
import 'pixel_border.dart';

/// 像素风日记条目 — 像素边框 + 日期标签 + 心情徽章 + 正文。
///
/// 取代 CatDiaryScreen 中的 Material Card。
class PixelDiaryEntry extends StatelessWidget {
  const PixelDiaryEntry({
    super.key,
    required this.date,
    required this.content,
    this.moodEmoji,
    this.moodName,
    this.personality,
    this.stage,
    this.onTap,
  });

  /// 格式化后的日期文本（如 "Mar 13"）
  final String date;

  /// 日记正文
  final String content;

  /// 心情 emoji
  final String? moodEmoji;

  /// 心情名称
  final String? moodName;

  /// 性格文本
  final String? personality;

  /// 阶段文本
  final String? stage;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final theme = Theme.of(context);

    final entry = PixelBorder(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶行：日期 + 心情徽章
          Row(
            children: [
              Text(date, style: pixel.pixelHeading),
              const Spacer(),
              if (moodEmoji != null && moodName != null)
                PixelBadge(
                  text: moodName!,
                  icon: Text(moodEmoji!, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),

          // 性格 + 阶段行
          if (personality != null || stage != null) ...[
            const SizedBox(height: 6),
            Text(
              [personality, stage].whereType<String>().join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          // 像素分隔线
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _PixelDividerPainter(
                color: pixel.pixelBorder.withValues(alpha: 0.2),
              ),
            ),
          ),

          // 正文
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );

    if (onTap == null) return entry;

    return Semantics(
      button: true,
      child: GestureDetector(onTap: onTap, child: entry),
    );
  }
}

class _PixelDividerPainter extends CustomPainter {
  _PixelDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 3.0;
    const gap = 3.0;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;

    var x = 0.0;
    while (x < size.width) {
      canvas.drawRect(Rect.fromLTWH(x, 0, dash, 1), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_PixelDividerPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
