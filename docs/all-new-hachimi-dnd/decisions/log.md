# 决策日志

> 记录 v2.0 DnD 融合设计中的所有关键决策、理由和被否决的替代方案。
> **Status:** Active
> **Changelog:** 2026-03-15 — 初版

---

## 关键决策

### D1. 猫咪架构：路线 C（主哈基米 + 伙伴猫）

**日期**：2026-03-15
**决策**：采用"主哈基米（用户化身）+ 伙伴猫（1猫=1习惯）"混合架构。
**理由**：
- 兼具 Finch 情感深度（队长猫承担）和 Habitica 习惯广度（伙伴猫承担）
- 创造市场独有的"习惯可视化 + RPG 组队"融合体验
- 完全向后兼容现有"1猫=1习惯"映射

**否决方案**：
- **路线 A（纯猫群）**：缺少主角情感锚点，用户情感分散
- **路线 B（单一主角）**：需重构数据模型，丧失习惯个体化表达

详细论证见 [research/party-architecture.md](../research/party-architecture.md)

### D2. 渲染引擎：不引入 Flame/Rive

**日期**：2026-03-15
**决策**：保持现有 13 层 PNG 渲染管线 + CustomPainter + AnimationController。
**理由**：
- 零新依赖约束
- 现有 PixelCatRenderer 已满足所有猫咪渲染需求
- 骰子动画用 CustomPainter 完全可实现
- 引入 Flame 会偏离"工具为主"定位

**否决方案**：
- **Flame + Rive**（调研建议）：性能更优但违反约束，增加 AGP 构建风险
- **仅 Rive**（折中方案）：状态机确实好用，但仍是新依赖

详细技术对比见 [research/finch-teardown.md](../research/finch-teardown.md) §三

### D3. 导航结构：保持 3 Tab

**日期**：2026-03-15
**决策**：保持 Today / Cat Tavern / Journal 三个 Tab。
**理由**：
- 导航简洁，"打开到专注 ≤ 3 次点击"更易保证
- 冒险功能通过 Tab 3 子路由承载
- 5 Tab 底部栏图标密度过高，影响像素风视觉

**否决方案**：
- **5 Tab**（调研建议 Today/猫屋/冒险/统计/我的）：每个功能独立 Tab 但导航重

### D4. 雷达图：CustomPainter 自绘

**日期**：2026-03-15
**决策**：属性雷达图使用 CustomPainter 自绘，不引入 fl_chart。
**理由**：fl_chart 违反零新依赖约束。CustomPainter 绘制六边形雷达图并不复杂。

**⚠️ 此决策已被 D9 取代——改用 fl_chart RadarChart。**

### D5. 金币经济：待重新设计

**日期**：2026-03-15
**决策**：现有 10 金币/分钟导致严重通胀。经济系统需要在 Phase 3 重新平衡。
**参考**：调研建议 1 金币/分钟（日均 80-130），但需实际测试。
**状态**：[待定稿]

### D6. 场景卡绑定对象：绑定到用户/队伍

**日期**：2026-03-15（审查修复）
**决策**：场景卡绑定到用户的当前冒险，而非单只猫。
**理由**：原 spec 说"每只猫可绑定一个场景卡"但同时又说"只能激活 1 个场景"，逻辑矛盾。冒险是队伍行为，应绑定到 AdventureProgress。

### D7. 检定属性来源：使用主哈基米属性

**日期**：2026-03-15（审查修复）
**决策**：检定时使用主哈基米的属性修正值。伙伴猫通过优势/劣势机制间接影响。
**理由**：主哈基米是用户化身，检定结果应反映用户的综合习惯表现。伙伴猫的策略价值在于"触发优势"，而非替代主哈基米的属性。

### D8. 三段进化（隐藏长老猫）

**日期**：2026-03-15
**决策**：隐藏 Senior（长老猫）阶段，仅展示 Kitten → Adolescent → Adult 三段进化，类似宝可梦三段进化。
**理由**：
- "长老猫"可能让用户产生衰老感，不符合积极向上的产品调性
- Senior 精灵几何完全复用成年短毛（indices 12-14 = adult shorthair），隐藏它在视觉上零损失
- 三段进化更简洁、更有辨识度（宝可梦模式被全球用户理解）
- 阶段上限调整为 14/17/20，中间段从 16 提高到 17 以容纳更宽的成长空间

**否决方案**：保留 4 段进化（现状），Senior 作为终极形态。否决原因：用户反馈"长老"有负面联想。

### D9. ClanGen 协议问题 + Flame/Rive 引入 + 胶水编程原则

**日期**：2026-03-15
**背景**：经调查发现，项目中所有猫咪精灵图资产来自 [pixel-cat-maker](https://github.com/cgen-tools/pixel-cat-maker)，其精灵图由 ClanGen Team 创作，使用 **CC BY-NC 4.0** 协议。**NC = NonCommercial，禁止商用。**

**决策（三个关联决策）**：

1. **立即开始替换所有 ClanGen 精灵图** — 所有 38 张 spritesheet（8MB）必须替换为原创资产
2. **引入 Flame + Rive 作为新渲染引擎** — 既然美术必须重做，"零新依赖"约束的前提已消失。采用最强方案：Rive（猫咪骨骼动画+状态机）+ Flame（2D 游戏场景）
3. **确立"胶水编程"核心原则** — 不追求零依赖，而是拥抱成熟的开源可商用轮子，开发者写好"胶水"

**推进策略**：先逻辑后美术 — 用现有 ClanGen 精灵做开发占位实现 DnD 逻辑，逻辑完成后切换到 Rive+Flame。

**理由**：
- CC BY-NC 4.0 明确禁止商用，继续使用有法律风险
- Rive 提供骨骼动画+状态机+运行时换装（一个 .riv 文件含所有猫咪状态），远优于 13 层 PNG 合成
- Flame 提供 2D 游戏场景能力（酒馆互动、冒险场景），让 App 达到 Finch 级体验
- 所有选用的包均为 MIT/Apache/BSD 协议，商用无障碍

**否决方案**：
- 保持零新依赖 + PNG 帧动画：工作量反而更大（需绘制大量帧），且动画表现力有限
- 联系 ClanGen 团队获取商用授权：NC 协议通常是有意选择，获授权可能性低

**新技术栈**（必装）：

| 包 | 协议 | 用途 |
|---|---|---|
| `rive` | MIT | 猫咪角色骨骼动画 |
| `flame` | MIT | 2D 游戏引擎 |
| `flame_rive` | MIT | Rive-Flame 桥接 |
| `flame_riverpod` | MIT | 状态管理桥接 |
| `flame_audio` | MIT | 游戏音效 |
| `fl_chart` | MIT | 属性雷达图 |
| `audioplayers` | MIT | 短音效（任务完成反馈） |

---

## 设计审查记录

2026-03-15 对规格书草稿进行了全面审查，发现 18 项问题：

| # | 优先级 | 问题 | 状态 |
|---|--------|------|------|
| 1 | P0 | AdventureProgress 模型缺失 | ✅ 已补充 |
| 2 | P0 | DiceResult 模型缺失 | ✅ 已补充 |
| 3 | P0 | 场景卡绑定矛盾 | ✅ 修正为绑定队伍 |
| 4 | P0 | 检定属性规则不明确 | ✅ 明确为主哈基米 |
| 5 | P0 | 属性公式数据源不存在 | ✅ 标注获取路径 |
| 6 | P0 | SQLite schema 缺失 | ✅ 已补充完整 DDL |
| 7 | P1 | PrimaryCat 与 Cat 关系 | ✅ 明确独立模型 |
| 8 | P1 | 老用户迁移原子性 | ✅ 删除（无用户） |
| 9 | P1 | Tab 3 UI 结构 | ✅ 补充 ASCII 布局 |
| 10 | P1 | LedgerChange 新增类型 | ✅ 已列出清单 |
| 11 | P1 | 熟练加值条件 | ✅ 定义职业匹配规则 |
| 12 | P1 | fl_chart 矛盾 | ✅ 改为 CustomPainter |
| 13 | P2 | 叙事文本工程化 | ✅ 方案在 art-pipeline.md |
| 14 | P2 | 金币经济 | ⏳ 标注待定稿 |
| 15 | P2 | 赛季场景卡 | ✅ 标注 Phase 3+ |
| 16 | P2 | Firestore 规则 | ✅ 已补充 |
| 17 | 修正 | 队伍对话数算错 | ✅ 修正为 36 句 |
| 18 | 修正 | Flame/Rive 引用 | ✅ 全部替换 |

---

## 补充决策（设计深化阶段）

### D18. Onboarding 保持 5 步，背景选择推迟

**日期**：2026-03-15
**决策**：Onboarding 流程维持现有 5 步不变，背景选择（background）推迟到 Phase 3 实现。Phase 1 中 `PrimaryCat.background` 默认值为 `'adventurer'`。
**理由**：Phase 1 不需要背景选择功能，默认值即可满足数据模型完整性要求。减少 Onboarding 认知负担。

### D19. paused vs abandoned 语义区分

**日期**：2026-03-15
**决策**：同一场景卡开启新冒险 = `paused`（可恢复）；切换到不同场景卡 = `abandoned`（永久放弃）。
**理由**：区分"重试"和"放弃"两种用户意图。`paused` 允许用户回到之前的进度继续，`abandoned` 表示用户主动选择了新方向。

### D20. 多职业 XP 公式使用加法

**日期**：2026-03-15
**决策**：多职业经验值公式采用加法模型：`minutes × (1 + mainBonus + subBonus × 0.5)`。
**理由**：加法模型可预测、易调试。乘法模型会导致数值膨胀，后期难以平衡。

### D21. exhausted 重命名为 well_rested 正向增益

**日期**：2026-03-15
**决策**：将 `exhausted` 条件重命名为 `well_rested` 正向增益（Buff）。触发条件：连续 3 天以上完成习惯，效果：所有属性修正值 +1。
**理由**：反转表述框架，消除"零惩罚"矛盾。原设计中 `exhausted` 作为负面状态，但产品不应惩罚用户——改为正向激励，连续坚持习惯获得奖励。

### D22. 额外骰子购买每日上限 3 次

**日期**：2026-03-15
**决策**：每日额外骰子购买次数限制为 3 次。
**理由**：防止无限星尘生成。重度用户每日上限 50×3=150 金币消耗，经济系统可控。

### D23. 分支数量阈值从 3 提升至 5

**日期**：2026-03-15
**决策**：代码质量红线中分支数量阈值调整为分级制——3 为审查触发、5 为硬性上限、10 为绝对天花板。
**理由**：McCabe 圈复杂度行业标准为 10，严格项目 5-7。原阈值 3 对游戏逻辑（骰子检定分支、职业判定、场景路由）过于严格，导致过度碎片化。

### D24. Passive Perception 状态存储在 SQLite

**日期**：2026-03-15
**决策**：被动感知（Passive Perception）状态存储在 SQLite 的 `local_primary_cat.last_discovery_date` 字段中，不使用 SharedPreferences。
**理由**：离线优先原则——SQLite 是唯一的持久化状态源。SharedPreferences 用于轻量偏好设置，不适合存储游戏状态数据。

### D25. 职业选择触发改为派生检查

**日期**：2026-03-15
**决策**：职业选择触发条件改为派生检查 `playerClass == null && level >= 3`，消除 SharedPreferences 依赖。
**理由**：消除 SP 依赖，保持状态来源单一（SQLite）。派生检查更可靠，不存在 SP 与实际状态不同步的风险。

### D26. 叙事文本用 Dart 常量，UI 文案用 ARB

**日期**：2026-03-15
**决策**：叙事文本（场景描述、检定结果描述）使用 Dart 常量管理；UI 短文案（按钮、标签、提示）使用 ARB 国际化文件。两套系统有明确边界。
**理由**：叙事文本按场景/结果结构化组织，天然适合 Dart 常量类（按场景分组、按结果索引）。ARB 更适合扁平的 UI 短字符串。混用会导致两边都难以维护。

### D27. 大版本不做向后兼容

**日期**：2026-03-15
**决策**：v2.0 作为大版本更新，不提供从旧版本的数据迁移。SQLite 直接使用 v1 schema，无需编写 migration。
**理由**：现有用户量极少，从零开始可大幅简化实现。避免为不存在的用户基数编写复杂迁移逻辑。

### D28. D4（CustomPainter 雷达图）被 D9 取代

**日期**：2026-03-15
**决策**：D4 的 CustomPainter 自绘雷达图方案被 D9 推翻，改用 `fl_chart` 的 RadarChart。
**理由**：D9 推翻了零新依赖约束（因 ClanGen 协议问题必须引入新依赖），fl_chart 作为 MIT 协议的成熟图表库，雷达图开箱即用，无需自行维护绘制逻辑。

### D29. Remote Config 参数必须有编译时硬编码回退默认值

**日期**：2026-03-15
**决策**：所有 Firebase Remote Config 参数在代码中必须有编译时硬编码的回退默认值。
**理由**：离线优先——无网络时使用默认值，确保 App 在完全离线状态下仍可正常运行。

### D30. stardustEarned 远程校验上限从 20 调整为 30

**日期**：2026-03-15
**决策**：`stardustEarned` 的远程校验上限从 20 提升至 30。
**理由**：Rogue 职业有 x1.5 星尘加成，15×1.5=22.5 已超过原上限 20，导致合法收益被拦截。上限 30 可容纳所有职业加成组合。

### D31. PityState 批量共享：rollAll() 使用单一实例

**日期**：2026-03-15
**决策**：`rollAll()` 批量投掷时，所有骰子共享同一个 `PityState` 实例。
**理由**：批量投掷中的连续失败也应触发保底机制（pity floor）。若每颗骰子独立 PityState，则批量中的连续失败不会累积，违背保底设计意图。

### D32. 事件池 Random 使用独立实例

**日期**：2026-03-15
**决策**：事件池（Event Pool）抽取使用独立的 `Random` 实例，不与 `DiceEngine` 共享。
**理由**：事件抽取和骰子投掷是独立关注点（separate concerns）。共享 Random 会导致事件抽取影响骰子序列的可复现性，不利于测试和调试。

### D33. retention_day_n 计算方式：日历天

**日期**：2026-03-15
**决策**：`retention_day_n` 定义为用户打开 App 的日历天数。
**理由**：与行业标准 DAU（Daily Active Users）定义一致。按日历天计算而非连续天数，更准确反映用户留存行为。

---

## 审计修复决策（2026-03-15 审计后新增）

> 以下决策来自 v2.0 设计文档的上线前审计 + 架构审查，修复了 8 项 P0 阻塞问题和 6 项高价值改进。

### D34. CON 属性改用 longestEverStreak（历史最长连击）

**日期**：2026-03-15
**决策**：CON（体质）属性的计算从 `currentStreak`（当前连续打卡天数）改为 `longestEverStreak`（历史最长连续天数）。StreakService 新增 `longestEverStreakForHabit` 和 `longestEverAcrossAllHabits` 方法，使用滑动窗口算法扫描所有日期集合。
**理由**：原方案中断连一天后 CON 从 20 掉到 10，直接违反零惩罚红线 #4（"断连不清零"）。`longestEverStreak` 确保 CON 只增不减，用户曾经坚持的努力永远被记录。
**否决方案**：
- 暂停式连击（断连冻结，恢复后继续累加）：实现复杂，需额外 `pausedStreak` 字段
- 累计总天数替代连击：丢失了 CON "坚韧"的语义

### D35. Party 选择暂存内存，crash 重选可接受

**日期**：2026-03-15
**决策**：Party 选择仅暂存内存，不持久化到临时表。crash 后选择丢失，需重新选择。
**理由**：Party 选择是 5 秒内的轻量操作（选 0-2 只伙伴猫），不值得引入临时持久化表增加系统复杂度。

### D36. local_dice_results 加索引，暂不归档

**日期**：2026-03-15
**决策**：新增 `idx_dice_results_uid_rolled` 索引。不实施 180 天归档策略。
**理由**：年 1,000 条 DiceResult 对 SQLite 性能无压力（<100KB），归档属过度工程。留到用户量超过 10k 再考虑。

### D37. primaryCatAbilitiesProvider 暂不优化 select 过滤

**日期**：2026-03-15
**决策**：`primaryCatAbilitiesProvider` 暂时 watch 完整 PrimaryCat 对象，不使用 `.select()` 过滤属性相关字段。
**理由**：外观变更频率极低（500 金币/次），过早优化得不偿失。若未来外观变更频率增加，再改用 `.select()` 仅监听 `archetype`、`asiChoices`、`selectedFeats` 等字段。

### D38. ActionType.tryFromValue() 为 Phase 1 首个 PR 必须项

**日期**：2026-03-15
**决策**：`ActionType.fromValue()` 改为 `tryFromValue()` 模式（遇到未知值返回 `null`），必须在任何 DnD 功能代码之前完成。
**理由**：前向兼容是架构级正确实践。新版本写入的 18 种 ActionType 不应导致旧版本崩溃。

### D39. spec/06 Evidence 引用修正

**日期**：2026-03-15
**决策**：`spec/06-economy.md` 的 Evidence 从 `lib/services/gold_service.dart`（不存在）修正为 `lib/services/coin_service.dart`。
**理由**：纯标注错误。

### D40. crash 恢复依赖 SQLite 事务原子性

**日期**：2026-03-15
**决策**：不额外引入 `rewarded` 字段或 Ledger 级补发逻辑。骰子检定的三步操作在同一 SQLite 事务中执行，事务要么全成功要么全回滚。
**理由**：SQLite 事务原子性已保证不存在"有结果无星尘"的中间态。远端推送失败由现有 SyncEngine 重试机制覆盖。

### D41. 撤回 coins → gold 重命名

**日期**：2026-03-15
**决策**：保留现有 `coins` 命名（CoinService、`materialized_state.coins`），不重命名为 gold。spec/06 中的 `gold` 全部改回 `coins`。UI 层通过 i18n 展示为"金币"。
**理由**：架构审查发现 CoinService 在 59+ 个文件中被引用，materialized_state key 为 `'coins'`，15 种 ARB 文件都有 coins key。仅为 DnD 风味一致性发起全代码库重命名是净负价值重构——投入数天纯重命名工作，引入大量回归风险，收益为零。

### D42. DnD 设计文档暂不做中文镜像

**日期**：2026-03-15
**决策**：`docs/all-new-hachimi-dnd/` 目录不在 `docs/zh-CN/` 中创建镜像。
**理由**：DnD 设计文档是独立设计包，不在 `docs/architecture/` 主架构树中。CLAUDE.md 的双语要求适用于主架构文档。DnD 文档本身已用中文写成，无需额外中文镜像。编码实现后若对 `docs/architecture/` 进行更新，则需中英双语。

### D43. PityState 持久化到 AdventureProgress

**日期**：2026-03-15
**决策**：PityState 从仅存内存改为持久化到 `AdventureProgress` 模型（`pityConsecutiveFailures` + `pityConsecutiveNonCrits` 字段）。冒险恢复时一并恢复保底状态。
**理由**：原方案（D31）中 PityState 仅存内存，App crash 后保底计数器归零。在长冒险（5 个事件）中，前 3 个事件连续失败后 crash，重启后保底重置，第 4 个事件不再有保底保护。这可能导致 4-5 连败体验，与零惩罚精神矛盾。持久化成本极低（2 个 int 字段），收益明确。

### D44. computePrimaryCatAbilities 参数化 + 并行查询

**日期**：2026-03-15
**决策**：`computePrimaryCatAbilities` 从同步函数改为 async FutureProvider。3 个 Service 异步查询使用 `Future.wait` 并行执行。`allCatsTotalMinutes`、`activeHabitCount`、`avgGoalMinutes` 从现有 `catsProvider` / `habitsProvider` 同步获取，不再调用不存在的 Service 方法。
**理由**：架构审查发现原函数调用了 3 个未在 CompletionRateService 中定义的方法（`allCatsTotalMinutes`、`activeHabitCount`、`averageGoalMinutes`）。重新划分数据获取职责：已有 Provider 提供的数据同步取，需要聚合计算的数据异步查并行执行。

### D45. SceneCard 放弃 const 构造

**日期**：2026-03-15
**决策**：SceneCard 模型不使用 `const` 构造函数，改用 `static final` 列表。
**理由**：`const` 构造函数要求所有字段编译期确定，而 `List<SceneEvent>` 作为复杂对象列表无法在 `const` 上下文中使用 `fromJson()` 逻辑。`static final` 牺牲微小的编译优化，换取 Phase 1（静态定义）和 Phase 3+（Remote Config 动态下发）的统一加载路径。

### D46. 叙事文本按场景卡拆分为 15 个文件

**日期**：2026-03-15
**决策**：叙事常量文件从 3 个区域文件（town/forest/ruins）改为 15 个场景卡文件（每卡一个），存放在 `lib/core/constants/adventure_dialogues/` 目录下。
**理由**：每张场景卡 8-10 事件 × 3 段文本 × 双语 ≈ 50-80 行/卡。按区域合并为 3 文件会导致单文件 240-300 行（虽未违反 800 行红线但不优雅），且修改某张卡时需要在大文件中定位。按场景卡拆分更符合单一职责原则。
