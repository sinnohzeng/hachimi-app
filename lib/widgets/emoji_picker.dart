import 'package:flutter/material.dart';

/// Categorized emoji picker for habit icon selection.
/// Shows quick-pick habit emojis at top, with tabbed categories below.
class EmojiPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const EmojiPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  // Quick-pick habit emojis (most relevant for habits)
  static const List<String> habitEmojis = [
    '📚', '💻', '📖', '✍️', '🎓',
    '🏃', '💪', '🧘', '🏋️', '🚴',
    '🎵', '🎸', '🎹', '🎨', '📷',
    '🌱', '🧠', '💼', '📝', '🔬',
    '🗣️', '🌍', '🧹', '🍳', '💊',
    '😴', '💧', '📱', '🎯', '⭐',
  ];

  static const Map<String, List<String>> _categories = {
    'Smileys': [
      '😀', '😃', '😄', '😁', '😊', '🥰', '😍', '🤩',
      '😎', '🤓', '🧐', '🤔', '😇', '🥳', '😋', '🤗',
      '😌', '😏', '🤭', '😶', '🙃', '🫡', '🤝', '👋',
      '👍', '👏', '🙌', '💃', '🧑‍💻', '🧑‍🎨', '🧑‍🔬', '🧑‍🏫',
    ],
    'Animals': [
      '🐱', '🐶', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
      '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
      '🐧', '🐦', '🦋', '🐝', '🐞', '🐢', '🐍', '🦎',
      '🐠', '🐬', '🐳', '🦈', '🐙', '🦑', '🐌', '🦗',
    ],
    'Food': [
      '🍎', '🍊', '🍋', '🍇', '🍓', '🫐', '🍑', '🍒',
      '🥑', '🥦', '🥕', '🌽', '🍕', '🍔', '🌮', '🍜',
      '🍣', '🍰', '🧁', '🍩', '🍪', '☕', '🍵', '🧃',
      '🥤', '🍷', '🍺', '🧋', '🍫', '🍿', '🥗', '🍳',
    ],
    'Activities': [
      '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏓', '🏸',
      '🥊', '🏊', '🧗', '🤸', '🚣', '⛷️', '🎿', '🏂',
      '🎮', '🎲', '🧩', '🎭', '🎪', '🎤', '🎧', '🎼',
      '🎬', '📸', '🧶', '🪡', '🎣', '🏕️', '🎳', '🛹',
    ],
    'Travel': [
      '🚗', '🚕', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒',
      '✈️', '🚀', '🛸', '🚁', '⛵', '🚢', '🏠', '🏢',
      '🏰', '🗼', '🗽', '🌉', '🏖️', '🏔️', '⛰️', '🌋',
      '🗺️', '🧭', '🎡', '🎢', '🌅', '🌄', '🌠', '🎆',
    ],
    'Objects': [
      '⌚', '📱', '💻', '⌨️', '🖥️', '🖨️', '📷', '🎥',
      '💡', '🔦', '🕯️', '📕', '📗', '📘', '📙', '📓',
      '✏️', '🖊️', '🖍️', '📐', '📏', '🔬', '🔭', '🧪',
      '💊', '🩺', '🧲', '🔧', '🔨', '⚙️', '🧰', '🎁',
    ],
    'Symbols': [
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🤎', '🖤',
      '💯', '💢', '💥', '💫', '💦', '🔥', '✨', '🌟',
      '⭐', '🌈', '☀️', '🌙', '⚡', '❄️', '🍀', '🌸',
      '♻️', '☮️', '✅', '❌', '⚠️', '🔴', '🟢', '🔵',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick pick section
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: habitEmojis.map((emoji) {
            return _buildEmojiTile(emoji, colorScheme);
          }).toList(),
        ),
        const SizedBox(height: 16),

        // "More" expandable section with tabs
        Text(
          'More emojis',
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: DefaultTabController(
            length: _categories.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  tabs: _categories.keys.map((name) {
                    return Tab(
                      text: name,
                      height: 36,
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: _categories.values.map((emojis) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: emojis.length,
                        itemBuilder: (context, index) {
                          return _buildEmojiTile(
                              emojis[index], colorScheme);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiTile(String emoji, ColorScheme colorScheme) {
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
  }
}
