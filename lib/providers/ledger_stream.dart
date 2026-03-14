import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 台账驱动的响应式流 — 替代 async* + await for 模式。
///
/// Riverpod 3.x 中 async* 生成器在 provider 失活时与内部订阅暂停计数
/// 冲突（element.dart:1086 断言），导致无限重建。此函数使用显式
/// StreamController + ref.onDispose 实现确定性资源回收。
Stream<T> ledgerDrivenStream<T>({
  required Ref ref,
  required LedgerService ledger,
  required bool Function(LedgerChange) filter,
  required Future<T> Function() read,
}) {
  final controller = StreamController<T>();

  read().then(controller.add, onError: controller.addError);

  final sub = ledger.changes.listen((change) {
    if (controller.isClosed) return;
    if (filter(change)) {
      read().then(controller.add, onError: controller.addError);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
}
