import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/avatar_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_provider.dart';

/// 头像选择底部弹窗（MD3 Modal Bottom Sheet）。
///
/// 点击头像即保存并关闭弹窗。选中项有 primary 描边 + check 叠加。
Future<void> showAvatarPickerSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => _AvatarPickerContent(parentRef: ref),
  );
}

class _AvatarPickerContent extends StatelessWidget {
  final WidgetRef parentRef;

  const _AvatarPickerContent({required this.parentRef});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentId = parentRef.read(avatarIdProvider).value;
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingHBase,
            child: Text(
              l10n.profileChooseAvatar,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Padding(
            padding: AppSpacing.paddingHBase,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: AvatarConstants.avatars.length,
              itemBuilder: (ctx, index) {
                final avatar = AvatarConstants.avatars[index];
                final isSelected = avatar.id == currentId;

                return _AvatarTile(
                  avatar: avatar,
                  isSelected: isSelected,
                  onTap: () => _selectAvatar(context, avatar.id),
                  colorScheme: colorScheme,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Future<void> _selectAvatar(BuildContext context, String avatarId) async {
    HapticFeedback.selectionClick();

    final uid = parentRef.read(currentUidProvider);
    if (uid == null) return;

    await parentRef
        .read(firestoreServiceProvider)
        .updateUserProfile(uid: uid, avatarId: avatarId);

    if (context.mounted) Navigator.of(context).pop();
  }
}

class _AvatarTile extends StatelessWidget {
  final AvatarOption avatar;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _AvatarTile({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? colorScheme.primaryContainer
              : avatar.color.withValues(alpha: 0.15),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              avatar.icon,
              size: 28,
              color: isSelected ? colorScheme.primary : avatar.color,
            ),
            if (isSelected)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
