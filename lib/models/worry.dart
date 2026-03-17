import 'package:cloud_firestore/cloud_firestore.dart';

/// 烦恼状态枚举。
enum WorryStatus {
  ongoing('ongoing'),
  resolved('resolved'),
  disappeared('disappeared');

  const WorryStatus(this.value);
  final String value;

  static WorryStatus fromValue(String value) {
    return WorryStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown WorryStatus: $value'),
    );
  }
}

/// 烦恼记录 — 用户外化的焦虑或烦恼。
///
/// 对应 SQLite 表 `local_worries`，
/// Firestore 路径 `users/{uid}/worries/{worryId}`。
///
/// 核心设计：写下烦恼本身就能减轻认知负荷（Pennebaker 研究），
/// 用三态追踪结果（进行中 / 已解决 / 自然消失）。
class Worry {
  final String id;
  final String description;
  final String? solution;
  final WorryStatus status;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Worry({
    required this.id,
    required this.description,
    this.solution,
    this.status = WorryStatus.ongoing,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 是否已终结（已解决或自然消失）。
  bool get isSettled =>
      status == WorryStatus.resolved || status == WorryStatus.disappeared;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'description': description,
      'solution': solution,
      'status': status.value,
      'resolved_at': resolvedAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Worry.fromSqlite(Map<String, dynamic> map) {
    return Worry(
      id: map['id'] as String,
      description: map['description'] as String,
      solution: map['solution'] as String?,
      status: WorryStatus.fromValue(map['status'] as String? ?? 'ongoing'),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolved_at'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'solution': solution,
      'status': status.value,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Worry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Worry(
      id: doc.id,
      description: data['description'] as String? ?? '',
      solution: data['solution'] as String?,
      status: WorryStatus.fromValue(data['status'] as String? ?? 'ongoing'),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  Worry copyWith({
    String? id,
    String? description,
    String? solution,
    bool clearSolution = false,
    WorryStatus? status,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Worry(
      id: id ?? this.id,
      description: description ?? this.description,
      solution: clearSolution ? null : (solution ?? this.solution),
      status: status ?? this.status,
      resolvedAt: clearResolvedAt ? null : (resolvedAt ?? this.resolvedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
