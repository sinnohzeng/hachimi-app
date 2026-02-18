import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';

/// CatSprite — displays a cat with breed-based color tinting.
///
/// Currently uses an emoji placeholder with a color-tinted circle.
/// When real sprites are added to assets/sprites/, this widget will
/// load the appropriate PNG and apply [ColorFiltered] tinting.
///
/// Usage:
/// ```dart
/// CatSprite(breed: 'orange_tabby', stage: 1, mood: 'happy', size: 64)
/// ```
class CatSprite extends StatelessWidget {
  final String breed;
  final int stage; // 1=kitten, 2=young, 3=adult, 4=shiny
  final String mood; // 'happy', 'neutral', 'sad' (sprite key)
  final double size;
  final bool showGlow; // For shiny stage

  const CatSprite({
    super.key,
    required this.breed,
    this.stage = 1,
    this.mood = 'happy',
    this.size = 64,
    this.showGlow = false,
  });

  /// Create from a Cat model.
  factory CatSprite.fromCat({
    Key? key,
    required String breed,
    required int stage,
    required String mood,
    double size = 64,
  }) {
    // Map mood to sprite key
    final moodData = moodById(mood);
    return CatSprite(
      key: key,
      breed: breed,
      stage: stage,
      mood: moodData.spriteKey,
      size: size,
      showGlow: stage >= 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final breedData = breedMap[breed];
    final breedColor = breedData?.colors.base ?? const Color(0xFFA0A0A0);
    final accentColor = breedData?.colors.accent ?? const Color(0xFF696969);
    final isShiny = stage >= 4 || showGlow;

    // Stage-based emoji size scaling
    final emojiSize = switch (stage) {
      1 => size * 0.55, // Kitten: smaller
      2 => size * 0.65, // Young: medium
      3 => size * 0.75, // Adult: full
      _ => size * 0.75, // Shiny: full + glow
    };

    // Stage-based emoji
    final emoji = switch (stage) {
      1 => '🐱',
      2 => '🐈',
      3 => '🐈\u200D⬛',
      _ => '✨🐈\u200D⬛',
    };

    // Mood-based expression overlay
    final moodEmoji = switch (mood) {
      'happy' => '',
      'neutral' => '',
      'sad' => '💤',
      _ => '',
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: breedColor.withValues(alpha: 0.15),
        border: Border.all(
          color: breedColor.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: isShiny
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: breedColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main cat emoji
          Text(
            emoji,
            style: TextStyle(fontSize: emojiSize),
          ),
          // Mood indicator (top-right corner)
          if (moodEmoji.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                moodEmoji,
                style: TextStyle(fontSize: size * 0.25),
              ),
            ),
          // Shiny sparkle effect
          if (isShiny)
            Positioned(
              top: 2,
              left: 2,
              child: Text(
                '✨',
                style: TextStyle(fontSize: size * 0.2),
              ),
            ),
        ],
      ),
    );
  }
}
