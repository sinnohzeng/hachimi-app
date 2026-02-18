# Firestore 安全规则

> 项目根目录下的 `firestore.rules` 文件是已部署规则的权威来源。本文档解释规则设计及每项决策的依据。

---

## 设计原则

1. **用户隔离**：每位用户只能访问自己 `users/{uid}` 路径下的文档。
2. **无跨用户读取**：不存在共享集合、排行榜或社交功能，因此无需跨用户访问。
3. **默认拒绝**：末尾的通配符规则（`match /{document=**}`）明确拒绝所有未被上方规则覆盖的路径访问，防止新增集合时出现未预期的访问漏洞。
4. **必须认证**：所有 `allow` 语句均要求 `request.auth != null`，不允许匿名访问。

---

## 当前规则

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // 用户只能访问自己的文档和子集合
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // habits 子集合
      match /habits/{habitId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;

        // habits 下的专注会话
        match /sessions/{sessionId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }

      // cats 子集合
      match /cats/{catId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // checkIns 子集合（按日期分区）
      match /checkIns/{date} {
        allow read, write: if request.auth != null && request.auth.uid == userId;

        // 打卡日期下的条目
        match /entries/{entryId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }

    // 拒绝所有其他访问
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 规则设计依据

### 为什么每个子集合都要重复认证检查？

Firestore 规则 **不会继承**。`match /users/{userId}` 规则不会自动覆盖 `match /users/{userId}/habits/{habitId}`。每个子集合必须有独立的规则。重复的 `request.auth.uid == userId` 检查是子集合隔离的正确写法。

### 为什么使用 `allow read, write` 而非细粒度的 `create/update/delete`？

目前所有操作（增、查、改、删）均由认证后的所有者完成。细粒度规则会增加复杂性，但在无共享资源和角色权限的情况下不带来实质安全提升。若未来引入社交功能或管理员访问，可在此处引入更精细的规则。

### 为什么通配拒绝规则放在最后？

Firestore 应用 **最具体的匹配规则**。通配符 `/{document=**}` 是最不具体的规则，仅适用于上方未被覆盖的路径。放在末尾是惯例；Firestore 无论顺序均能正确求值，但末尾放置让读者更易理解意图。

---

## 部署规则

项目根目录的 `firestore.rules` 文件是已部署版本。始终先编辑该文件，再执行部署：

```bash
# 仅部署 Firestore 规则（安全，不影响 Functions 或其他服务）
firebase deploy --only firestore:rules
```

在 Firebase 控制台 → Firestore → 「规则」标签页验证部署结果。

---

## 测试规则

使用 Firebase 控制台中的 Firestore 规则模拟器，或 Firebase 模拟器套件：

```bash
# 加载规则后启动模拟器
firebase emulators:start --only firestore
```

**推荐测试用例：**

- 已认证用户读取自己的习惯：应 **允许**
- 已认证用户读取他人的习惯：应 **拒绝**
- 未认证用户读取任意文档：应 **拒绝**
- 已认证用户写入 cats 子集合：应 **允许**
- 已认证用户写入他人的 cats 子集合：应 **拒绝**
