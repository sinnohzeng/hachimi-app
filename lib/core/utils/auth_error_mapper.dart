import 'package:firebase_auth/firebase_auth.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';

/// 将 Firebase Auth 异常映射为用户可读的本地化错误信息。
///
/// 输入任意 Object，输出对应的 L10N 字符串。
/// 未知错误码统一返回 [S.authErrorGeneric]。
String mapAuthError(Object error, S l10n) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'email-already-in-use' => l10n.authErrorEmailInUse,
      'wrong-password' || 'invalid-credential' => l10n.authErrorWrongPassword,
      'user-not-found' => l10n.authErrorUserNotFound,
      'too-many-requests' => l10n.authErrorTooManyRequests,
      'network-request-failed' => l10n.authErrorNetwork,
      'admin-restricted-operation' => l10n.authErrorAdminRestricted,
      'credential-already-in-use' => l10n.authErrorEmailInUse,
      'weak-password' => l10n.authErrorWeakPassword,
      _ => l10n.authErrorGeneric,
    };
  }
  return l10n.authErrorGeneric;
}
