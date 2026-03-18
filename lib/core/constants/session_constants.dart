/// 会话状态 — 替代散落在代码中的魔法字符串。
enum SessionStatus {
  completed('completed'),
  abandoned('abandoned'),
  interrupted('interrupted');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromValue(String value) {
    return SessionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown SessionStatus: $value'),
    );
  }
}
