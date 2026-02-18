import 'package:flutter/material.dart';

/// Curated emoji grid for habit icon selection.
/// Shows ~30 habit-relevant emoji in a Wrap layout.
class EmojiPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const EmojiPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<String> habitEmojis = [
    '📚', '💻', '📖', '✍️', '🎓',
    '🏃', '💪', '🧘', '🏋️', '🚴',
    '🎵', '🎸', '🎹', '🎨', '📷',
    '🌱', '🧠', '💼', '📝', '🔬',
    '🗣️', '🌍', '🧹', '🍳', '💊',
    '😴', '💧', '📱', '🎯', '⭐',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: habitEmojis.map((emoji) {
        final isSelected = selected == emoji;
        return GestureDetector(
          onTap: () => onSelected(emoji),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }).toList(),
    );
  }
}
