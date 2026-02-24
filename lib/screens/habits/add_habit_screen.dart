import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hoursController = TextEditingController(text: '100');
  bool _isLoading = false;

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

      final habitId = const Uuid().v4();
      final habit = Habit(
        id: habitId,
        name: name,
        targetHours: targetHours,
        createdAt: DateTime.now(),
      );
      await ref.read(localHabitRepositoryProvider).create(uid, habit);

      // Log analytics event
      await ref
          .read(analyticsServiceProvider)
          .logHabitCreated(habitName: name, targetHours: targetHours);

      if (mounted) Navigator.of(context).pop();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addHabitTitle)),
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
                decoration: InputDecoration(
                  labelText: context.l10n.addHabitQuestName,
                  hintText: context.l10n.addHabitQuestHint,
                  prefixIcon: const Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.addHabitValidName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Target hours
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.l10n.addHabitTargetHours,
                  hintText: context.l10n.addHabitTargetHint,
                  prefixIcon: const Icon(Icons.flag),
                  suffixText: context.l10n.addHabitHoursSuffix,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.addHabitValidTarget;
                  }
                  final hours = int.tryParse(value.trim());
                  if (hours == null || hours <= 0) {
                    return context.l10n.addHabitValidNumber;
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
                  label: Text(context.l10n.addHabitCreate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
