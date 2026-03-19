# Architecture Overview

> SSOT for the runtime architecture after 2026-03 security and observability modernization.

## Core Principles
- Offline-first runtime state: local SQLite + ledger are runtime SSOT.
- Deterministic sync: `SyncEngine` reconciles local actions to Firestore.
- Google-first security: App Check + IAM/ADC + Secret Manager.
- No client-side static AI API keys in release path.

## Stack
| Layer | Technology |
|---|---|
| App | Flutter 3.41.x + Dart 3.11.x |
| State | Riverpod 3.x |
| Local storage | sqflite + SharedPreferences |
| Auth/Data | Firebase Auth + Firestore |
| Server account ops | Firebase Functions callable V2 |
| AI | Firebase AI Logic + Vertex AI |
| Observability | Crashlytics + Cloud Logging + BigQuery + Google Chat/Email |
| Infra control plane | Terraform |

## Layered Design
```text
Screens -> Providers -> Services -> Backend abstractions -> Firebase SDK / Cloud Functions
```

## Account Lifecycle
### Guest upgrade conflict
1. Auth succeeds.
2. Build local snapshot + cloud snapshot.
3. Resolve conflict matrix (`keepLocal` / `keepCloud` / explicit choice).
4. Execute merge via `AccountMergeService`.

### Account deletion (offline-first)
1. Confirm summary + `DELETE` confirmation.
2. `AccountDeletionOrchestrator` cleans local data first.
3. Online path calls `deleteAccountV2`.
4. Offline path queues pending deletion and retries.
5. UI `_executeDelete` uses a `finally` invariant: if `localDataDestroyed && !navigatedAway`, onboarding is unconditionally reset — no error path can leave the app in a half-destroyed state.

## Cloud Functions Contract
Primary callable contract:
- `deleteAccountV2`
- `wipeUserDataV2`

Contract requirements:
- Authenticated user context
- App Check enforced (and token consume for replay protection)
- `OperationContext` payload:
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

Compatibility aliases (`V1`) still exist for safe migration.

## AI and Security Contract
- Client AI provider is `firebase_gemini` only.
- Server triage function is `runAiDebugTriageV2`.
- GitHub issue draft creation uses GitHub App installation token flow.
- GitHub App private key is stored in Secret Manager.

## Observability Contract
- Client errors go through typed `ErrorContext` + `ErrorHandler.record(...)`.
- PII redline: no plaintext UID/email/phone in telemetry.
- Functions structured logs must include:
  - `correlation_id`
  - `uid_hash`
  - `function_name`
  - `latency_ms`
  - `result`
  - `error_code`
- Alert channels are fixed to Google Chat + Email.

## Android Platform Configuration
- **Edge-to-edge**: `enableEdgeToEdge()` in `MainActivity.onCreate()` (SSOT for native window config).
- **Base activity**: `FlutterFragmentActivity` (provides `ComponentActivity` for AndroidX edge-to-edge API).
- **App Check debug token**: Fixed token injected via `local.properties` → Gradle `buildConfigField` → `BuildConfig.APP_CHECK_DEBUG_TOKEN` → `MainActivity.onCreate()` writes to Firebase App Check SharedPreferences before SDK init. Token is never committed to version control (`local.properties` is in `.gitignore`).
- **Themes**: `Theme.Material3.Light.NoActionBar` / `Theme.Material3.Dark.NoActionBar`.
- **System bar styling**: `AppBarTheme.systemOverlayStyle` in `app_theme.dart` (SSOT for Flutter-side system UI).
- **Dependencies**: `activity-ktx:1.10.1`, `material:1.12.0` (explicit in `build.gradle`).
- **Predictive back**: `android:enableOnBackInvokedCallback="true"` in AndroidManifest.

## Dual UI Style Architecture

The app supports two visual modes switchable in Settings:

- **Material 3** — standard M3 rounded components, dynamic color support.
- **Retro Pixel** — Stardew Valley-inspired warm pixel-art aesthetic with `PixelBorderShape` stepped corners on all Material components.

Architecture:
- `ThemeSkin` strategy pattern (`MaterialSkin` / `RetroPixelSkin`) eliminates conditional branching in theme construction.
- `PixelBorderShape extends OutlinedBorder` — injected into `cardTheme.shape`, `dialogTheme.shape`, etc. via theme cascade. One `ShapeBorder` replaces 7+ wrapper components.
- Retro colors map onto `ColorScheme` slots (e.g., `surface` → retro background, `outline` → pixel border) so all existing Material widgets auto-adapt with zero code changes.
- `AppScaffold` wraps `Scaffold` and conditionally overlays `RetroTiledBackground` in retro mode — single integration point for 23+ screens.
- `PixelThemeExtension` carries pixel-only tokens (XP bar, success/warning colors, Silkscreen text styles).
- **Adaptive pixel widgets**: All `lib/widgets/pixel_ui/Pixel*` components check `context.pixel.isRetro` and render standard M3 components (`Container`, `FilledButton.tonal`, `Card`, `LinearProgressIndicator`, `Divider`) in Material mode, or pixel CustomPaint in Retro mode. StatefulWidget components (PixelButton, PixelBadge, PixelCard) use an outer StatelessWidget shell to avoid creating AnimationControllers in MD3 mode.
- Shared MD3 helpers in `lib/widgets/pixel_ui/_md3_helpers.dart` reduce duplication across adaptive widgets.

## LUMI 3-Tab 导航架构

### 战略转型

v3 LUMI（Light Up My Innerverse）将 App 从"猫咪养成习惯应用"转型为"韧性成长手册电子化"。核心变化：

- **3 Tab 替代 4 Tab**：减少选择，降低认知负荷
- **猫咪降级**：从一级 Tab 退到「我的」二级入口
- **习惯降级**：从独立 Tab 退到月度规划子模块

### 导航结构

```
旧（v2.x）：觉知 | 习惯 | 猫咪 | 我的（4 Tab）
新（LUMI）：✦ 今天 | 🗺 旅程 | 👤 我的（3 Tab）
```

| Tab | 屏幕 | 核心功能 |
|-----|------|---------|
| Tab 0: 今天 | `TodayScreen` | QuickLightCard（心情+一句话）+ HabitSnapshot + InspirationCard |
| Tab 1: 旅程 | `JourneyScreen` | SegmentedButton 切换：本周 / 本月 / 年度 / 探索 |
| Tab 2: 我的 | `ProfileScreen` | LUMI 统计 + 猫咪伴侣入口（二级）+ 成长回望 + 设置 |

### 完整屏幕层级

```
App
├── Tab 0: TodayScreen（今天）
│   ├── QuickLightCard（inline 心情+一句话，30 秒完成）
│   ├── HabitSnapshot（今日习惯勾选）
│   ├── InspirationCard（灵感清单轮换提示）
│   └── → DailyLightScreen（展开完整记录）
│
├── Tab 1: JourneyScreen（旅程）
│   ├── [本周] WeeklyPlan + WeeklyReview + WorryJar
│   ├── [本月] MonthlyCalendar + Goals + SmallWin + Habits + MoodTracker + Memory
│   ├── [年度] YearlyMessages + GrowthPlan + AnnualCalendar + Lists + SmallWin100 + Highlights
│   └── [探索] 6 主题月度活动（Day 30 解锁）
│
└── Tab 2: ProfileScreen（我的）
    ├── LumiStatsCard
    ├── CatCompanionCard → CatRoomScreen（二级入口，可选）
    ├── GrowthReview（Day 90 解锁）
    └── Settings
```

## Onboarding 流程

### LUMI Onboarding（4 页）

替换旧猫咪 3 页引导：

| 页 | 内容 | 用户动作 |
|----|------|---------|
| Page 1 | 欢迎 — 品牌 slogan + 星星动画 | 继续 |
| Page 2 | 你是谁 — 名字 + 生日 | 输入 + 下一步 |
| Page 3 | 开始日期 — 日历选择器 | 选择 + 下一步 |
| Page 4 | 使用指南 — LUMI 三件小事 | 开始旅程 |

Onboarding 后直接进入 TodayScreen，**不经过** 猫咪领养。

### 猫咪系统位置

- `_FirstHabitGate` 绕过——不再强制猫咪领养
- 猫咪领养入口在 `ProfileScreen` 的 `CatCompanionCard` 中
- 完全可选，不影响核心 LUMI 体验

## 渐进解锁机制

`FeatureGateProvider` 根据累计记录天数（`totalLightDays`）决定功能可见性：

| 条件 | 解锁内容 |
|------|---------|
| Day 0 | 今天 Tab（每日一点光）|
| Day 1 | 旅程 Tab · 本周视图 |
| Day 3 | 旅程 Tab · 本月视图 |
| Day 14 | 旅程 Tab · 年度视图 |
| Day 30 | 旅程 Tab · 探索（月度活动 6 主题）|
| Day 90 | 成长回望 |

未解锁内容使用温暖提示卡片（非灰色锁图标）。

## SSOT Snapshot
| Concern | SSOT |
|---|---|
| Runtime business state | SQLite (`local_*`, `materialized_state`) |
| Write log | `action_ledger` |
| Cloud persistence | Firestore `users/{uid}` subtree |
| Auth state | `authStateProvider` |
| Navigation architecture | 3-Tab (`TodayScreen`, `JourneyScreen`, `ProfileScreen`) |
| Feature gating | `featureGateProvider` (progressive unlock by `totalLightDays`) |
| Observability schema | `docs/architecture/observability.md` |
| Infra state | `infra/terraform/*` |
