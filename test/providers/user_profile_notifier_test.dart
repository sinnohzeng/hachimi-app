// ---
// 📘 文件说明：
// UserProfileNotifier 单元测试 — 验证资料操作编排的 null 安全和 Provider 接线。
//
// 🧩 文件结构：
// - Firebase Core mock 初始化；
// - Provider 注册与实例化验证；
// - updateDisplayName uid=null 安全返回；
// - updateAvatar uid=null 安全返回；
//
// 🕒 创建时间：2026-02-27
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/user_profile_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  group('UserProfileNotifier — provider registration', () {
    test('userProfileServiceProvider creates UserProfileService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(userProfileServiceProvider);
      expect(service, isA<UserProfileService>());
    });
  });

  group('UserProfileNotifier — null uid safety', () {
    test('updateDisplayName returns safely when uid is null', () async {
      final container = ProviderContainer(
        overrides: [currentUidProvider.overrideWithValue(null)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userProfileNotifierProvider.notifier);
      // 应静默返回，不抛异常
      await notifier.updateDisplayName('test name');
    });

    test('updateAvatar returns safely when uid is null', () async {
      final container = ProviderContainer(
        overrides: [currentUidProvider.overrideWithValue(null)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(userProfileNotifierProvider.notifier);
      // 应静默返回，不抛异常
      await notifier.updateAvatar('avatar_01');
    });
  });
}
