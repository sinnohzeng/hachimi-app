// ---
// 📘 文件说明：
// Forest 风格圆环拨盘时间选择器 — 用于 FocusSetupScreen。
// 通过 GestureDetector + CustomPainter 实现拖拽选择 1-120 分钟。
//
// 📋 程序整体伪代码（中文）：
// 1. 绘制灰色底环（track）；
// 2. 绘制彩色填充弧线（从 12 点方向顺时针）；
// 3. 绘制刻度线：大刻度每 15 分钟，小刻度每 5 分钟；
// 4. 绘制可拖拽的圆形 thumb；
// 5. 环中心显示 "XX min" 文字；
// 6. GestureDetector 处理 pan 手势 → 计算角度 → 映射到分钟数；
//
// 🕒 创建时间：2026-02-19
// ---

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Forest-style circular duration picker.
/// Draggable ring that maps 0°–360° to 1–120 minutes.
class CircularDurationPicker extends StatefulWidget {
  final int value; // current minutes (1-120)
  final ValueChanged<int> onChanged;
  final double size;

  const CircularDurationPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 220,
  });

  @override
  State<CircularDurationPicker> createState() => _CircularDurationPickerState();
}

class _CircularDurationPickerState extends State<CircularDurationPicker> {
  static const int _maxMinutes = 120;
  static const int _minMinutes = 1;

  /// Track previous angle to detect boundary crossings during drag.
  double? _previousAngle;

  /// Convert touch position to angle in radians (0..2π, 0 = 12 o'clock).
  double _positionToAngle(Offset localPosition) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    // atan2 gives angle from positive X axis; rotate by +90° so 12 o'clock = 0°.
    var angle = atan2(dy, dx) + pi / 2;
    if (angle < 0) angle += 2 * pi;
    return angle;
  }

  /// Convert angle to minutes.
  int _angleToMinutes(double angle) {
    final minutes = (angle / (2 * pi) * _maxMinutes).round();
    return minutes.clamp(_minMinutes, _maxMinutes);
  }

  void _handleTap(Offset localPosition) {
    // Taps can freely jump to any position — no anti-wrap clamping.
    final angle = _positionToAngle(localPosition);
    _previousAngle = angle;
    final minutes = _angleToMinutes(angle);
    if (minutes != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged(minutes);
    }
  }

  void _handlePanStart(Offset localPosition) {
    _previousAngle = _positionToAngle(localPosition);
  }

  void _handlePan(Offset localPosition) {
    final angle = _positionToAngle(localPosition);
    final prev = _previousAngle;

    if (prev != null) {
      // Detect crossing the 360°/0° boundary (near 12 o'clock).
      // A large jump (> π) between consecutive pan events indicates wrapping.
      final delta = angle - prev;
      if (delta > pi) {
        // Crossed backward past 0° (e.g. from near 1min to near 120min)
        // → clamp to minimum
        _previousAngle = 0.0;
        if (widget.value != _minMinutes) {
          HapticFeedback.selectionClick();
          widget.onChanged(_minMinutes);
        }
        return;
      } else if (delta < -pi) {
        // Crossed forward past 360° (e.g. from near 120min to near 1min)
        // → clamp to maximum
        _previousAngle = 2 * pi;
        if (widget.value != _maxMinutes) {
          HapticFeedback.selectionClick();
          widget.onChanged(_maxMinutes);
        }
        return;
      }
    }

    _previousAngle = angle;
    final minutes = _angleToMinutes(angle);
    if (minutes != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged(minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onPanStart: (details) => _handlePanStart(details.localPosition),
      onPanUpdate: (details) => _handlePan(details.localPosition),
      onPanEnd: (_) => _previousAngle = null,
      onTapDown: (details) => _handleTap(details.localPosition),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _DurationPickerPainter(
            value: widget.value,
            maxMinutes: _maxMinutes,
            trackColor: colorScheme.surfaceContainerHighest,
            activeColor: colorScheme.primary,
            thumbColor: colorScheme.primary,
            tickColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            majorTickColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.value}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'min',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationPickerPainter extends CustomPainter {
  final int value;
  final int maxMinutes;
  final Color trackColor;
  final Color activeColor;
  final Color thumbColor;
  final Color tickColor;
  final Color majorTickColor;

  static const double _trackWidth = 12.0;
  static const double _thumbRadius = 14.0;

  _DurationPickerPainter({
    required this.value,
    required this.maxMinutes,
    required this.trackColor,
    required this.activeColor,
    required this.thumbColor,
    required this.tickColor,
    required this.majorTickColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - _trackWidth - _thumbRadius * 2) / 2;

    // 1. Draw track (background circle)
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _trackWidth
      ..color = trackColor
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw active arc
    final progress = value / maxMinutes;
    if (progress > 0) {
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _trackWidth
        ..color = activeColor
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from 12 o'clock
        2 * pi * progress,
        false,
        arcPaint,
      );
    }

    // 3. Draw tick marks
    for (int m = 0; m <= maxMinutes; m += 5) {
      final isMajor = m % 15 == 0;
      final angle = (m / maxMinutes) * 2 * pi - pi / 2;

      final outerR = radius + _trackWidth / 2 + 2;
      final innerR = isMajor ? outerR - 10 : outerR - 6;

      final outerPoint = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );

      final tickPaint = Paint()
        ..strokeWidth = isMajor ? 2.0 : 1.0
        ..color = isMajor ? majorTickColor : tickColor
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // 4. Draw thumb
    final thumbAngle = (value / maxMinutes) * 2 * pi - pi / 2;
    final thumbCenter = Offset(
      center.dx + radius * cos(thumbAngle),
      center.dy + radius * sin(thumbAngle),
    );

    // Thumb shadow
    canvas.drawCircle(
      thumbCenter + const Offset(0, 1),
      _thumbRadius,
      Paint()..color = thumbColor.withValues(alpha: 0.3),
    );

    // Thumb fill
    canvas.drawCircle(
      thumbCenter,
      _thumbRadius,
      Paint()..color = thumbColor,
    );

    // Thumb inner circle
    canvas.drawCircle(
      thumbCenter,
      _thumbRadius - 4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_DurationPickerPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.activeColor != activeColor;
}
