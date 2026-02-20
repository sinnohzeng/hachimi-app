import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hoursController = TextEditingController(text: '100');
  String _selectedIcon = 'code';
  bool _isLoading = false;

  static const Map<String, IconData> iconOptions = {
    'code': Icons.code,
    'book': Icons.book,
    'school': Icons.school,
    'psychology': Icons.psychology,
    'work': Icons.work,
    'fitness_center': Icons.fitness_center,
    'brush': Icons.brush,
    'music_note': Icons.music_note,
    'language': Icons.language,
    'star': Icons.star,
    'rocket_launch': Icons.rocket_launch,
    'check_circle': Icons.check_circle,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _createHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final name = _nameController.text.trim();
      final targetHours = int.parse(_hoursController.text.trim());

      await ref.read(firestoreServiceProvider).createHabit(
            uid: uid,
            name: name,
            icon: _selectedIcon,
            targetHours: targetHours,
          );

      // Log analytics event
      await ref.read(analyticsServiceProvider).logHabitCreated(
            habitName: name,
            targetHours: targetHours,
          );

      if (mounted) Navigator.of(context).pop();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quest'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Quest name',
                  hintText: 'e.g. LeetCode Practice',
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quest name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Icon selector
              Text(
                'Choose an icon',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: iconOptions.entries.map((entry) {
                  final isSelected = _selectedIcon == entry.key;
                  return FilterChip(
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedIcon = entry.key),
                    avatar: Icon(
                      entry.value,
                      size: 20,
                      color: isSelected
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    label: const SizedBox.shrink(),
                    showCheckmark: false,
                    padding: AppSpacing.paddingSm,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Target hours
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target hours',
                  hintText: 'e.g. 100',
                  prefixIcon: Icon(Icons.flag),
                  suffixText: 'hours',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter target hours';
                  }
                  final hours = int.tryParse(value.trim());
                  if (hours == null || hours <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Create button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _createHabit,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Create Quest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
