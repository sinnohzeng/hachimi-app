import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 监听当前用户的 avatarId。
///
/// SSOT 分离：displayName 由 [authStateProvider]（Firebase Auth）提供，
/// avatarId 由 Firestore `users/{uid}.avatarId` 提供。
final avatarIdProvider = StreamProvider<String?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(firestoreServiceProvider).watchAvatarId(uid);
});
