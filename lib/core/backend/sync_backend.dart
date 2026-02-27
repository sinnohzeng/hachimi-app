/// 同步后端抽象接口 — 封装云端批量写入语义。
///
/// SyncEngine 构建 [SyncOperation] 列表，后端负责翻译为
/// 平台特定的批量写入（Firestore WriteBatch / CloudBase batch 等）。
abstract class SyncBackend {
  /// 后端标识名。
  String get id;

  /// 一次性数据水化：从云端拉取已有数据到本地。
  Future<HydrationData> hydrate(String uid);

  /// 批量写入同步操作。
  Future<void> writeBatch(String uid, List<SyncOperation> operations);
}

/// 水化数据 — 从云端拉取的全量初始数据。
class HydrationData {
  final List<Map<String, dynamic>> habits;
  final List<Map<String, dynamic>> cats;
  final Map<String, dynamic> userProfile;

  const HydrationData({
    this.habits = const [],
    this.cats = const [],
    this.userProfile = const {},
  });
}

/// 同步操作类型。
enum SyncOpType {
  /// 设置文档（覆盖或创建）。
  set,

  /// 合并设置文档（保留未指定字段）。
  merge,

  /// 更新文档字段。
  update,

  /// 字段原子递增。
  increment,

  /// 数组追加元素。
  arrayAdd,

  /// 数组移除元素。
  arrayRemove,

  /// 设置为服务器时间戳。
  serverTimestamp,
}

/// 统一的同步操作描述 — 屏蔽 FieldValue / WriteBatch 差异。
class SyncOperation {
  /// 操作类型。
  final SyncOpType type;

  /// 集合路径（相对于用户文档）。
  /// 如 'habits'、'cats'、'habits/{habitId}/sessions'。
  final String collection;

  /// 文档 ID。
  final String docId;

  /// 操作数据。
  /// - [set]/[merge]/[update]：字段键值对
  /// - [increment]：{'field': 'fieldName', 'value': delta}
  /// - [arrayAdd]/[arrayRemove]：{'field': 'fieldName', 'value': element}
  /// - [serverTimestamp]：{'field': 'fieldName'}
  final Map<String, dynamic> data;

  const SyncOperation({
    required this.type,
    required this.collection,
    required this.docId,
    required this.data,
  });

  /// 便捷构造 — 设置文档。
  factory SyncOperation.set({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) => SyncOperation(
    type: SyncOpType.set,
    collection: collection,
    docId: docId,
    data: data,
  );

  /// 便捷构造 — 合并更新文档。
  factory SyncOperation.merge({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) => SyncOperation(
    type: SyncOpType.merge,
    collection: collection,
    docId: docId,
    data: data,
  );

  /// 便捷构造 — 更新字段。
  factory SyncOperation.update({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) => SyncOperation(
    type: SyncOpType.update,
    collection: collection,
    docId: docId,
    data: data,
  );

  /// 便捷构造 — 字段原子递增。
  factory SyncOperation.increment({
    required String collection,
    required String docId,
    required String field,
    required num value,
  }) => SyncOperation(
    type: SyncOpType.increment,
    collection: collection,
    docId: docId,
    data: {'field': field, 'value': value},
  );

  /// 便捷构造 — 数组追加。
  factory SyncOperation.arrayAdd({
    required String collection,
    required String docId,
    required String field,
    required dynamic value,
  }) => SyncOperation(
    type: SyncOpType.arrayAdd,
    collection: collection,
    docId: docId,
    data: {'field': field, 'value': value},
  );

  /// 便捷构造 — 数组移除。
  factory SyncOperation.arrayRemove({
    required String collection,
    required String docId,
    required String field,
    required dynamic value,
  }) => SyncOperation(
    type: SyncOpType.arrayRemove,
    collection: collection,
    docId: docId,
    data: {'field': field, 'value': value},
  );
}
