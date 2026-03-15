# 骰子引擎规格书（Dice Engine Specification）

> SSOT for 骰子获取、累积、伪随机保底、检定公式、奖励分发 的完整行为规格。
> **Status:** Draft
> **Evidence:** `lib/models/pending_dice.dart`（待创建）, `lib/models/dice_result.dart`（待创建）, `lib/services/dice_engine_service.dart`（待创建）, `lib/providers/dice_provider.dart`（待创建）, `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md §4`
> **Related:** [spec/01-primary-cat.md](01-primary-cat.md), [spec/02-attributes.md](02-attributes.md), [spec/04-adventure.md](04-adventure.md), [spec/08-conditions-and-defenses.md](08-conditions-and-defenses.md), [architecture/services-and-providers.md](../architecture/services-and-providers.md)
> **Changelog:**
> - 2026-03-15 — 初版
> - 2026-03-15 — 检定公式扩展：新增 conditionModifier + environmentModifier + equipmentModifier；新增豁免检定变体章节（详见 spec/08）

---

## 1. 设计哲学：骰子是解耦的可累积资源

骰子与冒险场景卡是**解耦的**——骰子在专注完成时获得，但不立即消耗。用户可以在任意时刻进入 Tab 3（冒险者日志）批量投掷。

```
专注完成
    │
    ▼
获得 1 枚 PendingDice（Focus Complete 页面显示 "+1 🎲"，仅此提示）
    │
    ▼
PendingDice 累积于本地 + 远端
    │
    ▼
用户随时在 Tab 3 选择场景事件后投掷
    │
    ▼
消耗 PendingDice → 生成 DiceResult → 发放奖励 → 推进冒险进度
```

**设计意图**：避免打断专注后的心流，让投骰子成为独立的"仪式感"时刻。

---

## 2. 骰子生命周期

```
┌─────────────────────────────────────────────────┐
│  EARN（获得）                                     │
│  专注会话结束 → DiceEngineService.earnDice()      │
│  检查当前 pending 数量                             │
│  ├─ 数量 < 20 → 写入 PendingDice                 │
│  └─ 数量 = 20 → 溢出处理（+5 金币，不写入骰子）   │
└──────────────────────────┬──────────────────────┘
                           │
┌──────────────────────────▼──────────────────────┐
│  ACCUMULATE（累积）                               │
│  SQLite: pending_dice 表（离线优先）              │
│  远端：通过 AdventureBackend 同步                  │
│  上限：20 枚                                      │
└──────────────────────────┬──────────────────────┘
                           │
┌──────────────────────────▼──────────────────────┐
│  ROLL（投掷）                                     │
│  用户在 /dice-roll 选择 SceneEvent               │
│  DiceEngineService.rollDice(pendingDiceId,        │
│    sceneCardId, eventId)                          │
│  → 应用伪随机保底                                 │
│  → 执行检定公式                                   │
│  → 生成 DiceResult                               │
│  → 删除 PendingDice（原子操作）                  │
└──────────────────────────┬──────────────────────┘
                           │
┌──────────────────────────▼──────────────────────┐
│  REWARD（奖励）                                   │
│  根据 DiceResult.outcome 发放星尘                 │
│  附加奖励（配件碎片、故事碎片等）                  │
│  推进 AdventureProgress.currentEventIndex         │
└─────────────────────────────────────────────────┘
```

---

## 3. PendingDice 数据模型

```dart
class PendingDice {
  final String id;          // UUID
  final String uid;         // 所属用户 ID
  final String catId;       // 赚取此骰子的猫咪 ID（用于显示来源猫）
  final String habitId;     // 对应习惯 ID（用于熟练加值判断）
  final int focusMinutes;   // 本次专注时长（分钟，记录用）
  final DateTime earnedAt;  // 获得时间

  // 注意：无 sceneCardId 字段。
  // 骰子在获得时与场景解耦，仅在投掷时绑定到具体 SceneEvent。
}
```

### 3.1 SQLite 表结构

```sql
CREATE TABLE local_pending_dice (
  id            TEXT PRIMARY KEY,
  uid           TEXT NOT NULL,
  cat_id        TEXT NOT NULL,
  habit_id      TEXT NOT NULL,
  focus_minutes INTEGER NOT NULL,
  earned_at     TEXT NOT NULL  -- ISO 8601
);
```

### 3.2 远端存储

通过 `AdventureBackend.savePendingDice()` / `deletePendingDice()` 同步。

远端存储路径：`users/{uid}/pendingDice/{diceId}`（层级结构，具体实现由 Backend 决定）。

---

## 4. 骰子上限与溢出规则

**规则：溢出发生在骰子创建时（专注完成时），而非投掷时。**

```dart
Future<void> earnDice({required String uid, required String catId, ...}) async {
  final count = await _getPendingCount(uid);
  if (count >= 20) {
    // 溢出：不创建骰子，直接发放 5 金币
    await _economyService.addGold(uid, 5);
    await _notifyOverflow(uid);  // 显示 "+5🪙（骰子已满）" 提示
    return;
  }
  await _createPendingDice(uid, catId, habitId, focusMinutes);
}
```

溢出提示文案（i18n key: `dice_overflow_notice`）：「骰子袋已满！额外骰子兑换为 5 🪙」

---

## 5. 伪随机保底系统（Pity System）

保底计数器**存储在内存中**，App 重启后重置。这是可接受的设计取舍（避免数据库负担，偶发重置对体验影响极小）。

> **冒险级重置**：保底计数器在每次 **新冒险开始时** 也重置为 0（`consecutiveFailures = 0, consecutiveNonCrits = 0`）。同一冒险内的检定共享保底状态。

### 5.1 保底规则

| 触发条件 | 效果 |
|---|---|
| 连续 3 次检定失败（含大失败） | 下一次 d20 投掷结果下限 = 10 |
| 连续 8 次未出现大成功（nat 20） | 强制下一次结果为 nat 20 |

### 5.2 计数器定义

```dart
class PityState {
  int consecutiveFailures = 0;   // 连续失败次数
  int consecutiveNonCrits = 0;   // 连续非大成功次数
}
```

### 5.3 应用逻辑

```dart
int applyPity(int rawRoll, PityState pity) {
  // 强制大成功优先
  if (pity.consecutiveNonCrits >= 8) return 20;

  // 失败保底：下限 10
  if (pity.consecutiveFailures >= 3 && rawRoll < 10) return 10;

  return rawRoll;
}

void updatePity(String outcome, PityState pity) {
  if (outcome == 'critical_success') {
    pity.consecutiveNonCrits = 0;
    pity.consecutiveFailures = 0;
  } else if (outcome == 'success') {
    pity.consecutiveNonCrits++;
    pity.consecutiveFailures = 0;
  } else {
    // failure / critical_failure
    pity.consecutiveNonCrits++;
    pity.consecutiveFailures++;
  }
}
```

---

## 6. 检定公式（SRD 5.2.1 标准）

```
最终结果 = d20投掷值（含保底）
         + 属性修正值（主哈基米对应属性）
         + 熟练加值（如适用）
         + 环境加成（如适用）
         + 坚持加成（如适用）
         + conditionModifier（状态效果修正，详见 spec/08 §2.4）
         + environmentModifier（环境效果修正，详见 spec/08 §4.5）
         + equipmentModifier（装备属性加成，详见 spec/09 §4.2）

通过条件：最终结果 ≥ 事件 DC
```

> **豁免检定变体**：当场景事件 `type == 'saving_throw'` 时，熟练加值不再来自技能，而是来自职业豁免熟练表（详见 spec/08 §3.3）。公式其他部分不变。

### 6.1 属性修正值计算（SRD 标准）

```
modifier = floor((score - 10) / 2)
```

示例：属性值 16 → 修正值 +3；属性值 8 → 修正值 −1。

### 6.5 检定公式完整矩阵（Unified Check Formula Matrix）

> **P0 说明**：三份规格书分别定义了熟练加值来源（spec/03 §8 职业-类别匹配、spec/05 §8c 技能子类别、spec/08-bis §3.4 豁免检定熟练），开发时容易混淆是否可叠加。本节作为 **唯一权威定义**，统一检定公式的所有修正项及其叠加规则。

#### 6.5.1 完整检定公式

```
total = d20(after pity)
      + abilityMod
      + proficiencyBonus
      + companionBonus
      + flatBonuses
      + conditionMod
      + environmentMod
      + equipmentMod
```

各项含义：

| 修正项 | 来源 | 说明 |
|--------|------|------|
| `d20(after pity)` | 骰子引擎，经保底系统修正 | 值域 1–20，仅受保底系统影响 |
| `abilityMod` | 主哈基米（PrimaryCat）对应属性 | 始终适用，公式 `floor((score - 10) / 2)` |
| `proficiencyBonus` | **单一来源**，见下方矩阵 | 同一次检定最多应用一套熟练加值来源 |
| `companionBonus` | 在场伙伴猫优势属性匹配检定属性 | +2/匹配伙伴，最多两只伙伴，上限 +4 |
| `flatBonuses` | 心情 +2（伙伴猫 happy）、连击 +1（streak ≥ 7 天） | 始终叠加 |
| `conditionMod` | 当前生效的状态效果（详见 spec/08-bis §2.4） | 与所有其他项叠加 |
| `environmentMod` | 场景环境修正（详见 spec/08-bis §4.5） | 与所有其他项叠加 |
| `equipmentMod` | 已装备道具属性加成（详见 spec/09 §4.2） | 与所有其他项叠加 |

#### 6.5.2 检定类型 → 熟练来源矩阵

**铁律：同一次检定最多应用一套熟练加值来源，绝不叠加。**

| 检定类型 | 熟练来源 | 优先级规则 | 证据 |
|----------|----------|------------|------|
| **普通检定（Ability Check）** | ① 职业-类别匹配（spec/03 §8）；② 技能子类别匹配（spec/05 §8c，Phase 3+ 解锁） | 若 ① 和 ② 同时满足，**职业-类别匹配（①）优先**，忽略 ② | spec/03 §8.2、spec/05 §8c |
| **豁免检定（Saving Throw）** | 职业豁免熟练表（spec/05 Appendix A.1） | **永远不与技能熟练叠加**；仅查职业豁免表 | spec/08-bis §3.4 |

> 判定伪代码：
> ```dart
> int resolveProficiency({
>   required String checkType,     // 'ability_check' | 'saving_throw'
>   required String playerClass,
>   required String habitCategory,
>   required String? skillSubCategory,
>   required String savingAbility,
>   required int userLevel,
> }) {
>   final base = getProficiencyBonus(userLevel);
>
>   if (checkType == 'saving_throw') {
>     // 豁免检定：仅查职业豁免表
>     return _classSavingThrowProficient(playerClass, savingAbility) ? base : 0;
>   }
>
>   // 普通检定：职业-类别匹配优先
>   if (_classCategoryMatch(playerClass, habitCategory)) {
>     return playerClass == 'fighter' ? (base / 2).floor().clamp(1, base) : base;
>   }
>
>   // Phase 3+ 技能子类别匹配（降级来源）
>   if (skillSubCategory != null && _skillSubCategoryMatch(playerClass, skillSubCategory)) {
>     return base;
>   }
>
>   return 0;
> }
> ```

#### 6.5.3 叠加规则一览

| 修正项 | 是否与其他项叠加 | 上限 | 备注 |
|--------|------------------|------|------|
| `d20` | — | 1–20（仅受保底系统影响） | 不受任何修正项影响 |
| `abilityMod` | 始终叠加 | 无上限（由属性值决定） | 来自主哈基米 |
| `proficiencyBonus` | 叠加，但**自身仅取单一来源** | +2 ~ +6（按等级） | 见 §6.5.2 矩阵 |
| `companionBonus` | 始终叠加 | +4（最多 2 只伙伴 × +2） | 伙伴优势属性匹配检定属性 |
| `flatBonuses` | 始终叠加 | mood +2 + streak +1 = +3 | 心情和连击独立判定 |
| `conditionMod` | 与所有项叠加 | 无全局上限 | 可为负值 |
| `environmentMod` | 与所有项叠加 | 无全局上限 | 可为负值 |
| `equipmentMod` | 与所有项叠加 | 无全局上限 | 来自已装备道具 |

**最终 total 无全局上限**（仅 d20 裸值限制在 1–20）。

#### 6.5.4 具体计算示例

> **场景**：等级 6 的游侠（Ranger），主哈基米 DEX = 16，携带 2 只伙伴猫（均为 DEX 优势属性），1 只心情 happy，连击 10 天，当前有"祝福"状态（conditionMod = +1），场景环境"顺风"（environmentMod = +1），装备"迅捷项圈"（equipmentMod = +1）。投掷一个 DEX 普通检定，习惯类别为 physical。

```
d20 裸值（保底后）            = 12
abilityMod (DEX 16)          = floor((16 - 10) / 2) = +3
proficiencyBonus              = +3（等级 6，游侠 + physical 类别匹配）
companionBonus                = +4（2 只伙伴猫 DEX 属性匹配，2 × +2）
flatBonuses                   = +2（happy 伙伴）+ +1（streak ≥ 7）= +3
conditionMod                  = +1（祝福状态）
environmentMod                = +1（顺风）
equipmentMod                  = +1（迅捷项圈）
──────────────────────────────────────
total                         = 12 + 3 + 3 + 4 + 3 + 1 + 1 + 1 = 28
```

若事件 DC = 15，则 total 28 ≥ DC + 10 = 25，判定为 **大成功（critical_success）**。

---

## 7. 检定使用谁的属性

**核心规则：始终使用主哈基米（Primary Cat）的属性修正值。**

- SceneEvent 指定需要检定的属性（STR / DEX / CON / INT / WIS / CHA）
- 从主哈基米读取该属性的修正值
- 伙伴猫**不直接贡献属性值**，而是通过优势/劣势机制间接影响结果

```dart
int getAbilityModifier(PrimaryCat primary, String ability) {
  final score = switch (ability) {
    'STR' => primary.strength,
    'DEX' => primary.dexterity,
    'CON' => primary.constitution,
    'INT' => primary.intelligence,
    'WIS' => primary.wisdom,
    'CHA' => primary.charisma,
    _     => throw ArgumentError('Unknown ability: $ability'),
  };
  return (score - 10) ~/ 2;  // floor division
}
```

---

## 8. 熟练加值（Proficiency Bonus）

### 8.1 适用条件（三者必须同时满足）

1. 用户等级 ≥ 3（即已选择职业，`playerClass != null`）
2. 赚取此骰子的猫咪对应习惯有 `category` 字段
3. 习惯类别与职业专长匹配（见下表）

### 8.2 职业-类别对应表

| 职业（Class） | 匹配类别（Category） | 熟练加值应用方式 |
|---|---|---|
| Ranger（游侠） | physical | 完整加值 |
| Wizard（法师） | mental | 完整加值 |
| Cleric（牧师） | wellness | 完整加值 |
| Bard（诗人） | social | 完整加值 |
| Rogue（盗贼） | skill | 完整加值 |
| Fighter（战士） | 任意（general） | 50% 加值（取 floor，最低 +1） |

Fighter 示例：等级 1-4 熟练加值 +2，战士实际获得 +1（floor(2/2)）。

### 8.3 熟练加值数值表

| 用户等级 | 熟练加值 |
|---|---|
| 1–4 | +2 |
| 5–8 | +3 |
| 9–12 | +4 |
| 13–16 | +5 |
| 17–20 | +6 |

```dart
int getProficiencyBonus(int userLevel) {
  if (userLevel <= 4)  return 2;
  if (userLevel <= 8)  return 3;
  if (userLevel <= 12) return 4;
  if (userLevel <= 16) return 5;
  return 6;
}

int computeProficiencyForRoll({
  required PrimaryCat primary,
  required String habitCategory,
  required int userLevel,
}) {
  final cls = primary.playerClass;
  if (cls == null) return 0;  // 未选职业

  final base = getProficiencyBonus(userLevel);

  if (cls == 'fighter') return (base / 2).floor().clamp(1, base);

  final matchMap = {
    'ranger'  : 'physical',
    'wizard'  : 'mental',
    'cleric'  : 'wellness',
    'bard'    : 'social',
    'rogue'   : 'skill',
  };
  return matchMap[cls] == habitCategory ? base : 0;
}
```

---

## 9. 优势与劣势

SRD 规则：当同时存在优势和劣势时，两者抵消，正常投 1d20。

### 同伴效果（两层机制）

| 层级 | 条件 | 效果 |
|------|------|------|
| **优势触发** | 伙伴猫性格匹配事件属性（如 brave 猫 + STR 事件） | 主哈基米获得优势（投 2d20 取高） |
| **属性加成** | 在场伙伴猫的优势属性匹配检定属性 | 该属性 +2（最多两只伙伴，最多 +4） |

两层效果独立计算，可同时生效。

> **三种独立加成**：心情平铺加成（+2）、属性匹配加成（+2 per companion, max +4）、性格优势（2d20 取高）三者 **完全独立** ，可同时生效，无叠加上限。

### 9.1 优势条件

| 条件 | 类型 | 效果 |
|---|---|---|
| 伙伴猫性格匹配事件属性 | 骰子优势 | 投 2d20 取较高值 |
| 伙伴猫心情 = happy | 平铺加成 | 最终结果 +2 |
| 活跃连击 ≥ 7 天 | 平铺加成 | 最终结果 +1 |

### 9.2 劣势条件

| 条件 | 类型 | 效果 |
|---|---|---|
| 伙伴猫心情 = lonely 或 missing | 骰子劣势 | 投 2d20 取较低值 |

### 9.3 性格-属性匹配规则

| 伙伴猫性格（Personality） | 匹配属性（Ability） |
|---|---|
| brave | STR |
| playful | DEX |
| lazy | CON |
| curious | INT |
| shy | WIS |
| clingy | CHA |

### 9.4 实现伪代码

```dart
RollInput buildRollInput({
  required List<Cat> companions,
  required String eventAbility,
  required int currentStreak,
}) {
  bool hasAdvantage = false;
  bool hasDisadvantage = false;
  int flatBonus = 0;

  for (final companion in companions) {
    if (_personalityMatchesAbility(companion.personality, eventAbility)) {
      hasAdvantage = true;
    }
    if (companion.mood == CatMood.happy) {
      flatBonus += 2;
    }
    if (companion.mood == CatMood.lonely || companion.mood == CatMood.missing) {
      hasDisadvantage = true;
    }
  }

  if (currentStreak >= 7) flatBonus += 1;

  // SRD：优势与劣势相互抵消
  final useAdvantage = hasAdvantage && !hasDisadvantage;
  final useDisadvantage = hasDisadvantage && !hasAdvantage;

  return RollInput(
    useAdvantage: useAdvantage,
    useDisadvantage: useDisadvantage,
    flatBonus: flatBonus,
  );
}
```

---

## 10. 完整检定流程

```dart
DiceResult performCheck({
  required PendingDice dice,
  required SceneEvent event,
  required PrimaryCat primary,
  required List<Cat> companions,
  required int userLevel,
  required String habitCategory,
  required PityState pity,
  required Random rng,
  int conditionMod = 0,      // Phase 2 状态效果修正
  int environmentMod = 0,    // Phase 2 环境效果修正
  int equipmentMod = 0,      // Phase 2 装备加成
}) {
  // 1. 投骰子
  final rawRoll = rng.nextInt(20) + 1;  // 1–20
  final roll = applyPity(rawRoll, pity);

  // 2. 双骰优势/劣势
  final rollInput = buildRollInput(companions, event.ability, currentStreak);
  final d20Result = _resolveAdvantage(roll, rollInput, rng);

  // 3. 属性修正值（主哈基米）
  final abilityMod = getAbilityModifier(primary, event.ability);

  // 4. 熟练加值
  final profBonus = computeProficiencyForRoll(primary, habitCategory, userLevel);

  // 5. 平铺加成（心情 + 坚持）
  final flatBonus = rollInput.flatBonus;

  // 5.5 伙伴属性加成（匹配检定属性的伙伴猫，+2/只，上限 +4）
  final companionBonus = _computeCompanionBonus(companions, event.ability);

  // 6. 最终结果（完整公式，详见 §6.5）
  final total = d20Result + abilityMod + profBonus + companionBonus + flatBonus
      + conditionMod + environmentMod + equipmentMod;

  // 7. 判定结果
  final outcome = _determineOutcome(d20Result, total, event.dc);

  // 8. 更新保底计数器
  updatePity(outcome, pity);

  return DiceResult(
    naturalRoll: d20Result,
    modifier: abilityMod,
    proficiencyBonus: profBonus,
    totalResult: total,
    dc: event.dc,
    outcome: outcome,
    hadAdvantage: rollInput.useAdvantage,
    hadDisadvantage: rollInput.useDisadvantage,
    stardustEarned: _rewardTable[outcome]!.stardust,
    // ...其他字段
  );
}

String _determineOutcome(int naturalRoll, int total, int dc) {
  if (naturalRoll == 20) return 'critical_success';
  if (naturalRoll == 1)  return 'critical_failure';
  if (total >= dc + 10)  return 'critical_success';
  if (total >= dc)       return 'success';
  return 'failure';
}
```

> **SRD 偏离说明**：SRD 5.2.1 中 nat 20/1 仅影响攻击骰和死亡豁免，对能力检定无特殊效果。我们有意扩展了这一规则，将 nat 20 和 nat 1 应用于所有检定，因为这是 D&D 社区最广泛接受的 house rule，也是用户期望的体验。

### 检定结果优先级规则（House Rule）

> **SRD 适配说明**：SRD 5.2.1 中 nat 20/1 仅影响攻击骰。我们将其扩展为所有检定的通用规则，因为这创造了更强的戏剧性和正反馈体验。

**Nat 值始终覆盖数值计算**，优先级如下：

| 情况 | d20 | 修正值 | total vs DC | 结果 | 理由 |
|------|-----|--------|-------------|------|------|
| 大成功 | 20 | 任意 | 任意 | `critical_success` | nat 20 覆盖一切 |
| 大失败 | 1 | 任意 | 任意 | `critical_failure` | nat 1 覆盖一切（但仍给 1⭐，零惩罚） |
| 超额成功 | 2-19 | 高 | total ≥ DC+10 | `critical_success` | 属性碾压 |
| 普通成功 | 2-19 | — | total ≥ DC | `success` | 标准检定 |
| 普通失败 | 2-19 | — | total < DC | `failure` | 标准检定（仍给 3⭐） |

```dart
String _determineOutcome(int naturalRoll, int total, int dc) {
  // 第一优先级：nat 值
  if (naturalRoll == 20) return 'critical_success';
  if (naturalRoll == 1) return 'critical_failure';
  // 第二优先级：数值计算
  if (total >= dc + 10) return 'critical_success';
  if (total >= dc) return 'success';
  return 'failure';
}
```

**零惩罚保证**：即使 `critical_failure`（nat 1），用户仍获得 1⭐ 星尘 + 搞笑猫咪动画。不会丢失任何已有资源。

---

## 11. DiceResult 数据模型

```dart
class DiceResult {
  final String id;              // UUID
  final String uid;             // 所属用户 ID
  final String pendingDiceId;   // 消耗的骰子 ID
  final String sceneCardId;     // 所属场景卡 ID
  final String eventId;         // 所属事件 ID
  final int naturalRoll;        // d20 原始结果（优势/劣势处理后）
  // > **明确定义**：`naturalRoll` 是优势/劣势处理**后**的最终 d20 值。如果有优势，投两次取高，`naturalRoll` = 较高值。如果有劣势，取低。这是用户看到的"骰子点数"。
  final int modifier;           // 属性修正值
  final int proficiencyBonus;   // 熟练加值（0 表示不适用）
  final int totalResult;        // 最终结果（含所有加成）
  final int dc;                 // 事件难度等级
  final String outcome;         // 'critical_success' | 'success' | 'failure' | 'critical_failure'
  final bool hadAdvantage;      // 是否使用了优势
  final bool hadDisadvantage;   // 是否使用了劣势
  final int stardustEarned;     // 本次获得星尘
  final DateTime rolledAt;      // 投掷时间
}
```

### 11.1 远端存储

通过 `AdventureBackend.saveDiceResult()` 同步。

远端存储路径：`users/{uid}/diceResults/{resultId}`

> **不可篡改约束**：检定结果写入后不可更新或删除（详见 [data-model.md](../architecture/data-model.md) §3 验证约束表）。

---

## 12. 奖励表

| 结果 | 判定条件 | 星尘 | 附加奖励 |
|---|---|---|---|
| 大成功（critical_success） | nat 20 或总结果超 DC 10+ | 15 ⭐ | 稀有配件碎片 1 枚 + 故事碎片 1 枚 |
| 成功（success） | 总结果 ≥ DC | 8 ⭐ | 故事碎片 1 枚 |
| 失败（failure） | 总结果 < DC | 3 ⭐ | 随机搞笑猫咪对话（来自 `dice_result_dialogues.dart`） |
| 大失败（critical_failure） | nat 1 | 1 ⭐ | 特殊搞笑对话 + "厄运终结者"成就进度 +1 |

**注意**：任何结果都有奖励，失败不应让用户感到惩罚，而是趣味化处理。

> **碎片说明**：「稀有配件碎片」和「故事碎片」属于物品系统（详见 spec/09-inventory-and-items.md）。碎片是独立物品，非货币，不可直接消费为星尘或金币。积累一定数量后可在酒馆合成为装备配件。Phase 2 上线时，碎片以 `inventory` 表存储但暂不启用合成功能（Phase 3+）。

> **碎片降级策略**：Phase 2 上线时，碎片存入 `local_inventory` 表（详见 spec/09）但暂不启用合成功能。UI 中显示碎片计数和"即将推出合成功能"提示。如果 spec/09 在 Phase 2 未准备好，碎片奖励降级为等额星尘（稀有碎片 = 5⭐，故事碎片 = 3⭐）。

### 12.1 奖励发放时机

**即时发放**：每次检定完成后，`stardustEarned` 立即写入 `materialized_state['stardust']`。不需等冒险完成。

**冒险完成额外奖励**：冒险结束时，根据星级评价发放额外奖励（详见 spec/04 §13.2）。此奖励与单次检定的即时星尘是**两个独立结算**。

```
检定 1 → 即时发放 8⭐
检定 2 → 即时发放 3⭐
...
检定 5 → 即时发放 15⭐
冒险完成 → 额外奖励：★★★ 评价 +50% 总星尘 = (8+3+...+15) × 0.5
```

**时序保证**：DiceResult 写入 + 星尘更新在同一 SQLite 事务中，确保原子性。冒险完成奖励在所有事件结算后单独写入。

---

## 13. 骰子动画规格

实现方式：Flutter `AnimationController` + `CustomPainter`（不引入 Rive，不引入新依赖）。

### 13.1 动画时序

```
阶段                  时长      说明
─────────────────────────────────────────────────────
骰子翻转（Tumble）     0.8s    d20 面随机切换，触觉：轻脉冲（light impact）
结果定格（Lock）       0.3s    减速停止，显示 d20 原始值
修正值叠加（Stack）    0.8s    依次弹出：属性修正、熟练加值、环境加成
判定（Judgment）      0.5s    与 DC 对比，结果横幅展开（颜色/图标区分）
─────────────────────────────────────────────────────
总时长                ~2.5s
```

### 13.2 触觉反馈（Haptic Feedback）

| 时机 | 反馈类型 |
|---|---|
| 骰子翻转阶段 | `HapticFeedback.lightImpact()` |
| nat 20 定格 | `HapticFeedback.heavyImpact()` |
| 成功定格 | `HapticFeedback.mediumImpact()` |
| 失败/大失败定格 | `HapticFeedback.lightImpact()` |

### 13.3 跳过动画

全程可点击跳过（`GestureDetector` 覆盖），直接跳到判定结果画面。

### 13.4 CustomPainter 渲染要求

- d20 外形用正多边形（20 面体投影）绘制，不使用图片资源
- 面上显示数字，字体复用现有 pixel font
- 判定结果颜色：大成功（金色 `#FFD700`）、成功（绿色 `#4CAF50`）、失败（灰色 `#9E9E9E`）、大失败（红色 `#F44336`）

---

## 14. 投掷模式

### 14.1 逐个投掷（默认）

- 每枚骰子独立播放完整动画
- 动画开始前展示来源猫咪头像 + 来源习惯名称
- 适合仪式感体验

### 14.2 一键全投（Roll All）

- 快速消化所有 PendingDice
- 仅显示汇总结果（各结果数量 + 总星尘）
- 不播放逐个动画，仅一次快速结算动画（0.5s）

---

## 15. Provider 设计

```dart
// 待投骰子列表
final pendingDiceProvider = StreamProvider<List<PendingDice>>((ref) {
  return ref.watch(diceServiceProvider).watchPendingDice();
});

// 投掷操作
final diceRollNotifierProvider = StateNotifierProvider<DiceRollNotifier, DiceRollState>((ref) {
  return DiceRollNotifier(ref.watch(diceEngineServiceProvider));
});
```

---

## 16. 验收标准（Acceptance Criteria）

- [ ] **保底验证**：1000 次模拟投掷，3 连败后下一次必然 ≥ 10；8 连非大成功后下一次必然为 nat 20
- [ ] **属性来源正确**：检定使用主哈基米的属性修正值，而非赚取骰子的伙伴猫的属性
- [ ] **熟练加值条件**：仅当职业-类别匹配时应用；战士获得 50% 加值（向下取整，最低 1）
- [ ] **优势/劣势抵消**：同时满足优势和劣势条件时，正常投 1d20（SRD 规则）
- [ ] **溢出时机正确**：第 21 枚骰子在创建时即转化为 5 金币，不等到投掷时处理
- [ ] **动画时长**：完整动画约 2.5 秒；点击任意位置可跳过至结果画面
- [ ] **触觉反馈**：nat 20 触发 `heavyImpact`，成功触发 `mediumImpact`，失败触发 `lightImpact`
- [ ] **奖励发放**：大成功 15 ⭐、成功 8 ⭐、失败 3 ⭐、大失败 1 ⭐，星尘写入用户账户
- [ ] **原子操作**：投掷成功后，PendingDice 删除与 DiceResult 写入在同一事务中完成
- [ ] **离线支持**：骰子获取和投掷均支持离线，同步至远端时无数据丢失
- [ ] **保底重置后真随机**：保底触发（连 3 败 → 下限 10）后，下一次投掷的 rawRoll 仍由 Random 产生，不预设结果
- [ ] **优势/劣势 Random 隔离**：优势模式下的两次 d20 使用同一个 Random 实例的连续调用（非两个独立实例），确保可通过固定种子复现
- [ ] **冒险级保底重置**：新冒险开始时，PityState.consecutiveFailures 和 consecutiveNonCrits 均重置为 0
