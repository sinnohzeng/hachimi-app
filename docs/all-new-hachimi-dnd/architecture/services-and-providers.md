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
