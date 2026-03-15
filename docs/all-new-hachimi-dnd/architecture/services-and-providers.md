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
| `primary_cat_service.dart` | 主哈基米 CRUD、SQLite + 远端双写 |
| `completion_rate_service.dart` | 计算习惯完成率（DEX 属性依赖）|
| `streak_service.dart` | 计算连续打卡天数（CON 属性依赖）|
| `coverage_service.dart` | 计算 30 天覆盖率（WIS 属性依赖）|

`CompletionRateService`、`StreakService`、`CoverageService` 为纯计算服务，无副作用，依赖本地数据，不发网络请求。

### 类型约定

> **`Cat` 类型统一**：在所有 DnD 文档和代码中，伙伴猫统一使用现有 `Cat` 模型（`lib/models/cat.dart`）。
> 不定义独立的 `CompanionCat` 类。文档中出现的"伙伴猫"、"CompanionCat"均指 `Cat` 类型。
> 在函数签名中使用 `List<Cat> companions` 而非 `List<CompanionCat>`。

### 1.1 DiceEngineService 完整接口

```dart
/// 骰子引擎服务 — 纯函数式，无持久状态。
/// 所有随机性通过 injectable [Random] 注入，确保可测试。
class DiceEngineService {
  final LedgerService _ledger;
  final CoinService _coins;
  final Random _rng;  // 生产环境用 Random.secure()，测试用 Random(seed)

  DiceEngineService({
    required LedgerService ledger,
    required CoinService coins,
    Random? rng,
  }) : _ledger = ledger,
       _coins = coins,
       _rng = rng ?? Random.secure();

  /// 专注完成后获得骰子。溢出时调用 CoinService.addCoins()。
  Future<void> earnDice({
    required String uid,
    required String catId,
    required String habitId,
    required int focusMinutes,
  });

  /// 执行检定：消耗 PendingDice → 生成 DiceResult → 发放星尘。
  /// 原子操作：删除骰子 + 写入结果 + 更新星尘在同一 SQLite 事务中。
  Future<DiceResult> performCheck({
    required PendingDice dice,
    required SceneEvent event,
    required PrimaryCat primary,
    required List<Cat> companions,        // 使用 Cat 类型，非 CompanionCat
    required int userLevel,
    required String habitCategory,
    required int currentStreak,
    int conditionMod = 0,                 // 状态效果修正（Phase 2 默认 0）
    int environmentMod = 0,               // 环境效果修正（Phase 2 默认 0）
    int equipmentMod = 0,                 // 装备属性加成（Phase 2 默认 0）
  });

  /// 一键全投：快速消化所有 PendingDice。
  Future<List<DiceResult>> rollAll({
    required String uid,
    required SceneEvent event,
    required PrimaryCat primary,
    required List<Cat> companions,        // 使用 Cat 类型，非 CompanionCat
    required int userLevel,
    required int currentStreak,
  });

  /// 监听待投骰子变化（SQLite stream）。
  Stream<List<PendingDice>> watchPendingDice(String uid);
}
```

**Random 策略**：
- 生产环境：`Random.secure()`（密码学安全随机数）
- 单元测试：`Random(42)`（固定种子，可复现）
- 保底状态（PityState）为实例内部状态，App 重启重置

**与 CoinService 的组合**：
- 溢出时调用 `_coins.addCoins(uid, 5)` 而非内联金币逻辑
- 确保 CoinService 的 Ledger 记录和 materialized_state 更新被正确触发

## 2. 新增 Provider（5 个）

| 文件 | 类型签名 | 说明 |
|------|---------|------|
| `primary_cat_provider.dart` | `StreamProvider<PrimaryCat?>` | 主哈基米实时状态 |
| `adventure_provider.dart` | `StreamProvider<AdventureProgress?>` | 当前活跃冒险 |
| `dice_provider.dart` | `StreamProvider<List<PendingDice>>` | 待投骰子列表 |
| `class_provider.dart` | `FutureProvider<String?>` | 当前职业 |
| `party_provider.dart` | `StreamProvider<Party?>` | 当前队伍 |

### 2.1 userLevelProvider 完整定义

```dart
/// 冒险等级 Provider — 从物化 XP 查 20 级阈值表返回当前等级。
final userLevelProvider = Provider<int>((ref) {
  final adventureXP = ref.watch(materializedStateProvider)
      .whenData((state) => state['adventure_xp'] as int? ?? 0)
      .valueOrNull ?? 0;
  return _xpToLevel(adventureXP);
});

/// XP → 等级查表（20 级阈值表，见 spec/05 §9.2）
int _xpToLevel(int xp) {
  const thresholds = [0, 120, 360, 720, 1080, 1200, 1800, 2700, 3600, 4800,
                      5400, 6000, 7200, 8400, 9600, 12000, 15000, 18000, 24000, 36000];
  for (var i = thresholds.length - 1; i >= 0; i--) {
    if (xp >= thresholds[i]) return i + 1;
  }
  return 1;
}
```

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

参考实现：`lib/services/firebase/firebase_adventure_backend.dart`（Firebase 版）。其他后端实现遵循相同的 `AdventureBackend` 接口契约。

### 3.1 BackendRegistry 集成

`AdventureBackend` 必须注册到现有的 `BackendRegistry`（`lib/core/backend/backend_registry.dart`）：

```dart
// 在 BackendRegistry 构造函数中新增：
class BackendRegistry {
  // ...现有字段...
  final AdventureBackend adventureBackend;  // 新增

  BackendRegistry({
    // ...现有参数...
    required this.adventureBackend,  // 新增
  });
}
```

**Firebase 实现注册**（在 `main.dart` 或 DI 初始化处）：

```dart
BackendRegistry(
  // ...现有 backend 实例...
  adventureBackend: FirebaseAdventureBackend(firestore),  // 新增
);
```

**AccountDeletionService 级联**：`account_deletion_service.dart` 的删除编排中必须新增：
1. 通过 `AdventureBackend` 清理远端主哈基米数据
2. 通过 `AdventureBackend` 清理远端待投骰子
3. 通过 `AdventureBackend` 清理远端检定结果
4. 通过 `AdventureBackend` 清理远端冒险进度
5. 通过 `AdventureBackend` 清理远端队伍数据
6. 清空本地 DnD 相关 SQLite 表

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
| `PrimaryCatService` | Singleton | 无缓存 | CRUD 操作，SQLite + 远端双写 |
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
│   AdventureBackend (远端抽象)                              │
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
