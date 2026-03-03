import 'package:cloud_functions/cloud_functions.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';

/// Firebase Functions 账户生命周期实现。
class FirebaseAccountLifecycleBackend implements AccountLifecycleBackend {
  final FirebaseFunctions _functions;

  FirebaseAccountLifecycleBackend({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  @override
  String get id => 'firebase';

  @override
  Future<void> deleteAccountHard() async {
    await _functions.httpsCallable('deleteAccountV1').call();
  }

  @override
  Future<void> wipeUserData() async {
    await _functions.httpsCallable('wipeUserDataV1').call();
  }
}
