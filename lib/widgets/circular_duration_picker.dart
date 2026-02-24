import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';

/// Forest-style circular duration picker.
/// Draggable ring that maps 0°–360° to 5–120 minutes (5-minute steps).
class CircularDurationPicker extends StatefulWidget {
  final int value; // current minutes (5-120)
  final ValueChanged<int> onChanged;
  final double size;

  /// Called when the user starts dragging the dial.
  final VoidCallback? onDragStart;

  /// Called when the user stops dragging the dial.
  final VoidCallback? onDragEnd;

  const CircularDurationPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 220,
    this.onDragStart,
    this.onDragEnd,
  });

  @override
  State<CircularDurationPicker> createState() => _CircularDurationPickerState();
}

class _CircularDurationPickerState extends State<CircularDurationPicker> {
  static const int _maxMinutes = 120;
  static const int _minMinutes = 5;
  static const int _stepMinutes = 5;

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

  int _angleToMinutes(double angle) {
    final raw = angle / (2 * pi) * _maxMinutes;
    final snapped = (raw / _stepMinutes).round() * _stepMinutes;
    return snapped.clamp(_minMinutes, _maxMinutes);
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
    widget.onDragStart?.call();
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

    return Semantics(
      label: 'Duration picker, ${widget.value} minutes',
      value: '${widget.value} minutes',
      slider: true,
      child: GestureDetector(
        onPanStart: (details) => _handlePanStart(details.localPosition),
        onPanUpdate: (details) => _handlePan(details.localPosition),
        onPanEnd: (_) {
          _previousAngle = null;
          widget.onDragEnd?.call();
        },
        onPanCancel: () {
          _previousAngle = null;
          widget.onDragEnd?.call();
        },
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
              thumbInnerColor: colorScheme.surface,
              tickColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              majorTickColor: colorScheme.onSurfaceVariant.withValues(
                alpha: 0.6,
              ),
            ),
            child: Center(
              child: ExcludeSemantics(
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
                      context.l10n.pickerMinUnit,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
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
  final Color thumbInnerColor;
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
    required this.thumbInnerColor,
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

    canvas.drawCircle(
      thumbCenter + const Offset(0, 1),
      _thumbRadius,
      Paint()..color = thumbColor.withValues(alpha: 0.3),
    );
    canvas.drawCircle(thumbCenter, _thumbRadius, Paint()..color = thumbColor);
    canvas.drawCircle(
      thumbCenter,
      _thumbRadius - 4,
      Paint()..color = thumbInnerColor,
    );
  }

  @override
  bool shouldRepaint(_DurationPickerPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.activeColor != activeColor;
}
