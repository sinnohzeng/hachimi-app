import 'package:flutter/material.dart';

/// TimerDisplay — large formatted timer display (HH:MM:SS).
class TimerDisplay extends StatelessWidget {
  final Duration elapsed;

  const TimerDisplay({super.key, required this.elapsed});

  String _format(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      _format(elapsed),
      style: textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w300,
        color: colorScheme.onSurface,
        letterSpacing: 4,
      ),
    );
  }
}
