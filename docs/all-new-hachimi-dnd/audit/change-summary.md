# 编码前全面修复 — 变更摘要

> **日期**：2026-03-15
> **触发**：编码前五轮审计 + architect-reviewer 架构审查
> **范围**：`docs/all-new-hachimi-dnd/` 全目录（13 份文档）
> **总计**：19 项问题修复、10 项新决策（D47-D56）、2 份新文档

---

## 1. 新增文件

| 文件 | 用途 |
|------|------|
| `audit/ux-map.md` | 用户体验地图：产品定位、用户旅程、屏幕清单、状态机、情感设计、跨模块衔接检查 |
| `audit/change-summary.md` | 本文件：变更摘要 |

## 2. 修改文件及关键变更

### architecture/data-model.md（SSOT 根源修复，5 项）

1. **新增 §1.10 ActiveCondition 空壳模型**（D47）：`{String id, String type, int? remainingEvents}`，解除 Phase 1 编译阻塞
2. **SceneCard.region 统一为完整前缀命名**（D48）：`'town'` → `'cat_town'`，`'forest'` → `'misty_forest'`，`'ruins'` → `'ancient_ruins'`
3. **PrimaryCat.background 语义明确化**（D51）：Phase 1 默认 `'adventurer'`（非用户可选），Phase 3 提供 4 种可选背景
4. **SQLite DDL 补充 `active_conditions` 列**：`TEXT NOT NULL DEFAULT '[]'`
5. **stardustEarned 远端上限确认**：维持 30（D30），spec/08 将同步修正

### architecture/services-and-providers.md（接口层修复，6 项）

1. **AdventureBackend 拆分为 3 个独立接口**（D49）：`PrimaryCatBackend`（2 方法）+ `DiceBackend`（5 方法）+ `AdventureBackend`（6 方法）
2. **Riverpod API 模式裁定**（D50）：所有新增有状态 Provider 统一使用 `NotifierProvider` + `Notifier<T>`
3. **primaryCatAbilitiesProvider 类型安全修复**：`Future.wait` + `as` 强转改为分别 await 并标注类型
4. **PityState 注释修正**：删除"App 重启重置"描述，引用 D43（持久化到 AdventureProgress）
5. **设备 ID 策略补充**（D54）：使用 UUID v4，App 生命周期内存缓存
6. **BackendRegistry 更新**：从 1 个接口字段扩展为 3 个

### decisions/log.md（10 项新决策）

| 决策 | 核心内容 |
|------|---------|
| D47 | ActiveCondition 空壳定义，Phase 2 启用 |
| D48 | region 值统一完整前缀命名 |
| D49 | AdventureBackend 拆分为 3 个独立接口 |
| D50 | 新增 Provider 统一 NotifierProvider |
| D51 | adventurer 为 Phase 1 默认背景 |
| D52 | 属性计算 = Provider 编排 + 静态公式方法 |
| D53 | crash 恢复以 D40 事务原子性为准 |
| D54 | 设备 ID 使用 UUID v4 |
| D55 | 叙事文本目标语言 15 → 5 |
| D56 | 三个计算 Service SSOT 归属 spec/02 |

### spec/01-primary-cat.md（3 项）

1. **PrimaryCatAbilities 从 extension getter 改为 class 静态方法**（D52）
2. **3 个 Service 定义去重**（D56）：删除 Service 表格，改为引用 spec/02
3. **新增 background bonus 层**：`_applyBackgroundBonus()` 静态方法 + `_backgroundBonusMap`

### spec/02-dnd-attributes.md（2 项）

1. **新增 SSOT 归属声明**（D56）：明确为 3 个计算 Service 的唯一权威定义
2. **`averageForAllCats` 签名修复**：补充 `String uid` 参数

### spec/03-dice-engine.md（2 项）

1. **DiceRollNotifier 改用 NotifierProvider**（D50）
2. **rollAll() 补充 habitCategory 参数**

### spec/04-adventure.md（5 项）

1. **SceneCard.region 引用 D48**
2. **AdventureProgress 模型同步**：补充 `activeConditions`（D47）、`pityConsecutiveFailures`、`pityConsecutiveNonCrits`、`activeDeviceId`
3. **AdventureNotifier 改用 NotifierProvider**（D50）
4. **叙事文本语言数修正**：15 → 5（D55），总条数 8,460 → 2,640
5. **新增 §8.5 冒险中伙伴猫删除处理**：冒险继续、bonus 移除、快照不变

### spec/05-party-and-class.md（1 项）

1. **新增 §9.4 XP 系统共存说明**：现有 XP（成就/进化）与冒险 XP（等级/区域）两套独立

### spec/06-economy.md（1 项）

1. **代码层 gold → coins 统一**（D41）：Remote Config key、Dart 常量名

### spec/08-operational.md（4 项）

1. **删除两阶段结算描述**（D53）：以 D40 事务原子性为唯一方案
2. **stardustEarned 上限 20 → 30**（D30）
3. **Guest 迁移 UNIQUE 冲突处理策略**：注册账号数据优先，Guest 数据标记废弃
4. **新增 §7/§8 Phase 1 前置改造**：ActionType.tryFromValue() 改造范围 + 影响评估

### spec/11-social-and-origins.md（2 项）

1. **新增 adventurer 默认值说明**（D51）：Phase 1 默认、无属性加成
2. **NPC 互动检定公式明确**：使用完整检定公式（含伙伴猫 bonus）

### README.md（4 项）

1. **关键决策表新增 D49/D50/D52**
2. **i18n 文本数量修正**：564 段 × 15 语言 → 528 段 × 5 语言
3. **Backend 接口数更新**：8 → 10
4. **新增 audit/ 目录导航**

---

## 3. 一致性检查清单

| 检查项 | 状态 |
|--------|------|
| data-model.md 的 9+1 个模型与所有 spec 引用一致 | ✅ 已对齐 |
| region 值在 data-model.md 和 spec/04 中一致 | ✅ 统一为完整前缀 |
| stardustEarned 上限在 data-model.md 和 spec/08 中一致 | ✅ 统一为 30 |
| 3 个计算 Service 的 SSOT 归属明确 | ✅ spec/02 |
| PrimaryCatAbilities 实现方式文档间一致 | ✅ 统一为 Provider 编排 + 静态方法 |
| Riverpod API 模式在所有 Provider 定义中一致 | ✅ NotifierProvider |
| background 默认值语义在 spec/01, spec/11, data-model.md 中一致 | ✅ adventurer = 默认 |
| PityState 持久化描述在 spec/03, services-and-providers.md, decisions/log.md 中一致 | ✅ 持久化到 AdventureProgress |

## 4. 编码时仍需确认的事项

| 事项 | 说明 | 优先级 |
|------|------|--------|
| `ActionType.fromValue()` 所有调用点审查 | spec/08 新增了改造范围说明，编码时需逐一验证 | Phase 1 首个 PR |
| `fl_chart` 8.x 与 Flutter 3.41 兼容性 | 需要 `flutter pub get` 实际验证 | Phase 1 |
| `flame_riverpod` 与 Riverpod 3.x 兼容性 | Phase Art 阶段前置检查 | Phase Art |
| 9 张场景卡事件内容填充 | 迷雾森林 4 张 + 远古遗迹 5 张 | Phase 2 内容冲刺 |
| Rive 美术资源制作 | 替换 ClanGen 精灵（D9） | Phase Art |

---

## 5. 下一步行动建议

1. **Phase 1 首个 PR**：`ActionType.tryFromValue()` 改造（D38 + spec/08 §7/§8）
2. **Phase 1 PR 2**：PrimaryCat 模型 + SQLite 表 + PrimaryCatService
3. **Phase 1 PR 3**：StarterSelectionScreen 五步创建仪式
4. **Phase 1 PR 4**：三个计算 Service（CompletionRate/Streak/Coverage）
5. **Phase 1 PR 5**：属性 extension + primaryCatAbilitiesProvider
6. **Phase 2 开始前**：填充 9 张待填充场景卡的事件内容
