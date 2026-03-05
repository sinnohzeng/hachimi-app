import 'package:cloud_functions/cloud_functions.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';

/// Firebase Functions 账户生命周期实现。
class FirebaseAccountLifecycleBackend implements AccountLifecycleBackend {
  final FirebaseFunctions _functions;

  FirebaseAccountLifecycleBackend({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  @override
  String get id => 'firebase';

  @override
  Future<void> deleteAccountHard({required OperationContext context}) async {
    await _functions.httpsCallable('deleteAccountV1').call(context.toJson());
  }

  @override
  Future<void> wipeUserData({required OperationContext context}) async {
    await _functions.httpsCallable('wipeUserDataV1').call(context.toJson());
  }
}
