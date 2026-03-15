# Hachimi v2.0 DnD 融合 — 文档驱动开发

> 本目录是 v2.0 DnD 融合设计的 **SSOT（Single Source of Truth，单一真值来源）**。
> 所有设计变更必须 **先更新文档，再编写代码**。
>
> **Status:** Active
> **Changelog:** 2026-03-15 — 从三份调研报告 + 规格书草稿整合而成

---

## 核心约束

| 约束 | 说明 |
|------|------|
| 工具为主，游戏为辅 | 打开 App 到开始专注 ≤ 3 次点击 |
| V1 不依赖实时 AI | 所有叙事/对话预生成为本地模板 |
| 胶水编程 | 拥抱成熟开源轮子（Rive/Flame/fl_chart 等），写好胶水 |
| 协议红线 | 所有依赖必须开源可商用（MIT/Apache/BSD）。拒绝 GPL/CC-NC |
| 后端可切换 | 通过现有 backend 抽象层保留切换能力 |
| SRD 5.2.1 CC-BY-4.0 | 仅使用 SRD 开放规则，署名即可商用 |
| 美术资产原创 | ClanGen 精灵图（CC BY-NC）不可商用，必须替换为原创 |

## 零惩罚红线（不可违反）

作为自我关怀类工具，以下规则绝对不可违反：

1. 猫咪永远不会死亡、消失或受伤
2. 属性永远不会下降（只会停滞或缓慢增长）
3. 失败的骰子检定仍然给奖励（最少 1⭐）
4. 断连不清零（连击暂停，不回到 0）
5. 不打开 App 不会有任何负面后果
6. 冒险没有时间限制
7. 任何"劣势"机制都是短期的，且不影响核心进度

## 关键决策

| 决策 | 选择 | 理由 | 详见 |
|------|------|------|------|
| 猫咪架构 | 主哈基米 + 伙伴猫（路线 C） | 兼具 Finch 情感深度和 Habitica 习惯广度 | [decisions/log.md](decisions/log.md) |
| Tab 结构 | 保持 3 Tab | 导航简洁，冒险功能通过 Tab 3 子路由承载 | [spec/07-ui-and-navigation.md](spec/07-ui-and-navigation.md) |
| 渲染引擎 | CustomPainter + PNG | 零新依赖，现有管线够用 | [decisions/log.md](decisions/log.md) |
| 金币经济 | **待重新设计** | 现有 10 币/分钟通胀严重 | [spec/06-economy.md](spec/06-economy.md) |

---

## 文档导航

### spec/ — 产品规格（"建什么"）

每个文件对应一个可独立交付的功能边界。

| 文件 | 内容 | 状态 | Phase |
|------|------|------|-------|
| [01-primary-cat.md](spec/01-primary-cat.md) | 主哈基米：御三家 + 属性 + 心情 | Draft | 1 |
| [02-dnd-attributes.md](spec/02-dnd-attributes.md) | DnD 六维属性：公式 + 数值曲线 | Draft | 1 |
| [03-dice-engine.md](spec/03-dice-engine.md) | 骰子：保底 + 检定 + 动画 | Draft | 2 |
| [04-adventure.md](spec/04-adventure.md) | 冒险场景卡：进度 + 难度 + 叙事 | Draft | 2 |
| [05-party-and-class.md](spec/05-party-and-class.md) | 队伍 + 职业 + 用户等级 | Draft | 3 |
| [06-economy.md](spec/06-economy.md) | 双币种经济 | Draft | 3 |
| [07-ui-and-navigation.md](spec/07-ui-and-navigation.md) | 导航 + 酒馆 + Onboarding | Draft | 1-3 |

### architecture/ — 技术架构（"怎么建"）

代码的直接契约。修改数据模型或接口前必须先更新这里。

| 文件 | 内容 |
|------|------|
| [data-model.md](architecture/data-model.md) | 8 个新 Dart 模型 + SQLite Schema + Firestore 规则 + Ledger 类型 |
| [services-and-providers.md](architecture/services-and-providers.md) | 6 Service + 5 Provider + Backend 接口 + 文件变更清单 |
| [art-pipeline.md](architecture/art-pipeline.md) | 美术资源 + AI 工具链 + 技术选型 + 叙事文本工程化 |

### research/ — 调研归档（"为什么这么决定"）

只读参考。设计决策的证据链。

| 文件 | 内容 |
|------|------|
| [comprehensive-analysis.md](research/comprehensive-analysis.md) | 竞品 + 游戏化心理学 + 数值体系 + 技术方案 |
| [party-architecture.md](research/party-architecture.md) | 主哈基米 + 伙伴猫架构的心理学论证 |
| [finch-teardown.md](research/finch-teardown.md) | Finch 技术栈逆向分析 + Flutter 对等实现 |
| [sources.md](research/sources.md) | 统一来源索引（S1-S67 + P1-P17 + R1-R30） |

### decisions/ — 决策日志

| 文件 | 内容 |
|------|------|
| [log.md](decisions/log.md) | 所有关键决策 + 理由 + 被否决的替代方案 + 审查记录 |

### srd/ — SRD 5.2.1 原始参考

D&D 5e 2024 System Reference Document，CC-BY-4.0 许可。

---

## 实施路线图

| Phase | 范围 | 预估周期 | 对应 Spec |
|-------|------|---------|-----------|
| 1 | 主哈基米 + 属性系统 + 导航改造 | 4-6 周 | 01, 02, 07 |
| 2 | 骰子引擎 + 冒险场景卡 | 6-8 周 | 03, 04 |
| 3 | 队伍 + 职业 + 经济 + 酒馆升级 | 4-6 周 | 05, 06, 07 |
| 4 | 美术资源 + 动画打磨 + 经济平衡 | 2-4 周 | — |

## DDD 工作流

```
1. 修改 spec/ 或 architecture/ 中的文档
2. 标记 spec 状态为 Ready
3. 实现代码
4. 验证通过后标记 spec 为 Done
5. 如果实现中发现设计问题 → 先更新文档再改代码
```
