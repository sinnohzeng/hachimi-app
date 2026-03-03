// ---
// 📘 文件说明：
// UserProfileService 单元测试 — 验证委托 UserProfileBackend 的正确性。
//
// 🧩 文件结构：
// - FakeUserProfileBackend mock 实现；
// - ensureProfile 参数传递验证；
// - syncToFirestore 委托验证；
//
// 🕒 创建时间：2026-02-27
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/backend/user_profile_backend.dart';
import 'package:hachimi_app/services/user_profile_service.dart';

/// 简单的 fake backend，记录调用参数用于验证。
class FakeUserProfileBackend implements UserProfileBackend {
  @override
  String get id => 'fake';

  Map<String, dynamic>? lastCreateCall;
  Map<String, dynamic>? lastSyncCall;

  @override
  Future<void> ensureProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    lastCreateCall = {'uid': uid, 'email': email, 'displayName': displayName};
  }

  @override
  Future<void> syncFields({
    required String uid,
    String? displayName,
    String? avatarId,
    String? currentTitle,
  }) async {
    lastSyncCall = {
      'uid': uid,
      'displayName': displayName,
      'avatarId': avatarId,
      'currentTitle': currentTitle,
    };
  }
}

void main() {
  late FakeUserProfileBackend fakeBackend;
  late UserProfileService service;

  setUp(() {
    fakeBackend = FakeUserProfileBackend();
    service = UserProfileService(backend: fakeBackend);
  });

  group('UserProfileService — instantiation', () {
    test('can be instantiated', () {
      expect(service, isA<UserProfileService>());
    });
  });

  group('UserProfileService.ensureProfile', () {
    test('delegates to backend with correct params', () async {
      await service.ensureProfile(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Alice',
      );
      expect(fakeBackend.lastCreateCall, {
        'uid': 'u1',
        'email': 'a@b.com',
        'displayName': 'Alice',
      });
    });

    test('passes null displayName when not provided', () async {
      await service.ensureProfile(uid: 'u2', email: 'b@c.com');
      expect(fakeBackend.lastCreateCall?['displayName'], isNull);
    });
  });

  group('UserProfileService.syncToFirestore', () {
    test('delegates to backend syncFields', () async {
      await service.syncToFirestore(
        uid: 'u1',
        displayName: 'Bob',
        avatarId: 'av_01',
        currentTitle: 'title_01',
      );
      expect(fakeBackend.lastSyncCall, {
        'uid': 'u1',
        'displayName': 'Bob',
        'avatarId': 'av_01',
        'currentTitle': 'title_01',
      });
    });

    test('passes null fields when not provided', () async {
      await service.syncToFirestore(uid: 'u1');
      expect(fakeBackend.lastSyncCall?['displayName'], isNull);
      expect(fakeBackend.lastSyncCall?['avatarId'], isNull);
      expect(fakeBackend.lastSyncCall?['currentTitle'], isNull);
    });
  });
}
