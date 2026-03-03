# 开发/调试环境

## 前置
- Flutter 3.41.x
- Dart 3.11.x
- Node.js 20+（用于 `functions/`）
- Firebase CLI

## 首次启动
```bash
flutter pub get
cd functions && npm install && cd ..
```

## 本地验证命令
```bash
dart analyze lib test
flutter test --exclude-tags golden
dart run tool/quality_gate.dart
cd functions && npm test
```

## 账户生命周期调试清单
### 访客升级
- 验证 linkMode 下 Google 登录。
- 验证 linkMode 下邮箱“登录已有账号/注册新账号”两条路径。
- 当本地与云端都有数据时应出现存档冲突弹窗。
- 验证保留云端/保留本地两条分支均可成功收敛。

### 删号
- 在线：本地立即清空，并执行 `deleteAccountV1`。
- 离线：本地立即清空，并写入 `pending_deletion_job`。
- 联网后：启动期/轮询自动重试，直至云端硬删完成。

## 常见问题
- 删号 `permission-denied`：检查 callable 登录态与规则部署。
- pending 任务不清除：检查 Functions 是否部署且用户仍保留登录态。
- 未触发冲突弹窗：检查本地与云端快照是否都为非空。
