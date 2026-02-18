# Firebase 远程配置（Remote Config）

> Remote Config（远程配置）支持在无需发版的情况下动态更新参数和进行 A/B 实验。代码 SSOT 为 `lib/services/remote_config_service.dart`。

---

## 参数列表

所有参数均在 `RemoteConfigService._defaults` 中初始化了代码内默认值。首次成功拉取后，远程配置的值会覆盖这些默认值。

### `xp_multiplier`（XP 倍率）

- **类型**：Double（浮点数）
- **默认值**：`1.0`
- **代码 getter**：`remoteConfigService.xpMultiplier`
- **说明**：乘以每次专注会话结束时获得的总 XP。用于季节性活动（如设置为 `2.0` 举办「双倍 XP 周末」）。
- **A/B 用途**：测试 `1.0` 对比 `1.5` 对会话完成率的影响。

### `notification_copy_variant`（通知文案变体）

- **类型**：String（字符串）
- **默认值**：`"A"`
- **代码 getter**：`remoteConfigService.notificationCopyVariant`
- **说明**：控制每日提醒通知使用的文案变体。
  - `"A"` —— 「{猫咪名字} 在等你！是时候专注 {习惯名称} 了。」
  - `"B"` —— 「{习惯名称} 第 {n} 天打卡，坚持住！」
- **A/B 用途**：对比两种变体的通知打开率。

### `mood_threshold_lonely_days`（孤独阈值天数）

- **类型**：Int（整数）
- **默认值**：`3`
- **代码 getter**：`remoteConfigService.moodThresholdLonelyDays`
- **说明**：无会话天数超过该值时，猫咪心情从 `neutral`（平静）过渡到 `lonely`（孤独）。控制情感紧迫感。
  - 数值低（如 `2`）：紧迫感更强，可能较为烦人
  - 数值高（如 `5`）：紧迫感较低，可能削弱召回效果
- **A/B 用途**：测试 `3` 对比 `5` 对间隔后会话返回率的影响。

### `default_focus_duration`（默认专注时长）

- **类型**：Int（整数）
- **默认值**：`25`
- **代码 getter**：`remoteConfigService.defaultFocusDuration`
- **说明**：专注设置界面预选的计时器时长（分钟）。当 `goalMinutes` 未设置时作为兜底值。
- **A/B 用途**：测试 `25` 对比 `15` 对会话启动率的影响（较短的会话可能降低启动门槛）。

---

## 代码用法

```dart
// 在可访问 RemoteConfigService 的组件或服务中：
final multiplier = remoteConfigService.xpMultiplier;              // double
final copyVariant = remoteConfigService.notificationCopyVariant;  // String
final lonelyDays = remoteConfigService.moodThresholdLonelyDays;   // int
final defaultDuration = remoteConfigService.defaultFocusDuration; // int
```

服务在应用启动时拉取并激活远程值。生产环境最小拉取间隔为 1 小时（Firebase 默认 12 小时）。

---

## Firebase 控制台配置

### 1. 发布默认参数

前往 **Firebase 控制台 → Remote Config → 创建配置**，添加以下参数及其默认值：

| 参数名称 | 类型 | 默认值 |
|---------|------|--------|
| `xp_multiplier` | 数字 | `1` |
| `notification_copy_variant` | 字符串 | `A` |
| `mood_threshold_lonely_days` | 数字 | `3` |
| `default_focus_duration` | 数字 | `25` |

点击 **发布更改**。

### 2. 创建 A/B 实验

前往 **Firebase 控制台 → A/B 测试 → 创建实验 → Remote Config**。

示例：测试通知文案

1. **实验名称**：「通知文案变体测试」
2. **目标受众**：所有用户（或特定受众）
3. **流量分配**：50% / 50%
4. **对照组**：`notification_copy_variant = "A"`
5. **实验组**：`notification_copy_variant = "B"`
6. **目标指标**：`notification_opened` 事件数量
7. **持续时间**：至少 14 天

---

## 拉取与激活行为

应用在 `main.dart` 的 `runApp()` 之前调用 `RemoteConfigService.initialize()`，该方法：

1. 设置代码内默认值（确保无网络时应用正常工作）
2. 从 Firebase 拉取最新配置（带最小 1 小时缓存）
3. 激活已拉取的配置（使 getter 可读取到最新值）

开发期间可将拉取间隔设为 0 以即时生效：

```dart
// 仅限开发环境 —— 正式版本请删除
await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(minutes: 1),
  minimumFetchInterval: Duration.zero,
));
```
