# Service、Provider 与 Backend 接口

> SSOT for v2.0 DnD 新增的业务逻辑层和状态管理层。
> **Status:** Draft
> **Evidence:** `lib/services/`、`lib/providers/`、`lib/core/backend/`
> **Related:** [data-model.md](data-model.md) · [spec/](../spec/)
> **Changelog:** 2026-03-15 — 初版

---

## 1. 新增 Service（6 个）

| 文件 | 职责 |
|------|------|
| `dice_engine_service.dart` | 伪随机 d20 检定引擎：保底机制、优势/劣势、奖励计算 |
| `adventure_service.dart` | 冒险生命周期管理：开始/推进/暂停/完成、星级评价 |
| `primary_cat_service.dart` | 主哈基米 CRUD、SQLite + Firestore 双写 |
| `completion_rate_service.dart` | 计算习惯完成率（DEX 属性依赖）|
| `streak_service.dart` | 计算连续打卡天数（CON 属性依赖）|
| `coverage_service.dart` | 计算 30 天覆盖率（WIS 属性依赖）|

`CompletionRateService`、`StreakService`、`CoverageService` 为纯计算服务，无副作用，依赖本地数据，不发网络请求。

## 2. 新增 Provider（5 个）

| 文件 | 类型签名 | 说明 |
|------|---------|------|
| `primary_cat_provider.dart` | `StreamProvider<PrimaryCat?>` | 主哈基米实时状态 |
| `adventure_provider.dart` | `StreamProvider<AdventureProgress?>` | 当前活跃冒险 |
| `dice_provider.dart` | `StreamProvider<List<PendingDice>>` | 待投骰子列表 |
| `class_provider.dart` | `FutureProvider<String?>` | 当前职业 |
| `party_provider.dart` | `StreamProvider<Party?>` | 当前队伍 |

## 3. Backend 抽象接口

在 `lib/core/backend/adventure_backend.dart` 中定义：

```dart
abstract class AdventureBackend {
  // 主哈基米
  Future<void> savePrimaryCat(String uid, PrimaryCat cat);
  Future<PrimaryCat?> loadPrimaryCat(String uid);

  // 待投骰子
  Future<void> savePendingDice(String uid, PendingDice dice);
  Future<void> deletePendingDice(String uid, String diceId);
  Future<List<PendingDice>> loadPendingDice(String uid);

  // 检定结果
  Future<void> saveDiceResult(String uid, DiceResult result);
  Future<List<DiceResult>> loadDiceResults(String uid, {int limit = 50});

  // 冒险进度
  Future<void> saveAdventureProgress(String uid, AdventureProgress progress);
  Future<AdventureProgress?> loadActiveAdventure(String uid);

  // 队伍
  Future<void> saveParty(String uid, Party party);
  Future<Party?> loadParty(String uid);
}
```

Firebase 实现：`lib/services/firebase/firebase_adventure_backend.dart`

## 4. 文件变更清单

### 新增文件（~28 个）

| 目录 | 文件 |
|------|------|
| `lib/models/` | `primary_cat.dart`、`pending_dice.dart`、`dice_result.dart`、`adventure_progress.dart`、`scene_card.dart`、`starter_archetype.dart` |
| `lib/core/constants/` | `adventure_constants.dart`、`class_constants.dart`、`adventure_dialogues_town.dart`、`adventure_dialogues_forest.dart`、`adventure_dialogues_ruins.dart`、`primary_cat_dialogues.dart`、`dice_result_dialogues.dart`、`party_dialogues.dart` |
| `lib/providers/` | `primary_cat_provider.dart`、`adventure_provider.dart`、`dice_provider.dart`、`class_provider.dart`、`party_provider.dart` |
| `lib/services/` | `dice_engine_service.dart`、`adventure_service.dart`、`primary_cat_service.dart`、`completion_rate_service.dart`、`streak_service.dart`、`coverage_service.dart` |
| `lib/screens/` | `starter_selection/`、`adventure_journal/`、`dice_roll/`、`party_select/`、`class_select/`、`scene_select/` |
| `lib/core/backend/` | `adventure_backend.dart` |
| `lib/services/firebase/` | `firebase_adventure_backend.dart` |

### 修改文件（~12 个）

| 文件 | 变更 |
|------|------|
| `home_screen.dart` | Tab 3 标签改名 |
| `cat_room_screen.dart` | 酒馆视觉升级 |
| `onboarding_screen.dart` | 新增御三家步骤 |
| `focus_complete_screen.dart` | 骰子获取提示 |
| `cat_detail_screen.dart` | 属性面板 + 冒险区块 |
| `app_router.dart` | 6 条新路由 |
| `habit.dart` | category 字段 |
| `cat_provider.dart` | 属性 extension |
| `local_database_service.dart` | 新表 DDL |
| `app_en.arb` (+ 14 语言) | UI 文案 |
| `firestore.rules` | 新集合规则 |
| `pubspec.yaml` | 版本号 |

---

## 5. 依赖注入与调用链

### 5.1 Service 生命周期

所有新 Service 遵循现有项目的 Provider 模式：

| Service | 生命周期 | 缓存策略 | 说明 |
|---------|---------|---------|------|
| `DiceEngineService` | Singleton | 无缓存（每次调用实时计算） | 纯函数式，无状态 |
| `AdventureService` | Singleton | 无缓存 | 管理冒险生命周期，操作 SQLite |
| `PrimaryCatService` | Singleton | 无缓存 | CRUD 操作，SQLite + Firestore 双写 |
| `CompletionRateService` | Singleton | **缓存 5 分钟** | SQL 聚合查询较重，短时缓存 |
| `StreakService` | Singleton | **缓存 5 分钟** | 同上 |
| `CoverageService` | Singleton | **缓存 5 分钟** | 同上 |

### 5.2 Provider → Service 调用链

```
┌─────────────────────────────────────────────────────────┐
│ UI Layer (Screens/Widgets)                               │
│   ref.watch(primaryCatProvider)                          │
│   ref.watch(diceProvider)                                │
│   ref.watch(adventureProvider)                           │
└───────────────┬─────────────────────────────────────────┘
                │ ref.watch / ref.read
┌───────────────▼─────────────────────────────────────────┐
│ Provider Layer                                           │
│   primaryCatProvider ──→ PrimaryCatService                │
│   │                      + CompletionRateService          │
│   │                      + StreakService                   │
│   │                      + CoverageService                │
│   diceProvider ──→ DiceEngineService                      │
│   adventureProvider ──→ AdventureService                  │
│   partyProvider ──→ (直接读 SQLite，无独立 Service)        │
│   classProvider ──→ (从 PrimaryCat.playerClass 派生)      │
└───────────────┬─────────────────────────────────────────┘
                │ 调用
┌───────────────▼─────────────────────────────────────────┐
│ Service Layer                                            │
│   各 Service 通过构造函数注入 LocalDatabaseService        │
│   不直接持有 Provider reference                           │
│   不持有 BuildContext                                    │
└───────────────┬─────────────────────────────────────────┘
                │ 读写
┌───────────────▼─────────────────────────────────────────┐
│ Data Layer                                               │
│   LocalDatabaseService (SQLite)                          │
│   AdventureBackend (Firestore 抽象)                       │
└─────────────────────────────────────────────────────────┘
```

### 5.3 Riverpod Provider 定义模式

```dart
// 遵循现有代码模式：Service 通过 ref.read 获取
final completionRateServiceProvider = Provider<CompletionRateService>((ref) {
  return CompletionRateService(ref.read(localDatabaseServiceProvider));
});

// 属性计算 Provider 使用 FutureProvider（因为需要异步 SQL 查询）
final primaryCatAbilitiesProvider = FutureProvider<Map<String, int>>((ref) async {
  final primaryCat = await ref.watch(primaryCatProvider.future);
  if (primaryCat == null) return {};

  final completionRate = ref.read(completionRateServiceProvider);
  final streak = ref.read(streakServiceProvider);
  final coverage = ref.read(coverageServiceProvider);

  // 聚合计算 6 维属性
  return computePrimaryCatAbilities(primaryCat, completionRate, streak, coverage);
});
```

### 5.4 事务性操作

以下操作必须在 SQLite 事务中原子执行：

| 操作 | 涉及表 | 说明 |
|------|--------|------|
| 骰子溢出 | `local_pending_dice` + `materialized_state` | COUNT ≥ 20 → 不插入 + 加金币 |
| 冒险切换 | `local_adventure_progress` + `local_party` | 暂停旧冒险 + 更新队伍 + 创建新冒险 |
| 检定结算 | `local_pending_dice` + `local_dice_results` + `materialized_state` | 删骰子 + 写结果 + 加星尘 |
| 主哈基米创建 | `local_primary_cat` + `action_ledger` | 插入 + 记录 Ledger |

---

## 6. DnD 成就系统扩展

### 6.1 新增成就触发器

现有 `AchievementEvaluator` 需要新增以下 DnD 相关评估方法：

| 成就 | 触发条件 | 奖励 |
|------|---------|------|
| 初次冒险 | 首次完成 1 个冒险场景 | 100 🪙 |
| 骰子新手 | 首次投掷骰子 | 50 🪙 |
| 大成功！ | 首次掷出 nat 20 | 100 🪙 + 15 ⭐ |
| 厄运终结者 | 累计 10 次 nat 1 | 200 🪙（化悲为喜） |
| 三星冒险家 | 首次获得 ★★★ 完美评价 | 150 🪙 |
| 猫咪小镇通关 | 完成所有 5 张猫咪小镇场景卡 | 300 🪙 |
| 迷雾森林通关 | 完成所有 5 张迷雾森林场景卡 | 500 🪙 |
| 远古遗迹通关 | 完成所有 5 张远古遗迹场景卡 | 800 🪙 |
| 全区域三星 | 所有 15 张场景卡均获得 ★★★ | 传奇配件 |
| 职业大师 | 选择职业 | 100 🪙 |
| 多面手 | 解锁多职兼修（Lv 10） | 200 🪙 |
| 进化！ | 猫咪首次进化（任意猫） | 100 🪙 |
| 成年猫 | 任意猫达到成年阶段 | 200 🪙 |
| 满级冒险家 | 冒险等级达到 Lv 20 | 1000 🪙 + 传奇头冠 |
| 组队出发 | 首次组建 3 猫队伍（主+2 伙伴） | 100 🪙 |
| 发现者 | 首次触发被动感知发现事件 | 50 🪙 |
| 连续签到 7 天 | 连续 7 天每日签到 | 100 🪙 |
| 连续签到 30 天 | 连续 30 天每日签到 | 500 🪙 |
| 专长选择 | 首次选择专长（Lv 4） | 100 🪙 |
| 传说猎人 | 完成任意 Legendary 难度场景 | 500 🪙 |

### 6.2 扩展方式

```dart
// 在现有 AchievementEvaluator 中新增方法
class AchievementEvaluator {
  // 现有方法...

  // DnD 新增
  Future<void> evaluateDiceResult(DiceResult result);
  Future<void> evaluateAdventureComplete(AdventureProgress progress);
  Future<void> evaluateClassSelect(String className);
  Future<void> evaluateCatEvolution(Cat cat, String newStage);
  Future<void> evaluatePartyFormed(Party party);
  Future<void> evaluateDiscoveryEvent();
  Future<void> evaluateFeatSelected(String featName);
}
```
