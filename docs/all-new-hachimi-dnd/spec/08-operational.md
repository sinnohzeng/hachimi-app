# 运营级规格（离线、分析、无障碍、性能、测试、安全）

> SSOT for v2.0 DnD 功能的非功能性需求：离线行为、数据分析、无障碍、性能、测试策略和安全性。
> **Status:** Draft
> **Evidence:** `lib/services/local_database_service.dart`、`lib/core/observability/`
> **Related:** 所有 spec 文件
> **Changelog:** 2026-03-15 — 初版（整合自开发前终检 M1-M7）

---

## 1. 离线行为与错误处理

### 1.1 离线优先原则

Hachimi 采用 **SQLite-first** 架构（已实现）。所有 DnD 新功能必须遵循：

| 操作 | 离线行为 | 在线同步 |
|------|---------|---------|
| 创建主哈基米 | ✅ 写入 SQLite 即时生效 | 后台通过 LedgerChange 同步到 Firestore |
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
| Firestore 同步失败 | 静默重试（指数退避） | 无感知（离线优先） |
| 骰子检定中 App crash | 下次启动检测未完成的检定 → 自动重新结算 | "上次检定已自动完成" |
| 冒险中 App crash | AdventureProgress 状态保持 active | 用户继续未完成的冒险 |
| 数据损坏 | SQLite integrity_check → 自动重建 | "数据正在恢复..."（已有机制） |

### 1.3 多设备冲突解决

| 冲突场景 | 解决策略 |
|---------|---------|
| 两设备同时创建主哈基米 | Firestore `primaryCat` 单文档，last-write-wins |
| 两设备同时修改队伍 | `updatedAt` 时间戳，latest wins |
| 两设备同时进行冒险 | 每个设备维护独立的本地冒险状态。Firestore 同步时以 `startedAt` 最新的为准 |
| 两设备的骰子数量不一致 | LedgerChange 重放 → 收敛到一致状态 |

> **简化决策**：当前无真实多设备用户场景。以上策略足够，不需要 CRDTs 或复杂冲突解决。

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
| Rive 猫咪动画 | 静态替代：动画关闭时显示静态猫咪头像 |
| 星级评价 | `Semantics` label："三星中的两星" |
| 颜色编码 | 所有依赖颜色的信息同时使用图标/文字标注（色盲友好） |

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
| 骰子 d20 随机数 | 客户端 `Random.secure()` | Firestore 规则验证 `naturalRoll` 在 1-20 范围 |
| 属性修正值 | 客户端 extension | 不验证（纯展示，不影响其他用户） |
| 星尘/金币余额 | 客户端 materialized_state | Firestore 规则验证 `amount >= 0` |
| 冒险结果 | 客户端 DiceEngineService | DiceResult 写入 Firestore 后不可修改（`allow update: false`） |

### 6.2 安全决策

> **决策**：当前阶段不引入服务端验证（Cloud Function）。理由：
> 1. 没有 PvP/排行榜，作弊不影响其他用户
> 2. 单人自我关怀应用，作弊 = 自欺欺人
> 3. Cloud Function 增加运维成本和延迟
>
> **Phase 4+ 考虑**：如果未来引入社交/排行榜功能，需要 Cloud Function 验证骰子结果。

### 6.3 Firestore 安全规则增强

在现有规则基础上补充：

```js
// 验证 DiceResult 值域合法性
match /diceResults/{resultId} {
  allow create: if request.auth.uid == uid
    && request.resource.data.naturalRoll >= 1
    && request.resource.data.naturalRoll <= 20
    && request.resource.data.stardustEarned >= 0
    && request.resource.data.stardustEarned <= 20;  // 最大 15 + 场景奖励
}

// 验证金币/星尘不为负
match /materializedState/{key} {
  allow update: if request.auth.uid == uid
    && (key != 'gold' || request.resource.data.value >= 0)
    && (key != 'stardust' || request.resource.data.value >= 0);
}
```

---

## 7. 验收标准

### 离线
- [ ] 断网后完成完整冒险流程（选场景→投骰子→完成）
- [ ] 联网后数据正确同步到 Firestore
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
- [ ] Firestore 规则拒绝 naturalRoll > 20 或 < 1 的写入
- [ ] 金币/星尘余额不可被设为负数
