// ---
// 共享 Firebase Core mock 初始化 — 提取自各测试文件中重复的 setUpAll 模式。
//
// 用法：在 setUpAll 中调用 initFirebaseMocks()。
// ---

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';

/// 初始化 Firebase Core mock，使依赖 Firebase.initializeApp 的服务可在测试中构造。
Future<void> initFirebaseMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
}
