# 冒险场景卡规格书（Adventure Scene Card Specification）

> SSOT for 场景卡定义、冒险进度管理、队伍绑定、难度分级、星级评价 的完整行为规格。
> **Status:** Draft
> **Evidence:** `lib/models/scene_card.dart`（待创建）, `lib/models/adventure_progress.dart`（待创建）, `lib/services/adventure_service.dart`（待创建）, `lib/providers/adventure_provider.dart`（待创建）, `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md §5`
> **Related:** [spec/03-dice-engine.md](03-dice-engine.md), [spec/01-primary-cat.md](01-primary-cat.md), [spec/08-conditions-and-defenses.md](08-conditions-and-defenses.md), [spec/09-inventory-and-items.md](09-inventory-and-items.md), [architecture/data-model.md](../architecture/data-model.md)
> **Changelog:**
> - 2026-03-15 — 初版；修正场景卡绑定对象从「单只猫」改为「用户/队伍」
> - 2026-03-15 — 新增陷阱事件子类型、环境修正器、状态效果追踪（SRD 深度借鉴，详见 spec/08）

---

## 1. 核心修正：场景卡绑定到用户/队伍

**原始设计错误**：每只猫可绑定一个场景卡。

**正确规则**：**每个用户同时只有 1 个活跃冒险，绑定到当前队伍（主哈基米 + 可选伙伴猫）。**

理由：
- 骰子是用户级资源，不是单猫资源
- 多个并发冒险会造成进度分散，破坏叙事连贯性
- 简化数据模型，避免"哪只猫的骰子推进哪个场景"的歧义

### 1.1 冒险入口

| 入口位置 | 行为 |
|---|---|
| Tab 3（冒险者日志） | 主入口：查看当前冒险进度、待投骰子、历史记录 |
| Cat Detail 页「当前冒险」区块 | 辅助入口：跳转到同一冒险系统，选择/更换场景卡 |

两个入口进入**同一个**冒险系统，不存在两套独立冒险。

---

## 2. 冒险整体流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 选择场景（/scene-select）                                 │
│     - 展示已解锁的场景卡                                       │
│     - 选择难度（Normal / Hard / Legendary）                   │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│  2. 组建队伍（/party-select）                                 │
│     - 主哈基米（锁定，不可更换）                               │
│     - 0-2 只伙伴猫（可选，从现有习惯猫中选择）                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│  3. 抽取事件序列                                              │
│     - 从 SceneCard.eventPool（8-10 个）中随机抽取 eventsPerRun 个│
│     - 保存为 AdventureProgress.selectedEventIds              │
│     - 顺序固定（本次冒险内不再随机）                           │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│  4. 投掷骰子推进事件（/dice-roll）                            │
│     - 每枚 PendingDice 对应 1 次检定                         │
│     - 检定结果推进 currentEventIndex                          │
│     - 见 spec/03-dice-engine.md 检定流程                     │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│  5. 冒险完成                                                  │
│     - 所有事件完成后触发结算                                   │
│     - 计算星级评价（success_count / total_events）            │
│     - 发放完成奖励 + 星级附加奖励                              │
│     - AdventureProgress.status → 'completed'                 │
│     - 解锁更高难度（如符合条件）                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. SceneCard 数据模型

```dart
class SceneCard {
  final String id;
  final String name;                    // 场景卡名称（i18n key）
  final String region;                  // 所属区域（'cat_town' | 'misty_forest' | 'ancient_ruins'）
  final int requiredLevel;              // 最低用户等级要求
  final List<SceneEvent> eventPool;     // 候选事件池（8-10 个）
  final int eventsPerRun;               // 每次冒险抽取事件数量（3-5 个）
  final String completionRewardId;      // 完成奖励 ID（对应奖励常量）
  final String description;             // 场景描述（i18n key）
}

class SceneEvent {
  final String id;
  final String ability;     // 检定属性：'STR' | 'DEX' | 'CON' | 'INT' | 'WIS' | 'CHA'
  final int dc;             // 难度等级（Normal 基准值，Hard/Legendary 在运行时叠加）
  final String prompt;      // 事件描述文本（i18n key）
  final String successText; // 成功叙事文本（i18n key）
  final String failText;    // 失败叙事文本（i18n key）
}
```

---

## 4. AdventureProgress 数据模型

```dart
class AdventureProgress {
  final String id;                    // UUID
  final String uid;                   // 所属用户 ID
  final String sceneCardId;           // 选择的场景卡 ID
  final String difficulty;            // 'normal' | 'hard' | 'legendary'
  final List<String> partyMemberIds;  // 伙伴猫 ID 列表（0-2 个，不含主哈基米）
  final List<String> selectedEventIds;// 本次冒险抽取的事件 ID（有序）
  final int currentEventIndex;        // 当前推进到第几个事件（0-based）
  final List<String> eventResultIds;  // 已完成事件对应的 DiceResult ID 列表
  final int successCount;             // 成功（含大成功）事件数量
  final String status;                // 'active' | 'paused' | 'completed'
  final int? starRating;              // 完成后计算：1 | 2 | 3（null 表示未完成）
  final DateTime startedAt;           // 开始时间
  final DateTime? completedAt;        // 完成时间（null 表示未完成）
}
```

### 4.1 约束

- **每个用户同时只有 1 个 status = 'active' 的 AdventureProgress**
- 开始新冒险时，如存在 active 冒险 → 自动将其置为 'paused'（进度保留，可恢复）
- 已暂停的冒险可在 Tab 3 历史列表中恢复

### 4.2 Firestore 路径

```
users/{uid}/adventures/{adventureId}
```

### 4.3 SQLite 表结构

```sql
CREATE TABLE adventure_progress (
  id                  TEXT PRIMARY KEY,
  uid                 TEXT NOT NULL,
  scene_card_id       TEXT NOT NULL,
  difficulty          TEXT NOT NULL,
  party_member_ids    TEXT NOT NULL,  -- JSON 数组
  selected_event_ids  TEXT NOT NULL,  -- JSON 数组
  current_event_index INTEGER NOT NULL DEFAULT 0,
  event_result_ids    TEXT NOT NULL,  -- JSON 数组
  success_count       INTEGER NOT NULL DEFAULT 0,
  status              TEXT NOT NULL DEFAULT 'active',
  star_rating         INTEGER,        -- NULL 表示未完成
  started_at          TEXT NOT NULL,  -- ISO 8601
  completed_at        TEXT            -- NULL 表示未完成
);

CREATE INDEX idx_adventure_uid_status ON adventure_progress(uid, status);
```

---

## 5. 初始 15 张场景卡定义

所有文本均通过 i18n key 引用（预生成文本打包为本地常量，见 §10）。

### 5.1 区域 1：猫咪小镇（Cat Town）

**解锁条件**：等级 1+。**基础 DC 范围**：10–13。

| 场景卡 ID | 中文名 | 英文名 | 事件池数量 | 每次抽取 |
|---|---|---|---|---|
| `cat_town_market` | 市集广场 | Market Square | 8 | 3 |
| `cat_town_blacksmith` | 铁匠铺 | Blacksmith | 8 | 3 |
| `cat_town_library` | 图书馆 | Library | 8 | 3 |
| `cat_town_tavern` | 酒馆 | Tavern | 8 | 3 |
| `cat_town_herb` | 草药园 | Herb Garden | 8 | 3 |

### 5.2 区域 2：迷雾森林（Misty Forest）

**解锁条件**：等级 5+。**基础 DC 范围**：13–16。

| 场景卡 ID | 中文名 | 英文名 | 事件池数量 | 每次抽取 |
|---|---|---|---|---|
| `forest_ancient_trail` | 古树小径 | Ancient Trail | 9 | 4 |
| `forest_elven_spring` | 精灵泉 | Elven Spring | 9 | 4 |
| `forest_mushroom_cave` | 蘑菇洞 | Mushroom Cave | 9 | 4 |
| `forest_watchtower` | 瞭望塔 | Watchtower | 9 | 4 |
| `forest_moonlight_lake` | 月光湖 | Moonlight Lake | 9 | 4 |

### 5.3 区域 3：远古遗迹（Ancient Ruins）

**解锁条件**：等级 10+。**基础 DC 范围**：16–20。

| 场景卡 ID | 中文名 | 英文名 | 事件池数量 | 每次抽取 |
|---|---|---|---|---|
| `ruins_statue_puzzle` | 石像谜题 | Statue Puzzle | 10 | 5 |
| `ruins_floating_bridge` | 浮空桥 | Floating Bridge | 10 | 5 |
| `ruins_treasure_room` | 宝藏室 | Treasure Room | 10 | 5 |
| `ruins_mural_hall` | 壁画厅 | Mural Hall | 10 | 5 |
| `ruins_sealed_gate` | 封印之门 | Sealed Gate | 10 | 5 |

---

## 6. 难度分级

### 6.1 三档难度

| 难度 | DC 调整 | 奖励倍率 | 解锁条件 |
|---|---|---|---|
| Normal | 基础 DC | ×1.0 | 默认可用 |
| Hard | 基础 DC + 3 | ×1.5 | 该场景 Normal 通关后解锁 |
| Legendary | 基础 DC + 6 | ×2.0 | 该场景 Hard 通关后解锁 |

DC 调整在**运行时**叠加到 SceneEvent.dc 上，不修改原始数据。

### 6.2 难度解锁状态存储

```dart
// 存储于 AdventureUnlockState，每个场景卡独立
class SceneDifficultyUnlock {
  final String sceneCardId;
  final bool hardUnlocked;
  final bool legendaryUnlocked;
}
```

Firestore 路径：`users/{uid}/adventureUnlocks/{sceneCardId}`

---

## 7. 星级评价

### 7.1 计算公式

```dart
int calculateStarRating(int successCount, int totalEvents) {
  final rate = successCount / totalEvents;
  if (rate >= 1.0) return 3;  // 100% 成功
  if (rate >= 0.6) return 2;  // 60% 以上
  return 1;                    // 60% 以下（永远有奖励）
}
```

"成功"定义：结果为 `success` 或 `critical_success`（`failure` 和 `critical_failure` 不计入）。

### 7.2 星级奖励

| 星级 | 额外奖励 |
|---|---|
| ★★★ | 完美徽章（存入成就系统）+ 星尘奖励 ×1.5 |
| ★★☆ | 标准完成奖励 |
| ★☆☆ | 基础奖励（永远有，保证正向反馈） |

---

## 8. 队伍锁定规则

1. **场景开始时队伍锁定**：`partyMemberIds` 写入 `AdventureProgress` 后不可修改
2. **冒险中途更换场景**：当前冒险置为 `paused`，进度保留；新冒险开始时可重新组队
3. **空位无惩罚**：主哈基米可单独冒险，0 伙伴猫合法
4. **冒险中猫咪心情变化**：心情变化会实时影响下一次骰子的优势/劣势，但不会改变队伍成员

---

## 9. 可重复性设计

### 9.1 事件池随机化

每次开始新冒险时，从 eventPool 中**无重复随机抽取** eventsPerRun 个事件：

```dart
List<String> drawEvents(List<SceneEvent> pool, int count, Random rng) {
  assert(count <= pool.length, 'eventsPerRun must not exceed pool size');
  final shuffled = [...pool]..shuffle(rng);
  return shuffled.take(count).map((e) => e.id).toList();
}
```

### 9.2 多次游玩动力

- 同一场景每次抽取不同事件子集，体验有变化
- Hard / Legendary 难度提供挑战驱动力
- 3 星评价系统驱动精通追求
- 不同伙伴猫组合带来不同优势/劣势体验

---

## 10. 叙事文本策略（V1 预生成）

所有文本在**开发期**由 AI 批量生成，打包为本地 Dart 常量（`lib/core/constants/adventure_dialogues.dart`）。运行时无 AI 调用，无网络依赖。

### 10.1 文本规模估算

| 文本类型 | 数量计算 | 小计 |
|---|---|---|
| 场景事件叙事 | 15 场景 × 10 事件 × 2（成功/失败） | 300 段 |
| 主哈基米对话 | 6 性格 × 4 心情 × 5 变体 | 120 句 |
| 骰子结果文案 | 4 结果 × 6 属性 × 3 变体 | 72 句 |
| 队伍互动对话 | 6×6 性格组合 × 2 | 72 句 |
| **合计** | | **~564 段** |

每段文本需覆盖所有 15 种语言（`lib/l10n/`），共约 8,460 条 i18n 字符串。

### 10.2 文本工程规范

- i18n key 格式：`scene_{sceneId}_event_{eventId}_{success|fail}`
- 叙事文本长度：每段 30-80 字（中文）
- 风格：轻松幽默，适合猫咪像素风，避免黑暗/严肃叙事
- 详细规范见 [architecture/art-pipeline.md](../architecture/art-pipeline.md)（待创建）

---

## 11. 赛季场景卡【Phase 3+】

> **此为未来功能，V1 不实现。标注供架构预留。**

- 每月通过 Firebase Remote Config 下发 2-3 张限时场景卡（JSON 格式）
- 限时卡过期后：已开始的冒险进度保留，但该场景卡不再可选
- 叙事文本必须**随卡数据一起下发**（不可预装）
- 卡数据格式与 SceneCard 模型一致，通过 JSON 反序列化加载

---

## 12. Provider 设计

```dart
// 当前活跃冒险
final activeAdventureProvider = StreamProvider<AdventureProgress?>((ref) {
  return ref.watch(adventureServiceProvider).watchActiveAdventure();
});

// 场景卡列表（按用户等级过滤）
final availableScenesProvider = Provider<List<SceneCard>>((ref) {
  final userLevel = ref.watch(userLevelProvider);
  return AdventureConstants.allSceneCards
      .where((card) => card.requiredLevel <= userLevel)
      .toList();
});

// 冒险操作
final adventureNotifierProvider =
    StateNotifierProvider<AdventureNotifier, AdventureState>((ref) {
  return AdventureNotifier(ref.watch(adventureServiceProvider));
});
```

---

## 13. 数据一致性要求

### 13.1 原子操作

骰子投掷推进冒险进度时，以下操作必须原子完成：
1. 删除 `PendingDice`
2. 写入 `DiceResult`
3. 更新 `AdventureProgress.currentEventIndex` + `successCount` + `eventResultIds`

SQLite 使用事务（`txn.execute` 批次），Firestore 使用 `WriteBatch`。

### 13.2 冒险完成结算原子操作

1. 更新 `AdventureProgress.status = 'completed'`，写入 `starRating` + `completedAt`
2. 发放星尘奖励
3. 写入完美徽章（如 3 星）
4. 更新难度解锁状态（如符合条件）

---

## 14. 被动感知发现事件

> **SRD 灵感**：SRD 5.2.1 的被动检定（Passive Check）= `10 + 能力修正值 + 熟练加值`。用于 GM 判断角色是否自动注意到隐藏事物，无需掷骰。

### 机制

主哈基米的被动感知值 = `10 + WIS 修正值 + 熟练加值（如有 Perception 子技能）`

每日首次打开 App 时，系统根据被动感知值判断是否触发酒馆/猫屋中的发现事件：

| 被动感知 | 触发概率 | 发现类型 | 奖励 |
|---------|---------|---------|------|
| ≥ 12 | 30% | 普通发现（"沙发下发现了一枚古老金币"） | 5 金币 |
| ≥ 15 | 20% | 稀有发现（"窗台出现了一只流浪猫带来的礼物"） | 装饰品碎片 |
| ≥ 18 | 10% | 极稀有发现（"书架掉落了一本神秘书籍"） | 限定配件碎片 |

### 设计约束
- 每日最多触发 1 次发现事件
  > **"每日"定义**：基于用户本地时区的日历日。每天凌晨 00:00（本地时间）重置发现事件触发资格。使用 `SharedPreferences` key `last_discovery_date` 存储 `yyyy-MM-dd` 格式的上次触发日期。
- 发现事件在 Tab 2（猫咪酒馆）中以气泡提示展示
- 触发时有微弱触觉反馈 + 发现音效
- **Phase 建议**：Phase 2（与冒险系统同步上线）

### 验收标准
- [ ] 被动感知值计算正确（10 + WIS modifier + proficiency if applicable）
- [ ] 每日最多 1 次触发
- [ ] 触发概率随被动感知提升
- [ ] Alert 专长（+5 被动感知）正确影响触发率

---

## 15. 场景事件模板（3 张样板卡）

以下 3 张场景卡提供完整的事件定义，作为后续 12 张卡的创作模板。

### 市集广场（Cat Town · DC 10-13）

事件池（8 个事件，每次冒险随机抽取 4 个）：

| ID | 属性 | DC | 提示文 | 成功文 | 失败文 |
|----|------|-----|--------|--------|--------|
| town_market_01 | STR | 10 | 一个沉重的货箱挡住了去路。你的猫咪能推开它吗？ | 你的猫咪用力一推，货箱滑开了！里面掉出几枚闪亮的硬币。 | 你的猫咪使劲推了推，但货箱纹丝不动。一只友善的摊贩猫帮忙搬开了它。 |
| town_market_02 | DEX | 11 | 一条鱼从鱼贩的摊位上滑落！你的猫咪能接住它吗？ | 电光火石间，你的猫咪一爪接住了滑落的鱼！鱼贩猫感激地送上了谢礼。 | 鱼"啪"地一声掉在地上。你的猫咪尴尬地舔了舔爪子，假装什么都没发生。 |
| town_market_03 | INT | 12 | 一位老学者猫在摊位上摆出了一道谜题，解开就能获得奖品。 | 你的猫咪仔细思考后，优雅地给出了答案。老学者猫满意地点头。 | 你的猫咪歪着头想了半天，最终摇摇头放弃了。老学者猫安慰道："下次再来试试！" |
| town_market_04 | WIS | 10 | 市集的角落传来微弱的喵叫声。你的猫咪能找到声音的来源吗？ | 你的猫咪循着声音找到了一只躲在箱子后面的小猫咪，它看起来迷路了。 | 市集太嘈杂了，你的猫咪转了一圈也没找到声音来源。也许下次运气会好一些。 |
| town_market_05 | CHA | 11 | 一个脾气暴躁的摊贩拒绝和任何人做生意。你的猫咪能说服他吗？ | 你的猫咪用一个可爱的头蹭动作融化了摊贩的心。"好吧好吧，看在你这么可爱的份上！" | 摊贩不为所动地翻了个白眼。你的猫咪不气馁——下次带上更多魅力！ |
| town_market_06 | CON | 13 | 广场上举办了一场"猫咪马拉松"！终点就在不远处。 | 你的猫咪稳步奔跑，第一个冲过了终点线！围观的猫咪们发出热烈的喵叫。 | 你的猫咪跑到一半就气喘吁吁地坐下了。没关系，重在参与！ |
| town_market_07 | DEX | 12 | 屋顶上的风铃被风吹得叮当作响，其中一个似乎快要掉下来了。 | 你的猫咪灵巧地跳上屋檐，稳稳地接住了风铃。铃声清脆悦耳。 | 风铃"哐当"掉在了地上。幸好没砸到人，你的猫咪松了一口气。 |
| town_market_08 | INT | 10 | 公告板上贴着一张褪色的藏宝图。你的猫咪能读懂它吗？ | 你的猫咪歪着头研究了一会儿，突然眼睛一亮——这是通往旧磨坊的路线！ | 地图上的符号对你的猫咪来说像是猫爪涂鸦。也许需要更多知识才能解读。 |

### 铁匠铺（Cat Town · DC 11-13）

事件池（8 个事件，每次冒险随机抽取 3 个）：

| ID | 属性 | DC | 提示文 | 成功文 | 失败文 |
|----|------|-----|--------|--------|--------|
| town_smith_01 | STR | 12 | 铁匠猫需要帮忙搬运一批矿石。你的猫咪能帮上忙吗？ | 你的猫咪卷起袖子（如果有的话），一趟趟搬运矿石，铁匠猫赞许地点头。 | 矿石太重了，你的猫咪搬了两块就放弃了。铁匠猫拍了拍你的猫咪："别担心，慢慢来。" |
| town_smith_02 | DEX | 13 | 铁匠猫让你的猫咪试着在铁砧上敲出一个简单的铃铛形状。 | 叮叮叮！你的猫咪敲出了一个虽然歪歪扭扭但很有味道的小铃铛。 | 你的猫咪把铁片敲成了一团……有创意的抽象艺术？ |
| town_smith_03 | INT | 11 | 铁匠铺里摆着各种工具，铁匠猫问："你知道这个钳子是用来做什么的吗？" | 你的猫咪自信地回答，铁匠猫满意地笑了："看来你对锻造有天赋！" | 你的猫咪指了指一把锤子说"这是汤匙？"铁匠猫善意地笑了。 |
| town_smith_04 | CON | 12 | 铁匠铺里闷热异常，你的猫咪能在这里待够足够久帮忙完成订单吗？ | 你的猫咪擦了擦汗，坚持到最后。铁匠猫递来一杯冰凉的猫薄荷茶作为感谢。 | 才过了一会儿，你的猫咪就受不了热气跑出来了。外面的清风真舒服！ |
| town_smith_05 | WIS | 11 | 铁匠猫展示了两把外表相同的匕首，但其中一把是次品。你的猫咪能分辨吗？ | 你的猫咪仔细端详后指出了次品——刃口有一处微小的裂纹！ | 你的猫咪犹豫了一下选错了。铁匠猫安慰道："慧眼需要磨炼。" |
| town_smith_06 | CHA | 12 | 一位挑剔的客人猫在抱怨订单不满意。铁匠猫偷偷请你的猫咪帮忙安抚。 | 你的猫咪用温柔的话语和一个小礼物让客人猫转怒为笑。危机解除！ | 客人猫越说越激动。你的猫咪悄悄退到一边，决定让专业人士来处理。 |
| town_smith_07 | STR | 13 | 铁匠猫的风箱坏了！需要有人用力拉动临时替代品来维持炉火。 | 你的猫咪有节奏地拉动着，炉火越烧越旺！铁匠猫竖起了大拇指。 | 你的猫咪拉了几下就累了，炉火渐渐暗了下来。今天的锻造只好改期了。 |
| town_smith_08 | DEX | 11 | 铁匠猫不小心打翻了一盒钉子！能帮忙在它们滚到角落之前捡起来吗？ | 你的猫咪眼疾手快，一颗不漏地捡了回来。效率惊人！ | 钉子滚得到处都是，你的猫咪追了半天只捡回一半。不过铁匠猫说"够用了！" |

### 古树小径（Misty Forest · DC 13-16）

事件池（8 个事件，每次冒险随机抽取 4 个）：

| ID | 属性 | DC | 提示文 | 成功文 | 失败文 |
|----|------|-----|--------|--------|--------|
| forest_trail_01 | WIS | 14 | 小径分成两条岔路，一条看起来安全但漫长，另一条隐约有光。你的猫咪选哪条？ | 你的猫咪敏锐地察觉到光的方向有清澈的泉水声——果然是通往精灵泉的捷径！ | 你的猫咪走了"安全"的路，结果绕了一大圈。不过沿途的蘑菇很可爱！ |
| forest_trail_02 | DEX | 15 | 一棵倒下的古树横跨溪流，上面长满了湿滑的青苔。你的猫咪能走过去吗？ | 你的猫咪小心翼翼地踩稳每一步，优雅地走过了独木桥。猫步果然名不虚传！ | 你的猫咪脚一滑——"噗通"！幸好溪水不深，只是湿了爪子。 |
| forest_trail_03 | INT | 14 | 树干上刻着一些古老的符文。你的猫咪能理解它们的含义吗？ | 你的猫咪辨认出这是古猫语的方向标记："宝藏在北，危险在南。"有用！ | 这些弯弯曲曲的符号看起来像……猫抓痕？你的猫咪决定继续前进。 |
| forest_trail_04 | STR | 13 | 一块巨石堵住了小径。你的猫咪能找到办法通过吗？ | 你的猫咪找到了支点，用巧劲把巨石滚到了路边。力与技的完美结合！ | 巨石纹丝不动。你的猫咪只好从旁边的灌木丛里钻了过去，虽然有点狼狈。 |
| forest_trail_05 | CHA | 15 | 一群萤火虫在夜色中飞舞。据传，对它们唱歌可以获得照明引导。 | 你的猫咪轻声哼唱，萤火虫们聚拢过来形成了一条光带，照亮了前方的道路！ | 你的猫咪张嘴一唱，萤火虫们四散而去。也许这不是它的音域。 |
| forest_trail_06 | CON | 14 | 迷雾越来越浓，能见度不到两步。你的猫咪能保持方向感继续前行吗？ | 你的猫咪信赖自己的直觉，稳稳当当地穿过了迷雾区。出口的阳光温暖而明亮。 | 你的猫咪在雾中转了好几圈，最终回到了出发点。至少没迷路？ |
| forest_trail_07 | WIS | 16 | 脚下的落叶中隐约有东西在闪光。你的猫咪能发现它吗？ | 你的猫咪拨开落叶，发现了一枚被遗忘的古老钱币。不知是谁在很久以前留下的。 | 闪光消失了——也许只是阳光的折射。你的猫咪耸耸肩继续前进。 |
| forest_trail_08 | DEX | 13 | 一只蝴蝶停在了前方的花朵上。传说触碰它能带来好运。 | 你的猫咪轻手轻脚地靠近，温柔地用鼻尖碰了碰蝴蝶。它振翅而去，留下了一缕金色的粉末。 | 你的猫咪刚伸出爪子，蝴蝶就飞走了。也许好运会以别的方式降临。 |

---

## 16. 验收标准（Acceptance Criteria）

- [ ] **事件池抽取**：每次冒险抽取正确数量的事件，无重复，顺序固定（本次冒险内）
- [ ] **单活跃冒险约束**：用户开始第二次冒险时，第一次自动置为 paused，不丢失进度
- [ ] **进度持久化**：App 重启后冒险进度完整恢复（currentEventIndex、eventResultIds 正确）
- [ ] **星级计算**：100% 成功 → 3 星；60-99% → 2 星；<60% → 1 星；边界值（3/5 成功 = 60%）→ 2 星
- [ ] **难度解锁**：Normal 通关后 Hard 可选；Hard 通关后 Legendary 可选；解锁状态跨会话持久
- [ ] **已完成冒险**：在 Tab 3 历史列表中展示，含场景名、难度、星级、完成时间
- [ ] **区域等级锁**：等级 < 5 时迷雾森林不可选；等级 < 10 时远古遗迹不可选
- [ ] **DC 难度叠加**：Hard 难度下 DC 正确 +3；Legendary 下 DC 正确 +6（运行时叠加，不改原始数据）
- [ ] **奖励倍率**：Hard 奖励 ×1.5；Legendary 奖励 ×2；数值向下取整
- [ ] **离线支持**：冒险进度在无网络时正常推进，联网后同步至 Firestore
- [ ] 被动感知值在冒险者日志中正确显示
- [ ] 24 个样板事件文本正确加载（8 × 3 张卡）
- [ ] 事件文本支持 i18n（通过 JSON 资源文件，非 ARB）

---

## 17. SRD 深度借鉴扩展（Phase 2）

> 以下扩展详见独立 spec 文件，此处仅列出集成钩子。

### 17.1 陷阱事件（详见 spec/08 §方向 5）

SceneEvent 新增 `type` 字段支持 `'trap'` 类型。陷阱事件使用三阶段流程：发现（被动感知）→ 拆除（属性检定）→ 触发（豁免检定）。

```dart
class SceneEvent {
  // ... existing fields
  final String type;              // 'ability_check' | 'saving_throw' | 'trap'
  final int? trapDetectDc;        // 陷阱：发现所需被动感知
  final String? trapDisarmAbility; // 陷阱：拆除检定属性
  final int? trapDisarmDc;        // 陷阱：拆除 DC
}
```

### 17.2 环境修正器（详见 spec/08 §4）

SceneCard 新增 `environment` 字段，支持场景级全局修正。

```dart
class SceneCard {
  // ... existing fields
  final String? environment; // null | 'extreme_cold' | 'heavy_rain' | 'blessed_ground' | ...
}
```

### 17.3 状态效果追踪（详见 spec/08 §2）

AdventureProgress 新增 `activeConditions` 字段，追踪冒险进行中的临时 Buff/Debuff。

```dart
class AdventureProgress {
  // ... existing fields
  final List<ActiveCondition> activeConditions; // 冒险结束时强制清空
}
```

### 17.4 冒险掉落扩展（详见 spec/09 §7.2）

冒险结算时根据结果掉落物品（装备、药水、Trinket），掉落概率表定义在 spec/09 中。
