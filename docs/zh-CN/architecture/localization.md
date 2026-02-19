# 本地化（i18n）— SSOT

> **SSOT**：本文档是国际化方案的单一真值来源。所有本地化字符串管理必须遵循本规范。

---

## 概览

Hachimi 使用 Flutter 内置的本地化系统，由 **`flutter_localizations`** 和 **`gen-l10n`**（从 ARB 文件进行编译期代码生成）驱动。该方案提供：

1. **类型安全的字符串访问** —— 生成的 `AppLocalizations` 类具有编译期检查的键
2. **无运行时查找失败** —— 缺失的键在构建时捕获，而非运行时
3. **ARB 格式** —— 行业标准的 Application Resource Bundle 格式，兼容翻译工具
4. **最少样板代码** —— `gen-l10n` 自动生成所有 Dart 代码

---

## 支持的语言区域

| 语言区域 | 语言 | ARB 文件 | 状态 |
|---------|------|----------|------|
| `en` | 英语 | `lib/l10n/app_en.arb` | 主要（真值来源） |
| `zh` | 中文（简体） | `lib/l10n/app_zh.arb` | 翻译 |

英语是 **模板语言区域** —— 所有新键必须先添加到 `app_en.arb`，然后翻译到 `app_zh.arb`。

---

## 配置

### `l10n.yaml`（项目根目录）

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: true
nullable-getter: false
```

### `pubspec.yaml` 依赖

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

### `MaterialApp` 集成

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

---

## ARB 文件格式

ARB 文件是带有元数据注解的 JSON。每个用户可见的字符串是一个键值对，可选地跟随一个 `@key` 元数据条目。

### 示例：`app_en.arb`

```json
{
  "@@locale": "en",
  "homeTabToday": "Today",
  "@homeTabToday": {
    "description": "Label for the Today tab on the home screen"
  },
  "homeTabCats": "Cats",
  "@homeTabCats": {
    "description": "Label for the Cats tab on the home screen"
  },
  "adoptionConfirmButton": "Adopt {catName}",
  "@adoptionConfirmButton": {
    "description": "Button label to confirm cat adoption",
    "placeholders": {
      "catName": {
        "type": "String",
        "example": "Mochi"
      }
    }
  },
  "timerMinutesRemaining": "{minutes, plural, =1{1 minute remaining} other{{minutes} minutes remaining}}",
  "@timerMinutesRemaining": {
    "description": "Timer countdown display",
    "placeholders": {
      "minutes": {
        "type": "int"
      }
    }
  }
}
```

---

## 键命名规范

键遵循 **`screenName` + 用途** 的 camelCase 模式。

| 前缀 | 界面 / 上下文 | 示例键 |
|------|-------------|--------|
| `home` | HomeScreen | `homeTabToday`、`homeTabCats`、`homeTabStats`、`homeTabProfile` |
| `adoption` | AdoptionFlowScreen | `adoptionStepName`、`adoptionConfirmButton`、`adoptionRefresh` |
| `timer` | TimerScreen | `timerStart`、`timerPause`、`timerMinutesRemaining` |
| `catDetail` | CatDetailScreen | `catDetailStageLabel`、`catDetailMoodHappy` |
| `catRoom` | CatRoomScreen | `catRoomTitle`、`catRoomEmpty` |
| `profile` | ProfileScreen | `profileLogout`、`profileCatAlbum` |
| `stats` | StatsScreen | `statsTotalHours`、`statsBestStreak` |
| `login` | LoginScreen | `loginEmailLabel`、`loginGoogleButton` |
| `onboarding` | OnboardingScreen | `onboardingWelcome`、`onboardingGetStarted` |
| `common` | 跨界面共享 | `commonCancel`、`commonSave`、`commonDelete`、`commonError` |
| `checkIn` | CheckInBanner | `checkInBonusEarned`、`checkInPrompt` |
| `accessory` | AccessoryShopSection | `accessoryBuyButton`、`accessoryInsufficientCoins` |

**规则：**
- 始终使用 camelCase
- 以界面或组件上下文为前缀
- 使用描述性后缀（`Button`、`Label`、`Title`、`Message`、`Error`）
- 复数形式在 ARB 值中使用 ICU MessageFormat 语法

---

## 添加新字符串

添加任何新的用户可见文本时，请遵循以下工作流：

1. **将键添加到 `app_en.arb`**，包含英文字符串值和包含 `description` 的 `@key` 元数据条目。

2. **将翻译添加到 `app_zh.arb`**，使用相同的键和中文翻译。

3. **运行代码生成**：
   ```bash
   flutter gen-l10n
   ```
   这将使用新键重新生成 `AppLocalizations`。（此命令也会在 `flutter build` 和 `flutter run` 时自动运行。）

4. **在代码中使用**：
   ```dart
   // 在任何有 BuildContext 的组件中：
   final l10n = AppLocalizations.of(context);
   Text(l10n.homeTabToday)

   // 使用占位符：
   Text(l10n.adoptionConfirmButton(catName))
   ```

5. **绝不在 Screen 或 Widget 文件中硬编码用户可见的字符串。** 路由名、Firestore 字段名和分析事件键等常量不面向用户，无需本地化。

---

## 生成的输出

`gen-l10n` 工具生成：

```
.dart_tool/flutter_gen/gen_l10n/
├── app_localizations.dart          # 抽象 AppLocalizations 类
├── app_localizations_en.dart       # 英文实现
└── app_localizations_zh.dart       # 中文实现
```

这些文件在编译时生成，**不应** 提交到版本控制。它们通过 `.gitignore` 中的 `.dart_tool/` 模式被排除。

---

## 需要本地化的内容

| 类别 | 是否本地化？ | 示例 |
|------|-----------|------|
| 界面标题和标签 | 是 | "Today"、"Cats"、"Profile" |
| 按钮文字 | 是 | "Start"、"Cancel"、"Adopt Mochi" |
| 错误消息 | 是 | "Network error. Please try again." |
| 猫咪对话气泡文案 | 是 | "Purrrfect day for a nap..." |
| 性格显示名称 | 是 | "Lazy"、"Curious"、"Playful" |
| 阶段显示名称 | 是 | "Kitten"、"Adolescent"、"Adult"、"Senior" |
| 心情显示名称 | 是 | "Happy"、"Neutral"、"Lonely"、"Missing" |
| Firestore 字段名 | 否 | `"boundHabitId"`、`"totalMinutes"` |
| 分析事件名 | 否 | `"focus_session_complete"` |
| 路由路径 | 否 | `"/cat-detail"`、`"/timer"` |
| 日志消息（调试） | 否 | `"Firestore batch committed"` |

---

## 测试

验证本地化完整性：

1. **编译检查**：如果 `app_zh.arb` 缺少 `app_en.arb` 中存在的键，`flutter gen-l10n` 将失败。
2. **视觉检查**：使用 `--locale zh` 运行应用，验证中文字符串正确渲染。
3. **占位符检查**：确保所有占位符（`{catName}`、`{minutes}`）在两个 ARB 文件中都存在。
