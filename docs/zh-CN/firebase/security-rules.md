# Firestore 安全规则

## 规则模型
- 默认拒绝（deny-by-default）。
- 用户数据命名空间仅为 `users/{uid}`。
- 仅当 `request.auth.uid == uid` 才允许访问。

## 当前生效子集合
- `habits`
- `habits/{habitId}/sessions`
- `cats`
- `achievements`
- `monthlyCheckIns`

## 已移除 legacy 路径
- `checkIns` 及其 `entries` 子集合已从现行规则中移除。

## 部署
```bash
firebase deploy --only firestore:rules
```

## 校验清单
- 登录用户仅可读写自己的 `users/{uid}` 子树（含字段约束）。
- 用户无法访问其他 UID 命名空间。
- 通过 Cloud Functions 执行删号时不再出现 `permission-denied`。
- `guest_*` 本地删号不触发 Firestore 删除调用。
