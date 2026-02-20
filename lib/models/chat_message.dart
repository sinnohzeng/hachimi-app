// ---
// 📘 文件说明：
// ChatMessage 数据模型 — 猫猫聊天消息，存储于本地 SQLite。
//
// 🕒 创建时间：2026-02-19
// ---

/// 聊天消息角色。
enum ChatRole {
  user,
  assistant;

  String get value {
    switch (this) {
      case ChatRole.user:
        return 'user';
      case ChatRole.assistant:
        return 'assistant';
    }
  }

  static ChatRole fromString(String s) {
    switch (s) {
      case 'user':
        return ChatRole.user;
      case 'assistant':
        return ChatRole.assistant;
      default:
        return ChatRole.assistant;
    }
  }
}

/// 猫猫聊天消息。
class ChatMessage {
  final String id;
  final String catId;
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.catId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      catId: map['cat_id'] as String,
      role: ChatRole.fromString(map['role'] as String),
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cat_id': catId,
      'role': role.value,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
