import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/cat_sprite.dart';

/// Cat Room — the emotional centerpiece of the app.
/// A cozy illustrated room scene where cats are placed at personality-based positions.
class CatRoomScreen extends ConsumerStatefulWidget {
  const CatRoomScreen({super.key});

  @override
  ConsumerState<CatRoomScreen> createState() => _CatRoomScreenState();
}

class _CatRoomScreenState extends ConsumerState<CatRoomScreen> {
  String? _tappedCatId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final catsAsync = ref.watch(catsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cat Room')),
      body: catsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (cats) {
          if (cats.isEmpty) {
            return _buildEmptyRoom(theme);
          }

          // Show max 10 cats in the room
          final roomCats = cats.take(10).toList();
          final hasMore = cats.length > 10;

          // Determine day/night
          final hour = DateTime.now().hour;
          final isNight = hour < 6 || hour >= 20;

          return Stack(
            children: [
              // Room background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isNight
                          ? [
                              const Color(0xFF1A1A3E),
                              const Color(0xFF2D2D5E),
                              const Color(0xFF3D3D4E),
                            ]
                          : [
                              const Color(0xFFF5E6CA),
                              const Color(0xFFFFF8E1),
                              const Color(0xFFFFECB3),
                            ],
                    ),
                  ),
                ),
              ),

              // Room decorations (simple geometric furniture)
              ..._buildRoomFurniture(context, isNight),

              // Cats placed at their slots
              ...roomCats.map((cat) => _buildPositionedCat(
                    context,
                    cat,
                    MediaQuery.of(context).size,
                  )),

              // Day/Night indicator
              Positioned(
                top: 8,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isNight ? Colors.indigo : Colors.amber)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isNight ? '🌙 Night' : '☀️ Day',
                    style: textTheme.labelSmall,
                  ),
                ),
              ),

              // Speech bubble for tapped cat
              if (_tappedCatId != null)
                ..._buildSpeechBubble(context, roomCats),

              // "See all cats" button
              if (hasMore)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        // TODO: Navigate to cat album
                      },
                      icon: const Icon(Icons.grid_view),
                      label: Text('See all ${cats.length} cats'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyRoom(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🏠', style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Your room is empty',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a habit to adopt your first cat!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build room furniture as simple colored containers.
  List<Widget> _buildRoomFurniture(BuildContext context, bool isNight) {
    final size = MediaQuery.of(context).size;
    final furnitureColor =
        isNight ? const Color(0xFF4A4A6A) : const Color(0xFFD7CCC8);
    final accentColor =
        isNight ? const Color(0xFF5A5A7A) : const Color(0xFFBCAAA4);

    return [
      // Window
      Positioned(
        left: size.width * 0.6,
        top: size.height * 0.05,
        child: Container(
          width: size.width * 0.3,
          height: size.height * 0.15,
          decoration: BoxDecoration(
            color: isNight
                ? const Color(0xFF1A1A4E)
                : const Color(0xFF87CEEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accentColor, width: 3),
          ),
          child: Center(
            child: Text(
              isNight ? '🌙' : '☀️',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
      // Bookshelf
      Positioned(
        left: size.width * 0.05,
        top: size.height * 0.12,
        child: Container(
          width: size.width * 0.2,
          height: size.height * 0.18,
          decoration: BoxDecoration(
            color: furnitureColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text('📚', style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
      // Sofa
      Positioned(
        left: size.width * 0.5,
        top: size.height * 0.35,
        child: Container(
          width: size.width * 0.35,
          height: size.height * 0.1,
          decoration: BoxDecoration(
            color: furnitureColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // Rug
      Positioned(
        left: size.width * 0.25,
        top: size.height * 0.55,
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.12,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      // Food bowl
      Positioned(
        left: size.width * 0.05,
        top: size.height * 0.7,
        child: const Text('🍽️', style: TextStyle(fontSize: 24)),
      ),
    ];
  }

  Widget _buildPositionedCat(BuildContext context, Cat cat, Size screenSize) {
    final slot = roomSlotMap[cat.roomSlot ?? cat.personalityData?.preferredRoomSlots.first ?? 'rug'];
    final xPos = (slot?.xPercent ?? 0.5) * screenSize.width - 30;
    final yPos = (slot?.yPercent ?? 0.5) * (screenSize.height * 0.8);

    return Positioned(
      left: xPos,
      top: yPos,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tappedCatId = _tappedCatId == cat.id ? null : cat.id;
          });
          // Show bottom sheet with quick actions
          _showCatActions(context, cat);
        },
        child: CatSprite.fromCat(
          breed: cat.breed,
          stage: cat.computedStage,
          mood: cat.computedMood,
          size: 56,
        ),
      ),
    );
  }

  List<Widget> _buildSpeechBubble(
      BuildContext context, List<Cat> cats) {
    final cat = cats.where((c) => c.id == _tappedCatId).firstOrNull;
    if (cat == null) return [];

    final slot = roomSlotMap[cat.roomSlot ?? cat.personalityData?.preferredRoomSlots.first ?? 'rug'];
    final size = MediaQuery.of(context).size;
    final xPos = (slot?.xPercent ?? 0.5) * size.width - 40;
    final yPos = (slot?.yPercent ?? 0.5) * (size.height * 0.8) - 60;

    return [
      Positioned(
        left: xPos.clamp(8.0, size.width - 130),
        top: yPos.clamp(8.0, size.height - 80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cat.name,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                cat.speechMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  void _showCatActions(BuildContext context, Cat cat) {
    final habits = ref.read(habitsProvider).value ?? [];
    final habit =
        habits.where((h) => h.id == cat.boundHabitId).firstOrNull;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cat info header
            Row(
              children: [
                CatSprite.fromCat(
                  breed: cat.breed,
                  stage: cat.computedStage,
                  mood: cat.computedMood,
                  size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.name,
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${cat.breedData?.name ?? cat.breed}  •  ${cat.stageName}',
                        style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                              color: Theme.of(ctx)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      if (habit != null)
                        Text(
                          '${habit.icon} ${habit.name}',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            if (habit != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushNamed(
                      AppRouter.focusSetup,
                      arguments: habit.id,
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Focus'),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushNamed(
                    AppRouter.catDetail,
                    arguments: cat.id,
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('View Details'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
