# Service、Provider 与 Backend 接口

> SSOT for v2.0 DnD 新增的业务逻辑层和状态管理层。
> **Status:** Draft
> **Evidence:** `lib/services/`、`lib/providers/`、`lib/core/backend/`
> **Related:** [data-model.md](data-model.md) · [spec/](../spec/)
> **Changelog:**
> - 2026-03-15 — 审计修复：PrimaryCatService/AdventureService 完整接口、SceneDifficultyUnlock CRUD、专注完成增强链、Provider 矩阵、缓存机制、成就调用点
> - 2026-03-15 — 初版

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

> **API 映射**：文档中所有"加金币"操作统一使用现有 `CoinService.addCoins(uid, amount)`。
> spec 中出现的 `addGold()` 或 `_economyService.addGold()` 均应理解为 `CoinService.addCoins()`。

### 1.2 PrimaryCatService 完整接口

```dart
/// 主哈基米 CRUD 服务 — SQLite 优先 + 远端异步同步。
class PrimaryCatService {
  final LocalDatabaseService _db;
  final LedgerService _ledger;

  PrimaryCatService({required LocalDatabaseService db, required LedgerService ledger})
    : _db = db, _ledger = ledger;

  /// 创建主哈基米（Onboarding 完成时调用）。原子操作：插入 + Ledger 记录。
  Future<PrimaryCat> create({
    required String uid,
    required String name,
    required String archetype,
    required CatAppearance appearance,
  });

  /// 读取当前用户的主哈基米。返回 null 表示未创建（未完成 Onboarding）。
  Future<PrimaryCat?> load(String uid);

  /// 监听主哈基米变化（SQLite stream）。
  Stream<PrimaryCat?> watch(String uid);

  /// 更新外观（花费 500 金币，由调用方校验余额）。
  Future<void> updateAppearance(String uid, CatAppearance newAppearance);

  /// 选择职业（Lv 3+，仅可选一次直到 Lv 10 解锁多职兼修）。
  Future<void> selectClass(String uid, String playerClass);

  /// 选择 ASI 或专长（Lv 4/8/12/16/19 各一次）。
  Future<void> selectASI(String uid, int level, String choice);

  /// 选择专长。
  Future<void> selectFeat(String uid, String featName);

  /// 选择背景（Phase 3，Onboarding 新增步骤时使用）。
  Future<void> selectBackground(String uid, String background);
}
```

### 1.3 AdventureService 完整接口

```dart
/// 冒险生命周期管理服务。
class AdventureService {
  final LocalDatabaseService _db;
  final LedgerService _ledger;
  final Random _eventRng;  // 事件池 Random（独立实例，不与 DiceEngine 共享）

  AdventureService({
    required LocalDatabaseService db,
    required LedgerService ledger,
    Random? eventRng,
  }) : _db = db, _ledger = ledger, _eventRng = eventRng ?? Random.secure();

  /// 开始新冒险。
  /// 同场景卡的旧活跃冒险 → paused；不同场景卡的旧活跃冒险 → abandoned。
  /// 原子操作：状态更新旧冒险 + 创建新冒险 + 冻结 Party 快照。
  Future<AdventureProgress> startAdventure({
    required String uid,
    required SceneCard sceneCard,
    required String difficulty,
    required Party party,
    required String deviceId,
  });

  /// 推进到下一个事件。写入 DiceResult ID 到 eventResultIds。
  Future<void> advanceEvent(String uid, String adventureId, String diceResultId, bool success);

  /// 暂停当前冒险。
  Future<void> pauseAdventure(String uid, String adventureId);

  /// 完成冒险。计算星级 + 发放奖励。
  Future<void> completeAdventure(String uid, String adventureId);

  /// 放弃冒险（永久，不可恢复）。
  Future<void> abandonAdventure(String uid, String adventureId);

  /// 监听当前活跃冒险。
  Stream<AdventureProgress?> watchActiveAdventure(String uid);

  /// 记录冒险 XP 增量（专注完成后调用）。
  /// formula: focusMinutes × (1 + classBonus + secondaryClassBonus × 0.5)
  Future<void> recordAdventureXP({
    required String uid,
    required int focusMinutes,
    required String? habitCategory,
    required String? playerClass,
    required String? secondaryClass,
  });
}
```

## 2. 新增 Provider（5 个）

| 文件 | 类型签名 | 说明 |
|------|---------|------|
| `primary_cat_provider.dart` | `StreamProvider<PrimaryCat?>` | 主哈基米实时状态 |
| `adventure_provider.dart` | `StreamProvider<AdventureProgress?>` | 当前活跃冒险 |
| `dice_provider.dart` | `StreamProvider<List<PendingDice>>` | 待投骰子列表 |
| `class_provider.dart` | `FutureProvider<String?>` | 当前职业 |
| `party_provider.dart` | `StreamProvider<Party?>` | 当前队伍 |
| `rest_state_provider.dart` | `Provider<RestState>` | 休息状态（完全派生，无 Service 依赖） |

> **Party 写入归属**：`local_party` 表由 `AdventureService.startAdventure()` 在冒险开始时冻结快照写入。
> `partyProvider` 仅读取 SQLite，不涉及独立的 PartyService。用户在 `/party-select` 页面的选择通过
> `AdventureService` 的参数传入，不直接写表。

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

  // 场景难度解锁
  Future<void> saveSceneDifficultyUnlock(String uid, SceneDifficultyUnlock unlock);
  Future<SceneDifficultyUnlock?> loadSceneDifficultyUnlock(String uid, String sceneCardId);
  Future<List<SceneDifficultyUnlock>> loadAllSceneDifficultyUnlocks(String uid);
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

**执行顺序**：
1. [现有] 远端清理：用户配置、习惯、会话、成就
2. [新增] 远端 DnD 清理：primaryCat → pendingDice → diceResults → adventureProgress → party → sceneDifficultyUnlock
3. [现有] 远端账户删除
4. [新增] 本地 DnD SQLite 清理：DROP 所有 DnD 表数据
5. [现有] 本地 SQLite 清理
6. [现有] Firebase Auth 删除

> **失败处理**：步骤 2 失败时标记为 partial deletion，下次登录时重试（与现有模式一致）。

## 4. 文件变更清单

### 新增文件（~28 个）

| 目录 | 文件 |
|------|------|
| `lib/models/` | `primary_cat.dart`、`pending_dice.dart`、`dice_result.dart`、`adventure_progress.dart`、`scene_card.dart`、`starter_archetype.dart` |
| `lib/core/constants/` | `adventure_constants.dart`、`class_constants.dart`、`adventure_dialogues/`（15 个场景卡文件，见下方拆分说明）、`primary_cat_dialogues.dart`、`dice_result_dialogues.dart`、`party_dialogues.dart` |
| `lib/providers/` | `primary_cat_provider.dart`、`adventure_provider.dart`、`dice_provider.dart`、`class_provider.dart`、`party_provider.dart` |
| `lib/services/` | `dice_engine_service.dart`、`adventure_service.dart`、`primary_cat_service.dart`、`completion_rate_service.dart`、`streak_service.dart`、`coverage_service.dart` |
| `lib/screens/` | `starter_selection/`、`adventure_journal/`、`dice_roll/`、`party_select/`、`class_select/`、`scene_select/` |
| `lib/core/backend/` | `adventure_backend.dart` |
| `lib/services/firebase/` | `firebase_adventure_backend.dart` |

#### 叙事文本拆分：adventure_dialogues/ 目录

```
lib/core/constants/
├── adventure_dialogues/
│   ├── cat_town_market.dart        // 市集广场（~60 行）
│   ├── cat_town_blacksmith.dart    // 铁匠铺
│   ├── cat_town_library.dart       // 图书馆
│   ├── cat_town_tavern.dart        // 酒馆
│   ├── cat_town_herb.dart          // 草药园
│   ├── forest_ancient_trail.dart   // 古树小径
│   ├── forest_elven_spring.dart    // 精灵泉
│   ├── forest_mushroom_cave.dart   // 蘑菇洞
│   ├── forest_watchtower.dart      // 瞭望塔
│   ├── forest_moonlight_lake.dart  // 月光湖
│   ├── ruins_statue_puzzle.dart    // 石像谜题
│   ├── ruins_floating_bridge.dart  // 浮空桥
│   ├── ruins_treasure_room.dart    // 宝藏室
│   ├── ruins_mural_hall.dart       // 壁画厅
│   └── ruins_sealed_gate.dart      // 封印之门
```

> **拆分理由**：每张场景卡 8-10 个事件 × 3 段文本（prompt + success + fail）× 双语 ≈ 48-60 行/卡。按区域合并为 3 文件会导致单文件 240-300 行（可接受但不优雅）。按场景卡拆分为 15 文件，每文件约 50-80 行，更符合单一职责原则和 800 行红线要求。

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

**缓存机制详解**：
- **缓存 key**：`uid`（全局，非 per-cat）
- **缓存存储**：Service 实例内部 `_cachedResult` + `_cachedAt` 时间戳
- **过期策略**：`DateTime.now() - _cachedAt > Duration(minutes: 5)` 时重新查询
- **主动失效**：当 `LedgerChange.type == ActionType.focusComplete`（对应现有 `'focus_complete'` 值，见 `lib/models/ledger_action.dart`）或 `isGlobalRefresh` 时，调用 `ref.invalidate(completionRateServiceProvider)` 等清除缓存

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

// 属性计算 Provider — FutureProvider，异步查询后并行计算 6 维属性。
final primaryCatAbilitiesProvider = FutureProvider<Map<String, int>>((ref) async {
  final primaryCat = await ref.watch(primaryCatProvider.future);
  if (primaryCat == null) return {};

  final uid = primaryCat.userId;

  // 从现有 Provider 获取已有数据（同步）
  final cats = ref.watch(catsProvider).valueOrNull ?? [];
  final activeCats = cats.where((c) => c.state != 'retired' && c.state != 'deleted').toList();
  final habits = ref.watch(habitsProvider).valueOrNull ?? [];
  final activeHabits = habits.where((h) => h.state != 'graduated' && h.state != 'archived').toList();

  // 同步计算可直接获取的输入
  final allCatsTotalMinutes = activeCats.fold<int>(0, (sum, c) => sum + c.totalMinutes);
  final activeHabitCount = activeHabits.length;
  final avgGoalMinutes = activeHabits.isEmpty
      ? 25.0
      : activeHabits.map((h) => h.goalMinutes ?? 25).reduce((a, b) => a + b) / activeHabits.length;

  // 异步 Service 查询（3 个并行执行）
  final completionRate = ref.read(completionRateServiceProvider);
  final streak = ref.read(streakServiceProvider);
  final coverage = ref.read(coverageServiceProvider);

  final [overallRate, longestEverStreak, thirtyDayCoverage] = await Future.wait([
    completionRate.averageForAllCats(uid, lastN: 30),
    streak.longestEverAcrossAllHabits(uid),
    coverage.coverageLastThirtyDays(uid),
  ]);

  // 心情均值（同步计算）
  final averageCatMood = activeCats.isEmpty
      ? 1.0
      : activeCats.map((c) => _moodToValue(c.computedMood)).reduce((a, b) => a + b) / activeCats.length;

  // 使用 spec/01 中的公式计算各属性
  return _computeAbilities(
    primaryCat,
    allCatsTotalMinutes: allCatsTotalMinutes,
    overallCompletionRate: overallRate as double,
    longestEverStreak: (longestEverStreak as int),
    activeHabitCount: activeHabitCount,
    avgGoalMinutes: avgGoalMinutes,
    thirtyDayCoverage: thirtyDayCoverage as double,
    averageCatMood: averageCatMood,
  );
});
```

> **性能优化（D37）**：`primaryCatAbilitiesProvider` 使用 `ref.watch(primaryCatProvider.future)` 监听完整 PrimaryCat 对象。若未来外观变更触发频繁重算，应改用 `ref.watch(primaryCatProvider.select((p) => p?.archetype))` 等仅监听属性相关字段。当前阶段外观变更频率极低（500 金币/次），暂不优化。

### 5.4 事务性操作

以下操作必须在 SQLite 事务中原子执行：

| 操作 | 涉及表 | 说明 |
|------|--------|------|
| 骰子溢出 | `local_pending_dice` + `materialized_state` | COUNT ≥ 20 → 不插入 + 加金币 |
| 冒险切换 | `local_adventure_progress` + `local_party` | 暂停旧冒险 + 更新队伍 + 创建新冒险 |
| 检定结算 | `local_pending_dice` + `local_dice_results` + `materialized_state` | 删骰子 + 写结果 + 加星尘 |
| 主哈基米创建 | `local_primary_cat` + `action_ledger` | 插入 + 记录 Ledger |

### 5.5 专注完成增强调用链

专注会话完成后的完整调用顺序（在现有 `FocusTimerService.onSessionComplete` 中增强）：

```
onFocusComplete(uid, habitId, focusMinutes)
  ├─ 1. [现有] XpService.addXP(focusMinutes)              → materialized_state['xp']
  ├─ 2. [新增] AdventureService.recordAdventureXP(...)     → materialized_state['adventure_xp']
  ├─ 3. [新增] DiceEngineService.earnDice(...)             → local_pending_dice / 溢出 → CoinService.addCoins
  └─ 4. [现有] CoinService.addCoins(uid, focusMinutes × 2) → materialized_state['gold']
```

> **事务边界**：步骤 1-4 各自独立写 Ledger，不在同一 SQLite 事务中。任一步骤失败不影响其他步骤。
> 这与现有的 Ledger 重试机制一致——每个 LedgerAction 独立重试。

### 5.6 LedgerChange → Provider 失效矩阵

| ActionType | 触发 Provider 失效 |
|------------|-------------------|
| `primary_cat_create`, `primary_cat_update` | `primaryCatProvider`, `primaryCatAbilitiesProvider` |
| `dice_earned`, `dice_consumed`, `dice_overflow` | `diceProvider` |
| `adventure_start`, `adventure_event`, `adventure_complete`, `adventure_pause`, `adventure_abandon` | `adventureProvider` |
| `party_update` | `partyProvider` |
| `class_select` | `classProvider`, `primaryCatProvider` |
| `scene_difficulty_unlock` | （无专用 Provider，按需读取） |
| `stardust_earn`, `stardust_spend` | `materializedStateProvider` |
| `adventure_xp_earn` | `userLevelProvider`（通过 `materializedStateProvider`） |
| `habit_category_update` | `habitsProvider` |

> **全局刷新**：`LedgerChange.isGlobalRefresh == true` 时，所有 DnD Provider 重读本地数据（与现有模式一致）。

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

### 6.3 成就触发调用点

| 方法 | 调用位置 |
|------|---------|
| `evaluateDiceResult(result)` | `DiceEngineService.performCheck()` 写入 DiceResult 后 |
| `evaluateAdventureComplete(progress)` | `AdventureService.completeAdventure()` 状态更新后 |
| `evaluateClassSelect(className)` | `PrimaryCatService.selectClass()` 写入后 |
| `evaluateCatEvolution(cat, newStage)` | 现有 Cat 进化逻辑中 |
| `evaluatePartyFormed(party)` | `AdventureService.startAdventure()` Party 冻结后 |
| `evaluateDiscoveryEvent()` | 被动感知发现触发后 |
| `evaluateFeatSelected(featName)` | `PrimaryCatService.selectFeat()` 写入后 |
