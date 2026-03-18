// ---
// 测试数据库辅助 — sqflite 在纯单元测试中不可用（需要 Android/iOS 平台）。
//
// 本文件提供说明和替代方案：
// - 需要真实 SQLite 的测试使用 integration_test/
// - 纯单元测试使用 Fake 实现（见 fakes.dart）
//
// 如未来引入 sqflite_common_ffi，可在此处添加 in-memory DB helper：
//   import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//   Future<Database> openTestDatabase() async { ... }
// ---

// 占位：sqflite_common_ffi 不在 dev_dependencies 中，
// 跳过 in-memory SQLite 测试，改用 Fake 进行服务层测试。
