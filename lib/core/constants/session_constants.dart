/// 会话状态常量 — 替代散落在代码中的魔法字符串。
class SessionStatus {
  SessionStatus._();

  static const String completed = 'completed';
  static const String abandoned = 'abandoned';
  static const String interrupted = 'interrupted';

  static const List<String> values = [completed, abandoned, interrupted];
}
