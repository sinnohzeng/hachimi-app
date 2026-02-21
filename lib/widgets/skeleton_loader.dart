import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';

/// SkeletonLoader — generic shimmer placeholder block.
///
/// Usage:
/// ```dart
/// SkeletonLoader(width: 120, height: 16) // text line
/// SkeletonLoader(width: 48, height: 48, borderRadius: 24) // avatar
/// ```
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = isDark
        ? colorScheme.surface
        : colorScheme.surfaceContainerLow;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerValue = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * shimmerValue, 0),
              end: Alignment(1.0 + 2.0 * shimmerValue, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// SkeletonCard — mimics a HabitRow / generic card with avatar + text lines.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            const SkeletonLoader(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 14,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SkeletonLoader(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 12,
                  ),
                ],
              ),
            ),
            const SkeletonLoader(width: 32, height: 32, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

/// SkeletonGrid — mimics a 2-column grid of cat cards.
class SkeletonGrid extends StatelessWidget {
  final int count;

  const SkeletonGrid({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.paddingMd,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: count,
      itemBuilder: (context, index) => const Card(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            children: [
              SkeletonLoader(width: 80, height: 80, borderRadius: 8),
              SizedBox(height: AppSpacing.sm),
              SkeletonLoader(width: 60, height: 14),
              SizedBox(height: 6),
              SkeletonLoader(width: 80, height: 12),
              Spacer(),
              SkeletonLoader(height: 6, borderRadius: 3),
            ],
          ),
        ),
      ),
    );
  }
}
