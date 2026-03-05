import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';

/// Firebase 用户资料后端实现。
class FirebaseUserProfileBackend implements UserProfileBackend {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  String get id => 'firebase';

  @override
  Future<void> ensureProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    await _db.runTransaction((txn) async {
      final doc = await txn.get(docRef);
      if (doc.exists) return;
      txn.set(docRef, {
        'email': email,
        'displayName': displayName ?? email.split('@').first,
        'coins': 0,
        'inventory': <String>[],
        'lastCheckInDate': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> syncFields({
    required String uid,
    String? displayName,
    String? avatarId,
    String? currentTitle,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (avatarId != null) updates['avatarId'] = avatarId;
    if (currentTitle != null) updates['currentTitle'] = currentTitle;
    if (updates.isEmpty) return;

    try {
      await _db.collection('users').doc(uid).update(updates);
    } catch (e, stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'FirebaseUserProfileBackend',
        operation: 'syncFields',
      );
    }
  }
}
