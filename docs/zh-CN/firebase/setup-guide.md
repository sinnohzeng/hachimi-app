# Firebase 配置指南

## 1. 必需服务
在 Firebase Console 启用：
- Authentication：Google + 邮箱密码（若使用匿名访客模式则同时启用 Anonymous）
- Firestore
- Cloud Functions（需 Blaze 计费）
- Analytics
- Crashlytics
- Crashlytics 到 Cloud Logging 导出
- Crashlytics 与 Analytics 到 BigQuery 导出

## 2. 本地初始化
```bash
flutter pub get
firebase login
flutterfire configure --project <project-id>
```

## 3. Firestore 规则
部署规则与索引：
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## 4. Cloud Functions 账户生命周期
### 已实现函数
- `deleteAccountV1`
- `wipeUserDataV1`

### 部署
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

### Cloud Functions 账户生命周期
- `deleteAccountV1`：递归删除 `users/{uid}` 并删除 Auth 用户。
- `wipeUserDataV1`：仅递归删除 `users/{uid}`。
- 两个 callable 都要求登录态且具备幂等语义。
- 两个 callable 强制 operation context 字段：
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

## 5. 客户端运行约束
- 客户端删号为离线优先，离线时写入 pending job。
- App 启动时自动重试 pending 删号任务。
- `guest_*` 本地 UID 不触发 Firestore 删除调用。

## 6. 可观测性初始化
```bash
export PROJECT_ID=<your-project-id>
export LOCATION=US
export DATASET=obs
export ANALYTICS_DATASET=analytics_<property_id> # 自动发现失败时显式指定
export TTL_DAYS=90
./scripts/gcp/setup_observability.sh
```

然后在 Cloud Monitoring 中配置通知通道：
- Google Chat（主）
- Email（兜底）

完整操作见 [可观测性运行手册](observability-runbook.md)。
云端凭据与 GitHub Secrets 详见 [凭据与 Secrets 指南](credentials-and-secrets.md)。
