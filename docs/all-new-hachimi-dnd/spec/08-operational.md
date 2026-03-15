# 运营级规格（离线、分析、无障碍、性能、测试、安全）

> SSOT for v2.0 DnD 功能的非功能性需求：离线行为、数据分析、无障碍、性能、测试策略和安全性。
> **Status:** Draft
> **Evidence:** `lib/services/local_database_service.dart`、`lib/core/observability/`
> **Related:** 所有 spec 文件
> **Changelog:**
> - 2026-03-15 — 初版（整合自开发前终检 M1-M7）
> - 2026-03-15 — 新增 retention day 定义（D33）；PityState 重启行为说明；减少动画规格；酒馆 Semantics 无障碍；多设备过期锁建议

---

## 1. 离线行为与错误处理

### 1.1 离线优先原则

Hachimi 采用 **SQLite-first** 架构（已实现）。所有 DnD 新功能必须遵循：

| 操作 | 离线行为 | 在线同步 |
|------|---------|---------|
| 创建主哈基米 | ✅ 写入 SQLite 即时生效 | 后台通过 LedgerChange 同步到远端 |
| 骰子获取 | ✅ 写入 local_pending_dice | 后台同步 |
| 骰子投掷 | ✅ 检定结果写入 local_dice_results | 后台同步 |
| 冒险进度 | ✅ 更新 local_adventure_progress | 后台同步 |
| 队伍更换 | ✅ 更新 local_party | 后台同步 |
| 星尘/金币变更 | ✅ 更新 materialized_state | 后台同步 |
| 购买物品 | ✅ 扣款 + 装备变更均在 SQLite | 后台同步 |

### 1.2 错误处理策略

| 错误类型 | 处理方式 | 用户感知 |
|---------|---------|---------|
| SQLite 写入失败 | 重试 1 次 → 显示 Toast 错误 | "保存失败，请重试" |
| 远端同步失败 | 静默重试（指数退避） | 无感知（离线优先） |
| 骰子检定中 App crash | 下次启动检测未完成的检定 → 自动重新结算 | "上次检定已自动完成" |

> **两阶段结算**：检定过程分两步 ① 计算 DiceResult 并写入 SQLite、② 发放星尘并更新 materialized_state。若 ① 完成但 ② 未执行（crash），下次启动时检查是否有 `DiceResult` 记录但对应星尘未更新，自动执行 ②。用户在日志中看到"上次检定奖励已补发"提示。
| 冒险中 App crash | AdventureProgress 状态保持 active | 用户继续未完成的冒险 |
| 数据损坏 | SQLite integrity_check → 自动重建 | "数据正在恢复..."（已有机制） |

### 1.3 多设备冲突解决

| 冲突场景 | 解决策略 | 理由 |
|---------|---------|------|
| 两设备同时创建主哈基米 | `primaryCat` 单记录，last-write-wins | 极低概率事件，acceptably lossy |
| 两设备同时修改队伍 | `updatedAt` 时间戳，latest wins | 队伍变更无累积状态 |
| 两设备同时进行冒险 | **设备锁定**：冒险开始时写入 `deviceId`，其他设备只读 | 避免进度丢失（见下文） |
| 两设备的骰子数量不一致 | LedgerChange 重放 → 收敛到一致状态 | Ledger 模式天然支持 |

> **LedgerChange 格式参考**：DnD 新增的 18 个 ActionType（详见 architecture/data-model.md §4）遵循现有 Ledger 模式。每条 LedgerChange 包含 `{type, payload, timestamp, deviceId}`，同步时按 timestamp 顺序重放。

#### 冒险设备锁定机制

**问题**：如果两台设备同时推进同一冒险，以 `startedAt` 最新为准会丢失旧设备的进度。

**解决方案**：
1. `AdventureProgress` 新增 `activeDeviceId` 字段（本设备的 UUID）
2. 冒险开始时，`activeDeviceId` 写入当前设备 ID
3. 其他设备检测到 `activeDeviceId != 本设备` 时：
   - 显示提示："此冒险正在另一台设备上进行"
   - 用户可选择"在此设备继续"（覆盖 `activeDeviceId`）或"返回"
4. 选择"在此设备继续"时，从远端拉取最新的 `AdventureProgress` 覆盖本地

**简化决策**：当前无真实多设备用户场景。设备锁定 + 用户确认覆盖足够应对，不需要 CRDTs。

> **过期锁建议**：`activeDeviceId` 可配合 `lastHeartbeat` 时间戳使用。
> 若 `lastHeartbeat` 超过 24 小时，其他设备可自动接管（无需弹窗确认）。
> Phase 1 不实现——仅使用用户主动覆盖模式。Phase 2+ 可根据实际多设备使用率决定是否引入。

> **数据模型**：`activeDeviceId` 字段已定义在 [data-model.md](../architecture/data-model.md) §1.4 的 `AdventureProgress` 模型中。

### 1.4 远端验证规则部署检查清单

DnD 功能依赖新的远端验证规则（`primaryCat`、`pendingDice`、`diceResults`、`adventureProgress`、`party`、`sceneDifficultyUnlock`）。

**上线前必须执行**：

1. 确认所有新增集合的验证约束已部署（详见 [data-model.md](../architecture/data-model.md) §3）
2. 验证 `diceResults` 的不可篡改约束（创建后不可更新/删除）
3. 验证 `gold` 和 `stardust` 的非负约束

> 具体部署命令由各 Backend 实现文档提供。Firebase 参考：`firebase deploy --only firestore:rules --project hachimi-ai`

**回滚方案**：各后端平台均支持规则版本历史，可回滚到上一版本。

---

## 2. 数据分析（Analytics）事件

### 2.1 DnD 核心事件清单

所有事件遵循现有 `AnalyticsBackend` 接口。事件名定义在 `lib/core/constants/analytics_events.dart`。

| 事件名 | 触发时机 | 参数 |
|--------|---------|------|
| `primary_cat_created` | 完成御三家选择 | `archetype`, `personality` |
| `dice_earned` | 专注完成获得骰子 | `cat_id`, `focus_minutes` |
| `dice_rolled` | 投掷骰子 | `natural_roll`, `outcome`, `dc` |
| `dice_critical_success` | 掷出 nat 20 或超额成功 | `natural_roll`, `total`, `dc` |
| `adventure_started` | 开始冒险 | `scene_card_id`, `difficulty`, `party_size` |
| `adventure_completed` | 完成冒险 | `scene_card_id`, `star_rating`, `success_rate` |
| `class_selected` | 选择职业 | `class_name`, `user_level` |
| `feat_selected` | 选择专长 | `feat_name`, `user_level` |
| `item_purchased` | 购买物品 | `item_id`, `currency`, `price` |
| `cat_evolved` | 猫咪进化 | `cat_id`, `from_stage`, `to_stage` |
| `party_formed` | 组建队伍 | `companion_count` |
| `discovery_triggered` | 被动感知发现事件 | `passive_perception`, `discovery_tier` |
| `level_up` | 冒险等级提升 | `new_level`, `total_xp` |
| `tavern_interaction` | 酒馆互动（喂食/玩耍） | `item_type`, `cat_id` |
| `user_retention_day_n` | 第 N 天活跃（N=1,3,7,14,30） | `{day: N}` |

> **"天"的定义（D33）**：有打开 App 的日历日。与行业标准 DAU（Daily Active Users）定义一致。
> 例如：用户 3/1 安装，3/1、3/3、3/7 打开 App → day_1 ✓, day_3 ✓, day_7 ✓。
| `item_purchase_failed` | 购买物品时余额不足 | `{item_id, price, balance}` |
| `sync_failure` | 远端同步失败（累计 3 次以上） | `{error_type, retry_count}` |
| `adventure_abandoned` | 用户放弃冒险 | `{scene_card_id, progress_pct}` |
| `dice_overflow_total` | 本月累计骰子溢出数 | `{monthly_count}` |

### 2.2 漏斗分析

```
新用户注册 → 创建主哈基米 → 创建首个习惯 → 首次专注 → 获得首枚骰子 → 首次投掷 → 首次冒险
```

关注每一步的转化率，识别流失点。

---

## 3. 无障碍（Accessibility）

### 3.1 核心要求

| 组件 | A11y 处理 |
|------|----------|
| 属性雷达图（fl_chart） | 添加 `Semantics` label："力量 15，敏捷 12，体质 18..." |
| 骰子动画 | 提供"跳过动画"选项（Settings → 无障碍 → 关闭动画） |

> **减少动画**：骰子动画（spec/03 §13）必须检查用户的"减少动画"设置。
> 若启用，跳过 Tumble + Lock 阶段，直接以 0.3s fade-in 显示结果。
| Rive 猫咪动画 | 静态替代：动画关闭时显示静态猫咪头像 |
| 星级评价 | `Semantics` label："三星中的两星" |
| 颜色编码 | 所有依赖颜色的信息同时使用图标/文字标注（色盲友好） |

> **无障碍**：酒馆背景图 wrapped in `Semantics(label: '酒馆内部，[白天/夜晚]', excludeSemantics: true)`。
> 装饰性精灵使用 `excludeSemantics: true`（纯装饰，不影响屏幕阅读器）。

### 3.2 Settings 新增

```
设置 → 无障碍
  - [ ] 减少动画（关闭骰子翻滚/进化动画，显示即时结果）
  - [ ] 高对比度模式（增强文字/背景对比）
```

---

## 4. 性能预算

### 4.1 帧率目标

| 场景 | 目标 FPS | 测试设备 |
|------|---------|---------|
| Flutter UI（Tab 1/3） | 60 fps | vivo V2405A |
| Rive 猫咪动画（单只） | 60 fps | vivo V2405A |
| Rive 多只猫（队伍 3 只） | 30 fps | vivo V2405A |
| Flame 酒馆场景 | 30 fps | vivo V2405A |

> **性能目标定义**：30 fps 为**最低可接受帧率**（vivo V2405A 低端设备基准）。中端设备（如 Pixel 6a）目标 60 fps。性能测试应同时在两类设备上验证。
| 骰子 CustomPainter 动画 | 60 fps | vivo V2405A |

### 4.2 内存预算

| 资源 | 上限 |
|------|------|
| 单个 .riv 文件 | < 500 KB |
| 所有 Rive 资产总和 | < 5 MB |
| Flame 酒馆场景瓦片 | < 2 MB |
| i18n 叙事 JSON（单语言） | < 200 KB |

### 4.3 启动时间

| 指标 | 目标 |
|------|------|
| 冷启动到首屏 | < 3 秒 |
| 主哈基米属性计算 | < 200 ms |
| 骰子检定计算 | < 50 ms |

### 4.4 性能降级策略

| 场景 | 检测条件 | 降级方案 |
|------|---------|---------|
| 3 只 Rive 猫同屏 <30fps | `PerformanceOverlay` 检测连续 5 秒低于 30fps | 切换到 PNG 精灵渲染（复用现有 `PixelCatRenderer`） |
| Flame 酒馆场景 <20fps | 同上 | 降级为静态背景图 + Flutter Widget 叠加 |
| 冷启动 >5 秒 | 启动计时 | 延迟加载 Rive 资源（先渲染骨架屏，后加载 .riv 文件） |

降级阈值通过 Remote Config 参数 `rive_fps_threshold`（默认 30）和 `flame_fps_threshold`（默认 20）控制。

> **降级不可逆**：一旦降级到 PNG 模式，当前 App 生命周期内不再尝试切回 Rive。用户重启 App 后重新检测。

---

## 5. 测试策略

### 5.1 Phase 间 Gate Criteria

每个 Phase 完成时必须通过以下验证才能进入下一 Phase：

**Phase 1 Gate（主哈基米 + 属性）**：
- [ ] 主哈基米创建/读取/展示正常
- [ ] 6 维属性计算边界值全部通过
- [ ] Tab 3 冒险者档案正确显示
- [ ] Onboarding 流程完整走通
- [ ] 离线创建主哈基米 → 联网后同步成功

**Phase 2 Gate（骰子 + 冒险）**：
- [ ] 1000 次骰子模拟通过保底验证

> **PityState 重启行为**：保底计数器仅存内存（不持久化到 SQLite）。App 重启后归零。
> 冒险中重启会丢失保底进度。这是有意的设计取舍——记录在 decisions/log.md。

> **测试用例伪代码**：
> ```dart
> test('pity system guarantees floor after 3 failures', () {
>   final rng = Random(42);
>   final pity = PityState();
>   int belowTenAfterPity = 0;
>   for (var i = 0; i < 1000; i++) {
>     final raw = rng.nextInt(20) + 1;
>     // Simulate 3 consecutive failures
>     pity.consecutiveFailures = 3;
>     final result = applyPity(raw, pity);
>     if (result < 10) belowTenAfterPity++;
>   }
>   expect(belowTenAfterPity, 0);
> });
> ```
- [ ] 冒险完整流程（选场景→投骰子→完成→评星）
- [ ] 离线冒险 → 联网后数据同步
- [ ] 15 张场景卡的叙事文本正确加载（至少英文+中文）
- [ ] 骰子动画在 vivo V2405A 上流畅（60fps）

**Phase 3 Gate（队伍 + 经济）**：
- [ ] 队伍锁定机制正常
- [ ] 金币收支平衡验证（30 天模拟）
- [ ] 星尘收支平衡验证
- [ ] 所有 20 个 DnD 成就可触发
- [ ] Remote Config 金币参数热更新生效

### 5.2 单元测试覆盖要求

| 模块 | 最低覆盖率 | 重点 |
|------|-----------|------|
| DiceEngineService | 95% | 保底机制、优势/劣势、修正值计算 |
| AdventureService | 90% | 状态机转换、星级计算、事件池抽取 |
| Attribute Extensions | 95% | 边界值、阶段上限、公式正确性 |
| CompletionRate/Streak/Coverage | 90% | SQL 查询正确性、时区处理 |
| Economy (金币/星尘) | 90% | 原子操作、溢出处理 |

### 5.3 回滚策略

| 风险 | 回滚方案 |
|------|---------|
| Rive 运行时换装 bug | 降级到静态 PNG 头像（保留 PixelCatRenderer 代码直到 Phase Art 完成） |
| Flame 性能不达标 | Tab 2 退回纯 Flutter UI（Rive 猫咪 + Stack 布局） |
| 金币经济失衡 | Remote Config 热调收入率和物品价格 |
| i18n 翻译质量差 | 默认回退到英文文本 |

---

## 6. 安全性

### 6.1 客户端计算 vs 服务端验证

| 计算 | 执行位置 | 验证方式 |
|------|---------|---------|
| 骰子 d20 随机数 | 客户端 `Random.secure()` | 远端验证规则校验 `naturalRoll` 在 1-20 范围 |
| 属性修正值 | 客户端 extension | 不验证（纯展示，不影响其他用户） |
| 星尘/金币余额 | 客户端 materialized_state | 远端验证规则校验 `amount >= 0` |
| 冒险结果 | 客户端 DiceEngineService | DiceResult 写入远端后不可修改（`allow update: false`） |

### 6.2 安全决策

> **决策**：当前阶段不引入服务端验证（Cloud Function）。理由：
> 1. 没有 PvP/排行榜，作弊不影响其他用户
> 2. 单人自我关怀应用，作弊 = 自欺欺人
> 3. Cloud Function 增加运维成本和延迟
>
> **Phase 4+ 考虑**：如果未来引入社交/排行榜功能，需要 Cloud Function 验证骰子结果。

### 6.3 远端验证约束增强

在基础约束（[data-model.md](../architecture/data-model.md) §3）之上，补充以下增强验证：

| 集合 | 字段 | 约束 | 说明 |
|------|------|------|------|
| `diceResults` | `naturalRoll` | `∈ [1, 20]` | d20 值域 |
| `diceResults` | `stardustEarned` | `∈ [0, 20]` | 单次最大 15 + 场景奖励 |
| `materializedState` | `gold` | `≥ 0` | 金币不可为负 |
| `materializedState` | `stardust` | `≥ 0` | 星尘不可为负 |

> 具体验证语法由各 Backend 实现提供。参考实现见 `firestore.rules`。

---

## 7. 验收标准

### 离线
- [ ] 断网后完成完整冒险流程（选场景→投骰子→完成）
- [ ] 联网后数据正确同步到远端
- [ ] App crash 后冒险进度不丢失

### Analytics
- [ ] 14 个核心事件正确触发（Firebase Analytics 控制台可见）
- [ ] 漏斗数据可在 Firebase 中查看

### 无障碍
- [ ] TalkBack（Android）可读取雷达图数值
- [ ] "减少动画"选项关闭所有非必要动画

### 性能
- [ ] vivo V2405A 上 Rive 单猫动画 ≥ 60fps
- [ ] 冷启动 < 3 秒（Release build）

### 安全
- [ ] 远端验证规则拒绝 naturalRoll > 20 或 < 1 的写入
- [ ] 金币/星尘余额不可被设为负数
- [ ] **离线骰子溢出**：离线状态下 pending_dice COUNT ≥ 20 时，溢出金币写入本地 materialized_state，联网后同步
- [ ] **Crash 恢复一致性**：App crash 后重启，检查 local_dice_results 中是否有对应 stardust 未更新的记录，自动补发
- [ ] **SQLite/远端一致性**：sync 完成后，local_primary_cat 和远端 primaryCat 的关键字段一致（可通过调试面板手动触发校验）
