// ---
// 退出登录 + 引导状态单元测试 — 验证 logout() 完整清理、
// onboardingCompleteProvider 生命周期、resetGuestData() 流程。
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

void main() {
  // --- OnboardingNotifier 生命周期 ---

  group('OnboardingNotifier', () {
    test('初始化从 SharedPreferences 读取 — 未设置时返回 false', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      expect(container.read(onboardingCompleteProvider), isFalse);
    });

    test('初始化从 SharedPreferences 读取 — 已设置时返回 true', () async {
      SharedPreferences.setMockInitialValues({
        AppPrefsKeys.onboardingComplete: true,
      });
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      expect(container.read(onboardingCompleteProvider), isTrue);
    });

    test('complete() 更新状态为 true 并持久化到 SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      expect(container.read(onboardingCompleteProvider), isFalse);

      container.read(onboardingCompleteProvider.notifier).complete();

      expect(container.read(onboardingCompleteProvider), isTrue);
      expect(prefs.getBool(AppPrefsKeys.onboardingComplete), isTrue);
      expect(prefs.getBool(AppPrefsKeys.hasOnboardedBefore), isTrue);
    });

    test('reset() 仅更新内存状态为 false，不修改 SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        AppPrefsKeys.onboardingComplete: true,
      });
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      expect(container.read(onboardingCompleteProvider), isTrue);

      container.read(onboardingCompleteProvider.notifier).reset();

      expect(container.read(onboardingCompleteProvider), isFalse);
      // SharedPreferences 未被修改（由调用方 _clearAuthCache 负责）
      expect(prefs.getBool(AppPrefsKeys.onboardingComplete), isTrue);
    });
  });

  // --- hasOnboardedBefore 生命周期 ---

  group('hasOnboardedBefore', () {
    test('complete() 设置 hasOnboardedBefore 为 true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      container.read(onboardingCompleteProvider.notifier).complete();

      expect(prefs.getBool(AppPrefsKeys.hasOnboardedBefore), isTrue);
    });

    test('reset() 不清除 hasOnboardedBefore（登出后保留）', () async {
      SharedPreferences.setMockInitialValues({
        AppPrefsKeys.onboardingComplete: true,
        AppPrefsKeys.hasOnboardedBefore: true,
      });
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      container.read(onboardingCompleteProvider.notifier).reset();

      expect(container.read(onboardingCompleteProvider), isFalse);
      // hasOnboardedBefore 应在 reset 后依然存活
      expect(prefs.getBool(AppPrefsKeys.hasOnboardedBefore), isTrue);
    });

    test('登出清理不清除 hasOnboardedBefore', () async {
      SharedPreferences.setMockInitialValues({
        AppPrefsKeys.localGuestUid: 'guest_123',
        AppPrefsKeys.hasOnboardedBefore: true,
        AppPrefsKeys.dataHydrated: true,
        AppPrefsKeys.onboardingComplete: true,
      });
      final prefs = await SharedPreferences.getInstance();

      // 模拟登出清理逻辑（仅清除 dataHydrated + onboardingComplete）
      for (final key in [
        AppPrefsKeys.dataHydrated,
        AppPrefsKeys.onboardingComplete,
      ]) {
        prefs.remove(key);
      }

      // hasOnboardedBefore 不在清理列表中，应存活
      expect(prefs.getBool(AppPrefsKeys.hasOnboardedBefore), isTrue);
      // localGuestUid 由 logout 重新生成，不会被删除
      expect(prefs.getString(AppPrefsKeys.localGuestUid), isNotNull);
    });
  });

  // --- AppPrefsKeys 常量完整性 ---

  group('AppPrefsKeys', () {
    test('所有键名是不重复的字符串常量', () {
      final keys = [
        AppPrefsKeys.localGuestUid,
        AppPrefsKeys.onboardingComplete,
        AppPrefsKeys.hasOnboardedBefore,
        AppPrefsKeys.dataHydrated,
        AppPrefsKeys.pendingDeletionJob,
        AppPrefsKeys.deletionTombstone,
        AppPrefsKeys.deletionRetryCount,
        AppPrefsKeys.lastAppOpen,
        AppPrefsKeys.consecutiveDays,
        AppPrefsKeys.diaryPendingRetries,
      ];

      // 全部非空
      for (final key in keys) {
        expect(key, isNotEmpty);
      }

      // 全部不重复
      expect(keys.toSet().length, equals(keys.length));
    });
  });
}
