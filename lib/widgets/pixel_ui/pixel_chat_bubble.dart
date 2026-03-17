import 'package:flutter/material.dart';

import '../../core/theme/pixel_theme_extension.dart';

/// 像素风聊天气泡 — 阶梯角边框 + 像素三角尾巴。
///
/// [isUser] = true 时气泡右对齐（主色填充），
/// false 时左对齐（复古表面色填充 + 猫爪图标前缀）。
class PixelChatBubble extends StatelessWidget {
  const PixelChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  final String text;
  final bool isUser;

  /// 是否正在流式输出（显示闪烁光标）
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final pixel = context.pixel;
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final bgColor = isUser ? scheme.primary : pixel.retroSurface;
    final fgColor = isUser ? scheme.onPrimary : scheme.onSurface;
    final borderColor = pixel.pixelBorder;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            CustomPaint(
              painter: _BubblePainter(
                fillColor: bgColor,
                borderColor: borderColor,
                isUser: isUser,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      const ExcludeSemantics(
                        child: Text('🐾 ', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: text,
                          children: [
                            if (isStreaming)
                              WidgetSpan(
                                child: _BlinkingCursor(color: fgColor),
                              ),
                          ],
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: fgColor,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 像素三角尾巴
            Padding(
              padding: EdgeInsets.only(
                left: isUser ? 0 : 16,
                right: isUser ? 16 : 0,
              ),
              child: CustomPaint(
                size: const Size(10, 6),
                painter: _TailPainter(
                  fillColor: bgColor,
                  borderColor: borderColor,
                  isUser: isUser,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 闪烁光标 — 流式输出时显示在文本末尾。
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor({required this.color});

  final Color color;

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text('_', style: TextStyle(color: widget.color)),
    );
  }
}

/// 气泡主体 — 阶梯角矩形。
class _BubblePainter extends CustomPainter {
  _BubblePainter({
    required this.fillColor,
    required this.borderColor,
    required this.isUser,
  });

  final Color fillColor;
  final Color borderColor;
  final bool isUser;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 4.0;
    final path = Path()
      ..moveTo(step, 0)
      ..lineTo(size.width - step, 0)
      ..lineTo(size.width - step, step)
      ..lineTo(size.width, step)
      ..lineTo(size.width, size.height - step)
      ..lineTo(size.width - step, size.height - step)
      ..lineTo(size.width - step, size.height)
      ..lineTo(step, size.height)
      ..lineTo(step, size.height - step)
      ..lineTo(0, size.height - step)
      ..lineTo(0, step)
      ..lineTo(step, step)
      ..close();

    canvas.drawPath(path, Paint()..color = fillColor);
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
  bool shouldRepaint(_BubblePainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        borderColor != oldDelegate.borderColor;
  }
}

/// 尾巴三角 — 像素风阶梯三角形。
class _TailPainter extends CustomPainter {
  _TailPainter({
    required this.fillColor,
    required this.borderColor,
    required this.isUser,
  });

  final Color fillColor;
  final Color borderColor;
  final bool isUser;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (isUser) {
      // 右侧尾巴
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width - size.width, size.height * 0.4)
        ..close();
    } else {
      // 左侧尾巴
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height * 0.4)
        ..close();
    }

    canvas.drawPath(path, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(_TailPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        borderColor != oldDelegate.borderColor;
  }
}
