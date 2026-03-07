# Firebase 配置指南

## 1. 必需服务
在 Firebase/GCP 中启用：
- Firebase Authentication
- Firestore
- Cloud Functions（需 Blaze）
- Analytics
- Crashlytics
- Firebase App Check
- Firebase AI Logic（Vertex provider）
- Crashlytics 导出到 BigQuery 和 Cloud Logging
- Analytics 导出到 BigQuery

## 2. 本地初始化
```bash
flutter pub get
firebase login
flutterfire configure --project <project-id>
```

## 3. Firestore 规则
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## 4. Cloud Functions 契约
当前 callable 契约：
- `deleteAccountV2`
- `wipeUserDataV2`

兼容别名仍保留：
- `deleteAccountV1`
- `wipeUserDataV1`

### V2 安全行为
- 必须登录态
- 必须携带有效 App Check token
- 消费 App Check token 防重放
- 强制 `OperationContext` 字段：
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

### 部署
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

部署后校验：
```bash
./scripts/check-account-lifecycle-functions.sh <project-id>
```

## 5. App Check 配置
客户端运行时逻辑见 [lib/main.dart](/data/workspace/hachimi-app/lib/main.dart)：
- Android release：Play Integrity
- Debug 构建：Debug provider

你需要在控制台完成：
1. 在 App Check 注册 Android 应用。
2. 生产环境启用 Play Integrity。
3. 为本地开发保留 Debug provider。

## 6. AI 路径（Google 优先）
- 客户端 AI 使用 Firebase AI Logic（`firebase_ai`）+ Vertex。
- Release 流程不再依赖客户端静态 AI key。
- 服务端 AI 分诊通过 IAM/ADC 调用 Vertex。

## 7. 可观测性初始化
首选 Terraform 路径：

```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

运维细节：
- [可观测性运行手册](observability-runbook.md)
- [凭据与 Secrets](credentials-and-secrets.md)
