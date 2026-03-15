# Hachimi v2.0 全方位调研汇总报告

> **版本**：综合调研报告 v1.0 | **汇编日期**：2026-03-14
> **信息来源**：两轮独立深度调研 + 上传 PRD 文档 + SRD 5.2.1 原始 PDF 交叉验证
> **报告定位**：将所有调研结论、设计建议、技术方案、决策依据汇总为一份可执行参考文档

---

## 目录

1. [调研来源说明与信息溯源](#一调研来源说明与信息溯源)
2. [项目现状分析](#二项目现状分析)
3. [SRD 5.2.1 法律合规与机制深度解析](#三srd-521-法律合规与机制深度解析)
4. [竞品深度拆解（六款核心产品）](#四竞品深度拆解)
5. [游戏设计参考分析（星露谷 / 开罗 / BG3）](#五游戏设计参考分析)
6. [猫系游戏机制拆解（Neko Atsume / Cats & Soup / CryptoKitties）](#六猫系游戏机制拆解)
7. [游戏化心理学与学术依据](#七游戏化心理学与学术依据)
8. [产品架构设计（页面结构与交互流程）](#八产品架构设计)
9. [核心系统设计（猫咪 + DND + 经济）](#九核心系统设计)
10. [数值设计体系](#十数值设计体系)
11. [美术资源与 AI 生成方案](#十一美术资源与-ai-生成方案)
12. [Flutter 技术架构](#十二flutter-技术架构)
13. [决策框架：该做与不该做](#十三决策框架)
14. [功能路线图](#十四功能路线图)
15. [完整信息来源索引](#十五完整信息来源索引)

---

## 一、调研来源说明与信息溯源

本报告融合了以下三类信息来源，所有关键结论均标注出处编号（如 [S1]），完整链接见第十五节。

### 1.1 第一轮调研（本会话）

通过 Deep Research 工具进行的大规模联网调研，覆盖了以下领域：

- **D&D SRD 5.2.1 规则文档**：直接抓取 D&D Beyond 官方 PDF（361 页）及 5e24srd.com 在线版 [S1][S2][S3]
- **竞品分析**：Habitica（Wikipedia + Trophy 案例研究 + Trustpilot 评论）[S4][S5][S6]、Forest（Appcues + AppSamurai + Trophy 案例研究）[S7][S8][S9]、Finch（Eat Proteins 评测 + Medium UX 拆解 + ScreensDesign + Naavik 行业分析）[S10][S11][S12][S13]
- **猫系游戏**：Neko Atsume（Wikipedia + Medium 设计拆解 × 2 篇 + ResearchGate 学术论文）[S14][S15][S16][S17]、Cats & Soup（Sensor Tower + CatSwoppr 评测 + Wiki）[S18][S19][S20]
- **BG3 / DND**：Wikipedia + Game Developer 分析 + Gaming Respawn 骰子 UI 评测 [S21][S22][S23]
- **开罗游戏**：Entertainment Analytical 深度分析 + Kairosoft Wiki + Steam 评测 [S24][S25][S26]
- **星露谷物语**：Stardew Valley Forums 精灵图规格 + Sprite-AI 风格指南 [S27][S28]
- **AI 像素画工具**：PixelLab 官网 + Bytethesis 评测 + Aiarty 工具对比 + Aseprite GitHub [S29][S30][S31][S32]
- **Flutter 技术栈**：Flame Engine 文档 + Rive vs Lottie 对比（Medium）+ pub.dev 包页面 [S33][S34][S35][S36]
- **游戏化学术研究**：Springer SDT 论文 + ScienceDirect 系统综述 + 过度合理化效应（Wikipedia）[S37][S38][S39]
- **猫咪头像生成器**：David Revoy cat-avatar-generator（GitHub + Framagit）+ DiceBear + RoboHash [S40][S41][S42]

### 1.2 第二轮调研（另一个会话，用户上传 PRD）

该 PRD 文档的信息来源包括：

- Forest App 游戏化分析：GoodUX Appcues [P1] + UX Planet [P2]
- Habitica 视频拆解 [P3]
- 星露谷物语设计分析：RestfulCoder YouTube [P4] + ConcernedApe 专访 Mental Nerd [P5]
- DND 5e 能力值规则：5eSRD.com [P6]
- SRD v5.2.1 官方页面：D&D Beyond [P7]
- SRD 5.1→5.2.1 转换指南 YouTube [P8]
- 开罗游戏设计分析：Indienova 独立游戏开发 [P9]
- AI 美术工作流：Claude + Gemini 工作流 YouTube [P10]
- PixelLab MCP + Claude Code YouTube [P11]
- Pixel Art Creator MCP Market [P12]
- SVGMaker.io AI 工具 [P13] + 2026 AI SVG 工具对比 [P14]
- VectoSolve AI SVG 动画工具 [P15]
- 星露谷像素风格讨论：Reddit r/PixelArt [P16]
- Forest App 评测：Voxel Hub [P17]

### 1.3 原始文档直接验证

- **SRD_CC_v5.2.1.pdf**（用户上传，361 页）：直接校验了能力值修正公式、熟练加值表、技能检定规则、DC 等级、优势/劣势机制、20 级 XP 表等核心数据
- **GitHub 仓库状态**：经第一轮调研确认，`github.com/sinnohzeng/hachimi-app` 截至 2026 年 3 月为私有仓库，无法直接访问。PRD 中对代码的分析（离线优先架构、pixel-cat-maker、XP 公式等）来自另一会话的直接代码阅读

### 1.4 来源交叉验证说明

以下关键事实经过多源交叉验证：

| 事实 | 验证源 |
|------|--------|
| SRD 5.2.1 使用 CC-BY-4.0 许可证 | 上传 PDF 首页 + D&D Beyond 页面 [S1] + Tribality [S43] + Roll20 [S44] |
| 修正值公式 `floor((score-10)/2)` | 上传 PDF + 5e24srd.com [S2] + PRD [P6] |
| 熟练加值 +2（1级）→ +6（17级） | 上传 PDF + 5e24srd.com [S3] + dnd-wiki.org [S45] |
| Finch 月收入 $900K-2M | Naavik [S13] + FoxData [S46] + Medium 分析 [S47] |
| Finch 零惩罚机制 | Eat Proteins [S10] + Autonomous.ai [S48] + Yoga Journal [S49] |
| Forest 4000万+ 用户 | AppSamurai [S9] + Trophy [S8] |
| Habitica 2023 年移除公会/酒馆 | Trophy [S5] + Habi.app [S50] |
| 星露谷物语 16×16 瓦片尺寸 | Stardew Valley Forums [S27] + Sprite-AI [S28] |
| Neko Atsume 1000万+ 下载 | Wikipedia [S14] + Medium [S15] |
| PixelLab 支持 8 方向精灵图生成 | PixelLab 官网 [S29] + Bytethesis [S30] |

---

## 二、项目现状分析

### 2.1 已实现的核心能力（来自 PRD 代码审计）

根据上传 PRD 文档中对 GitHub 仓库的直接代码分析，当前 MVP 已具备：

**架构层**：
- 离线优先架构：SQLite 作为运行时单一事实来源（SSOT），Firebase Firestore 做远端同步——这是正确的基础设施决策，意味着后续的 DND 检定引擎可以纯 Dart 本地实现，无需依赖网络 [PRD 第二节]
- 技术栈：Flutter + Firebase + Riverpod + SQLite

**猫咪系统**：
- `pixel-cat-maker` 参数驱动精灵图系统，支持 15+ 外观参数
- 6 种性格（Lazy/Curious/Playful/Shy/Brave/Clingy）
- 4 个成长阶段（幼猫/少年猫/成年猫/长老猫）
- 心情系统（happy/neutral/lonely/missing）
- 精选猫算法：`score = recency×0.45 + mood×0.30 + growth×0.20 + today×0.05` [PRD §2]

**专注计时器**：
- 倒计时 + 秒表双模式
- Android Foreground Service 后台常驻
- 惩罚保护阈值：5 分钟

**经济系统（初步）**：
- XP 公式：`baseXp(分钟×1) + fullHouseBonus(+10)`，Remote Config 控制乘数
- 金币系统存在但无消费场景

### 2.2 关键缺失项

| 缺失模块 | 重要性 | 对应设计方案 |
|----------|--------|-------------|
| 货币消费系统 | 高 | 配件商店 + 家具系统（见第九节） |
| DND 属性体系 | 高 | 六维属性映射（见第九节 §9.2） |
| 配件/装备深度 | 高 | 代码中 `accessories` 字段已预留，需激活（见第九节 §9.1） |
| 猫屋互动场景 | 中 | 等距视角像素风房间 + 闲置动画（见第八节） |
| 任务/Quest 系统 | 高 | DND 探险地图（见第九节 §9.3） |
| 成就系统深度 | 中 | 扩充成就矩阵，参考 iBetter 模式 |
| 社交/联机 | 低 | Phase 4 考虑，非核心（见第十四节） |

### 2.3 决策依据

**为什么优先做 DND 属性而非社交？**

来自竞品数据的支持：Habitica 在 2023 年 8 月移除公会和酒馆社交功能后，用户社区经历了严重震荡 [S5][S50]——这说明社交是高维护成本、高风险模块。而 Finch 几乎没有社交功能（仅分享），却凭借深度的宠物养成系统达到了 $900K-2M/月的收入和 13M+ 下载 [S10][S13]。因此建议**先把单人深度做透，社交留到 Phase 4**。

---

## 三、SRD 5.2.1 法律合规与机制深度解析

### 3.1 法律状态（经 PDF 原文验证）

**许可证类型**：Creative Commons Attribution 4.0 International License（CC-BY-4.0）

**来源验证**：用户上传的 `SRD_CC_v5.2.1.pdf` 首页明确标注此许可。D&D Beyond 官方页面 [S1]、Tribality 报道 [S43]、Roll20 专题页 [S44]、Dungeons and Dragons Fan [S51] 均确认此许可。

**核心要点**：
- **不可撤销**：Wizards of the Coast 无法在未来撤回该许可 [S43][S51]
- **允许商业使用**：可在付费商业产品中自由使用 [S1]
- **允许改编**：可以修改规则以适配习惯打卡场景
- **唯一义务**：署名。推荐文本为：

> *"This work includes material from the System Reference Document 5.2.1 by Wizards of the Coast LLC, available at https://www.dndbeyond.com/srd. The SRD 5.2.1 is licensed under the Creative Commons Attribution 4.0 International License."*

**来源**：SRD PDF 首页 + D&D Beyond [S1]

### 3.2 SRD 包含的可用机制（经 PDF 原文确认）

| 机制类别 | 具体内容 | Hachimi 可用性 |
|----------|---------|---------------|
| 六项能力值 | STR/DEX/CON/INT/WIS/CHA + 修正值公式 | ✅ 核心系统 |
| 18 项技能 | Athletics、Acrobatics、Arcana、Perception 等 | ✅ 可映射为习惯子类 |
| d20 检定系统 | 1d20 + 修正值 + 熟练加值 ≥ DC | ✅ 奖励骰子系统 |
| 优势/劣势 | 投 2d20 取高/取低 | ✅ 连击奖励/中断惩罚 |
| 熟练加值 | +2（1级）→ +6（17级） | ✅ 随用户等级成长 |
| DC 难度等级 | DC 5（极易）→ DC 30（几乎不可能） | ✅ 设定习惯难度 |
| 12 个职业（各含 1 个子职业） | Fighter、Wizard、Cleric、Ranger 等 | ✅ 用户原型系统 |
| 20 级 XP 进度表 | 0 XP（1级）→ 355,000 XP（20级） | ✅ 参考但需重新平衡 |
| 被动感知 | 10 + WIS 修正值 | ✅ 被动发现机制 |
| 短休/长休 | 短休恢复部分、长休完全恢复 | ✅ 日/周回顾 |
| 专长（Feats） | 特殊能力选择 | ✅ 里程碑奖励 |
| 法术系统 | 施法位、法术等级 | ⚠️ 简化使用 |

**来源**：SRD_CC_v5.2.1.pdf 全文 + 5e24srd.com [S2][S3] + Roll20 Compendium [S52]

### 3.3 SRD 不包含的内容（禁止使用清单）

| 不可用内容 | 原因 | 替代方案 |
|-----------|------|---------|
| "Dungeons & Dragons" 商标/logo | 商标权，非 CC-BY 范围 | 使用"兼容第五版规则"表述 |
| Artificer 职业 | 不在 SRD 中 | 设计原创职业 |
| 大部分子职业（仅含 12 个） | 不在 SRD 中 | 自创子职业 |
| 标志性怪物（眼魔、夺心魔等） | 不在 SRD 中 | 自创猫咪探险怪物 |
| 命名角色（Strahd、Tiamat 等） | 不在 SRD 中 | 自创 NPC |
| 战役设定（被遗忘国度等） | 不在 SRD 中 | 自创世界观 |
| 所有官方美术 | 不在 CC-BY 范围 | AI 生成像素美术 |

**来源**：SRD PDF 法律声明 + Tribality [S43] + D&D Beyond Creator FAQ [P8]

### 3.4 核心公式（PDF 原文验证后的精确表述）

**修正值公式**（SRD 第 1 章）：
```
modifier = floor((ability_score - 10) / 2)
```

| 能力值 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|--------|----|----|----|----|----|----|----|----|----|----|-----|
| 修正值 | +0 | +0 | +1 | +1 | +2 | +2 | +3 | +3 | +4 | +4 | +5 |

**熟练加值表**（SRD 第 2 章）：

| 等级 | 1-4 | 5-8 | 9-12 | 13-16 | 17-20 |
|------|-----|-----|------|-------|-------|
| 熟练加值 | +2 | +3 | +4 | +5 | +6 |

**d20 检定核心公式**：
```
检定结果 = 1d20 + 能力修正值 + 熟练加值（如有） ≥ DC
```

**优势/劣势**：
- 优势：投 2d20，取较高值
- 劣势：投 2d20，取较低值
- 规则：如果同时拥有优势和劣势（无论各有几个），它们相互抵消，正常投 1d20

**DC 参考等级**（SRD 第 7 章）：

| DC 值 | 难度描述 | Hachimi 映射 |
|-------|---------|-------------|
| 5 | 极容易 | 打卡 1 分钟即完成 |
| 10 | 容易 | 完成日常简单习惯 |
| 15 | 中等 | 完成标准专注任务 |
| 20 | 困难 | 完成高强度/长时间任务 |
| 25 | 极困难 | 连续打卡+高完成率 |
| 30 | 几乎不可能 | 传奇成就 |

**来源**：以上全部经用户上传 PDF 原文确认，与 5e24srd.com [S2][S3] 和 Roll20 [S52] 交叉验证一致。

---

## 四、竞品深度拆解

### 4.1 Habitica —— RPG 习惯追踪先驱

**基本信息**：
- 最初名为 HabitRPG，2015 年更名为 Habitica [S4]
- 开源项目，有网页端和移动端
- 将任务管理转化为 RPG 体验 [S4]

**核心机制**：
Habitica 采用三层任务体系 [S5][S6]：
- **Habits**（习惯）：可重复的 +/− 行为，如"喝水 +1"/"吃垃圾食品 −1"
- **Dailies**（每日任务）：定时必做任务，未完成会**扣血（HP）**
- **To-Dos**（待办）：一次性任务

任务按颜色编码反映"健康度"：蓝色（新）→ 绿色（良好）→ 黄色→ 橙色 → 红色（长期未完成，奖励最高）[S5]

**职业系统**：10 级解锁，可选 Warrior/Mage/Healer/Rogue [S6]

**成功之处**：
- 三层任务体系非常直观，值得直接借鉴 [S5]
- 组队任务（Party Quests）通过集体完成真实任务击败 Boss，创造强力问责机制 [S5]
- 宠物/坐骑收集系统提供长期收集动力 [S6]

**失败之处**：
- **HP 扣血机制造成焦虑**：生病或忙碌时未完成 Dailies 会扣血，用户报告产生负罪感和焦虑 [S5][S50]
- **UI 复杂难上手**：新用户评价"界面杂乱、难以导航" [S50]
- **2023 年 8 月移除公会和酒馆**：这一决定严重破坏了社区基础，大量忠实用户流失 [S5][S50]
- **内容天花板**：收集完大部分装备/宠物后"游戏部分就结束了"，用户流失 [S50]
- **职业解锁过慢**：10 级才能选职业，影响早期留存 [S50]

**对 Hachimi 的启示**：
| 借鉴 | 避免 |
|------|------|
| 三层任务体系（习惯/每日/待办） | HP 扣血强惩罚 |
| 任务颜色编码 | 职业解锁门槛过高 |
| 组队任务概念（Phase 4） | 过于复杂的 UI |
| 宠物收集体系 | 社交作为核心依赖 |

**决策依据**：Habitica 是唯一将 RPG 元素全面融入习惯追踪的产品，证明了概念可行性，但其惩罚机制和 UI 复杂度是主要教训。Hachimi 应该学其"广度"（三层任务+职业+宠物），避免其"深度暴力"（扣血/死亡）。

**信息来源**：Wikipedia [S4]、Trophy 案例研究 [S5]、Productivity-apps [S6]、Habi.app 替代品分析 [S50]、Trustpilot 用户评价 [S53]

### 4.2 Forest —— 极简主义的游戏化标杆

**基本信息**：
- 由台湾 Seekrtech 开发 [S9]
- 4000 万+ 用户，App Store 4.9 星 [S8][S9]
- 从台湾大学生项目成长为全球产品 [S9]

**核心机制**：
核心极其简单——设定专注时间 → 种下虚拟树 → 手机不碰 → 树木长大；中途退出 App → **树木死亡** [S7][S8]

**成功要素**：
1. **可见损失心理**：死掉的树会永远留在你的森林里，制造强烈的 FOMO [S7][P1][P17]
2. **收集驱动**：90+ 种可解锁树种，从普通橡树到圣诞树 [S8]
3. **真实世界影响**：与 Trees for the Future 合作，虚拟金币可兑换**真实种树**（已种 160 万+棵）[S8][S9]
4. **社交问责**：多人模式共同种树，任何人退出所有人的树都死 [S8]
5. **白噪音**：内置环境音，强化专注氛围 [P1]

**关键数据** [S8][S9]：
- 下载量：4000 万+
- 种下真实树木：160 万+
- 评分：4.9/5.0
- 商业模式：一次性购买（iOS $3.99）+ 高级树种内购

**对 Hachimi 的核心启示**：

Forest 证明了一个关键原则——**一个精妙的核心机制 + 情感层包装 = 全球级产品**。它本质上只是一个计时器，但"种树"的隐喻赋予了它灵魂 [P1]。Hachimi 的等价策略是：**本质是习惯追踪器，但"养猫"的隐喻赋予它灵魂**。

但 Forest 的"树木死亡"是**强惩罚**——PRD 正确地指出 Hachimi 应用"猫咪心情变差"作为**软惩罚**替代 [PRD §1]。研究表明，温和的负激励（如 Finch 的"你的小鸟想你了"）比强惩罚有更好的长期留存 [S10]。

**信息来源**：Appcues GoodUX [S7][P1]、Trophy 案例研究 [S8]、AppSamurai [S9]、Medium 分析 [S54]、UX Planet [P2]、Voxel Hub [P17]

### 4.3 Finch —— 温柔游戏化的黄金标准

**基本信息**：
- 2021 年上线，定位自我关怀应用 [S10]
- 2024 年获 Apple App Store Editors' Choice [S46]
- 月收入约 $900K-2M [S13][S47]
- Android 下载量 13M+，评分 4.91/5.0 [S10]

**核心机制**：
用户孵化、命名并养育一只虚拟小鸟。通过完成自我关怀任务（喝水、散步、深呼吸、写日记等），小鸟获得能量并成长 [S10][S11]。

**成长系统**：
鸟的生命阶段：蛋 → 幼鸟 → 小鸟 → 成年 → 长者 [S10]
鸟会基于用户行为模式发展出个性特质 [S11]

**核心心理学洞见——投射效应**：
Finch 的杀手级洞见是**投射**：照顾小鸟激活了用户的养育本能，而"为自己做事"的抗拒比"为可爱宠物做事"的抗拒小得多（据分析约少 90%）[S47]。用户报告"我不会为自己喝水，但我会为我的小鸟喝水" [S10]。

**这是 Hachimi 最应该学习的核心机制**——猫咪就是用户自我提升的可视化投射。

**关键留存设计**：
- **零惩罚**：如果用户一天不打开，什么坏事都不会发生。鸟不会生病、不会挨饿、不会死 [S10][S48]
- **温柔回归**：缺席后的第一条消息是"你的小鸟想你了"，而非"你失败了" [S10]
- **关系里程碑**：第 185 天"超级好朋友"、第 312 天"双胞胎"，创造长期留存锚点 [S11]
- **冒险系统**：鸟用攒下的能量去冒险，带回不可预测的发现——这是变量奖励的精妙实现 [S10][S49]
- **可穿戴定制**：帽子、围巾、眼镜等换装系统 [S10]

**Day-1 留存约 60%**：远高于行业平均 [S13]

**每次下载收入 $1.11** [S13]

**Finch 的不足**（= Hachimi 的机会）：
- "全是游戏化，缺少实用性"——习惯追踪本身很浅，不如专业工具 [S10]
- 缺少深度 RPG 机制——只是养宠物，没有数值深度
- 无法追踪复杂的里程碑目标

**Hachimi 的差异化切入点**：Finch 证明了宠物养成 + 自我关怀的情感模式有效。Hachimi 在此基础上叠加**DND 数值深度 + 专业级习惯追踪**，填补 Finch "实用性不足"和"缺少 RPG 深度"的双重空白。

**信息来源**：Eat Proteins [S10]、Medium UX 拆解 [S11]、ScreensDesign [S12]、Naavik [S13]、FoxData [S46]、Medium $12M 分析 [S47]、Autonomous.ai [S48]、Yoga Journal [S49]

### 4.4 Habicat —— 最直接的竞品

**基本信息**：
- App Store 上的像素风游戏化习惯应用 [S55][S56]
- 核心卖点：像素猫 + 习惯打卡 + Boss 战

**核心机制** [S55][S56]：
- 月度 Boss 战：由习惯打卡驱动
- 装备收集系统
- 成就墙（含隐藏彩蛋）
- 排行榜

**用户反馈**：
- 正面：强烈的情感依附，30+ 天连击常见 [S55]
- 负面：头像定制有限、Boss 进度有 Bug、无可变难度 [S56]

**Hachimi vs Habicat 差异点**：

| 维度 | Habicat | Hachimi v2.0 |
|------|---------|-------------|
| DND 属性体系 | 无 | 完整六维系统 |
| 猫咪深度 | 简单头像 | 15+ 参数生成 + 性格 + 成长阶段 |
| 专注计时器 | 无 | 倒计时+秒表双模式 |
| 叙事内容 | 无 | DND 探险故事 |
| Boss 战 | 有（强游戏化） | 无（保持工具感） |
| 离线支持 | 未知 | 离线优先架构 |

**决策依据**：Habicat 验证了"像素猫 + 习惯"这个概念在市场上有需求。但它偏游戏（Boss 战、排行榜），Hachimi 应保持**工具感为先**的差异化路线。

**信息来源**：App Store 页面 [S55][S56]

### 4.5 竞品矩阵总结

| 维度 | Habitica | Forest | Finch | Habicat | **Hachimi v2.0** |
|------|---------|--------|-------|---------|-----------------|
| 核心情感 | 英雄史诗 | 正念疗愈 | 温柔陪伴 | 像素冒险 | **陪伴+冒险+成长** |
| 惩罚强度 | 强（扣血） | 强（树死） | 无 | 中（Boss 失败） | **软（心情变差）** |
| RPG 深度 | 高 | 无 | 低 | 中 | **高（DND 基础）** |
| 工具实用性 | 中 | 高 | 低 | 中 | **高** |
| 像素美术 | 有 | 无 | 无 | 有 | **核心卖点** |
| 宠物养成深度 | 浅（收集） | 无 | 深 | 浅 | **深（性格+属性+配件）** |
| 月收入参考 | 较低 | 中等 | $900K-2M | 较低 | 目标：$100K+ |

---

## 五、游戏设计参考分析

### 5.1 星露谷物语（Stardew Valley）—— 像素美术与循环设计的教科书

**为什么星露谷是正确的美术参考？**

星露谷物语由 ConcernedApe（Eric Barone）一人开发，证明了**一个人可以用纪律性的像素美术流程产出高质量内容**——这对 AI 辅助的独立开发者尤为重要 [P5]。

**精灵图规格**（经 Stardew Valley Forums 确认）[S27]：
- 瓦片尺寸：16×16 像素
- 角色尺寸：16×32 像素（1 瓦片宽，2 瓦片高）
- 肖像尺寸：64×64 像素
- 行走动画：4 帧/方向 × 4 方向 = 16 帧

**风格特征**（经 Sprite-AI 风格指南 + Reddit 讨论确认）[S28][P16]：
- 调色板：约 16-32 色/精灵，暖色调主导，轻微降饱和
- 阴影：色相偏移（阴影偏冷色，高光偏暖色），而非简单明暗
- 轮廓：1px 暗色描边（非纯黑，而是深化的主体色）
- 比例：Q 版约 2 头身，天然可爱
- 动画节奏：慢预备 → 快动作 → 慢恢复，即使在极小尺寸下也保持节奏感

**循环设计值得借鉴的** [P4][PRD §7]：
1. **日循环**：每天有不同的事可做（不同的天气、不同的 NPC 日程）
2. **季节循环**：每季有新作物、新事件、新外观
3. **长期循环**：多年积累才能完成社区中心/全收集

**Hachimi 的对应设计**（来自 PRD）：
- 日循环：每天登录猫咪有新对话；探险事件内容随机（有 seed）
- 周循环：每周一次"周挑战"（如"本周专注 5 次"），奖励限定配件
- 阶段循环：猫咪进化时全屏庆典动画

**另一个关键教训——治愈系低压力**：星露谷没有"今天没浇水庄稼就死"的严厉惩罚（庄稼只是不生长）。这种宽容设计与 Finch 的零惩罚理念一致，Hachimi 应借鉴 [P4][PRD §7]。

**信息来源**：Stardew Valley Forums [S27]、Sprite-AI [S28]、RestfulCoder YouTube [P4]、ConcernedApe 专访 [P5]、Reddit [P16]

### 5.2 开罗游戏（Kairosoft）—— 管理模拟与进度反馈的大师

**基本信息**：
- 日本开罗软件（Kairosoft），成立于 1996 年 [S24]
- 代表作：Game Dev Story（2010 年突破性成功）[S25][S26]
- 50+ 款游戏，统一的像素美术 + 管理模拟框架 [S24]

**精灵图规格** [S25][S26]：
- 角色尺寸：约 16×16 到 24×24
- 明亮饱和的调色板（与星露谷的柔和风格形成对比）
- 简洁但富有表现力的动画

**开罗游戏框架的三大设计目标**（来自 Indienova 深度分析）[P9][S24]：

**1. 目标可见性——短期强提示，长期弱提醒**

开罗游戏总是让"下一个里程碑"非常醒目，同时让远期目标在 UI 边缘安静存在 [P9][S24]。

Hachimi 应用：
- 短期："再专注 15 分钟，你的猫咪就能进化！"——醒目弹窗
- 长期："已积累 45/200 小时，成为传奇猫咪"——进度条静默显示

**2. 高频正反馈——每个动作都有多层反馈**

开罗游戏中，每完成一个决策都会触发连锁反馈：数字上浮 → 角色动画 → 评分变化 → 报纸报道 [P9][S24]。

Hachimi 对应设计：每完成一次专注 → XP 数字浮出 → 猫咪跳动表情变化 → DND 属性微调 → 探险进度前进。不能只有一层反馈。

**3. 检验阶段的延时设计**

开罗游戏的核心机制之一是"投入 → 等待 → 揭晓结果"（如 Game Dev Story 中开发游戏后等待评分揭晓）[P9][S24][S25]。这个等待产生期待感。

Hachimi 的探险系统应借鉴这一点：探险结果不在完成检定时立即全部揭晓，而是**下一次打开 App 时**呈现（"你的猫咪在探险中发现了..."），制造打开 App 的动机 [PRD §7]。

**进度系统分析**（Entertainment Analytical）[S24]：
- **金钱作为上升整数**：开罗游戏中钱永远在增长，提供即时的功能性反馈
- **游戏内报纸**：宣布玩家成就，营造沉浸式认可
- **新玩法作为进度奖励**：新解锁的不只是数值提升，而是新的游戏机制（如新建筑类型、新员工能力），产生复合参与感

**对 Hachimi 的适配**：
| 开罗模式 | Hachimi 实现 |
|----------|-------------|
| 金钱上升 | 金币 + XP 持续增长 |
| 报纸公告 | 猫咪日记/冒险者公告板 |
| 新机制解锁 | 猫咪进化解锁新互动、新探险区域 |
| 评分揭晓 | 探险结果延时揭晓 |

**信息来源**：Indienova [P9]、Entertainment Analytical [S24]、Kairosoft Wiki [S25]、Steam/Wikipedia [S26]

### 5.3 博德之门 3（Baldur's Gate 3）—— 骰子 UI/UX 的最佳实践

**基本信息**：
- Larian Studios 开发，2023 年 8 月发售 [S21]
- 首款在所有五大年度游戏评选中同时获奖的作品 [S21]
- 基于 D&D 第五版规则的 CRPG [S21]

**BG3 如何让 D&D 检定变得"好玩"**（经 Gaming Respawn 深度分析 + Game Developer 分析确认）[S22][S23]：

**1. 展示数学过程 = 制造戏剧性**

BG3 的 Patch 5 彻底重设计了骰子 UI [S23]。最终设计是：
- 首先显示 DC 难度
- d20 以物理模拟翻滚
- 翻滚结束后，修正值**逐个叠加动画**："你投出 12... +3 魅力... +2 熟练 = 17！成功！"
- 这让角色构建感觉有意义，每次检定都成为微型叙事 [S23]

**2. 自然 20 的仪式感**

自然 20（骰子本身投出 20）触发特殊光效和音效，被玩家社区广泛传播 [S23]。BG3 甚至衍生了大量**自定义骰子皮肤**模组，证明即使零游戏性影响的装饰品也能驱动巨大参与度 [S23]。

**3. 失败也要有趣**

BG3 的首席编剧明确表示他们的目标是"让失败比成功更有趣" [S22]。自然 1（大失败）触发搞笑的叙事结果，而非简单的"你失败了"。

**4. 玩家疲劳的教训**

玩家反馈在经历数千次骰子后产生疲劳（"到第 9000 次我只想看结果"）[S22]。Save-scumming（存档重来）也削弱了骰子的紧张感。

**对 Hachimi 的适配建议**：

| BG3 经验 | Hachimi 实现 |
|---------|-------------|
| 展示数学叠加动画 | 专注完成后骰子翻滚 → 修正值逐个叠加 → 结果揭晓 |
| 自然 20 仪式感 | 自然 20 触发传奇奖励 + 猫咪特殊全屏动画 |
| 失败要有趣 | 自然 1 触发搞笑猫咪动画 + 安慰奖（不能是惩罚） |
| 防疲劳 | 保持骰子动画短速（2-3 秒，不是 BG3 的 30 秒）；提供跳过选项 |
| 自定义骰子皮肤 | 可解锁的骰子外观作为收集品 |

**核心设计原则**：**完成习惯永远成功**——骰子只决定奖励等级，而非成败。击败 DC 10+ 获得暴击奖励（稀有物品/3 倍 XP）；未击败 DC 只获得标准 XP。这保留了 D&D 的兴奋感，同时不惩罚真实努力。

**信息来源**：Wikipedia [S21]、Game Developer [S22]、Gaming Respawn [S23]

---

## 六、猫系游戏机制拆解

### 6.1 Neko Atsume（猫咪后院）—— 被动魅力与无负罪感设计

**基本信息** [S14]：
- Hit-Point 开发，2014 年上线（日本）
- 1000 万+ 下载
- CEDEC Best Game Design 获奖

**核心机制** [S14][S15][S16]：
玩家在虚拟庭院中放置食物和玩具，然后**关掉 App**。回来后发现猫咪来访了。66 只猫（40 只普通、26 只稀有），每只需要特定的物品+食物组合才能吸引。

**设计分析**（Medium 两篇深度拆解）[S15][S16]：

1. **刻意不发推送通知**：这在 2014 年的手游市场中极为反常，但恰恰创造了"我自己想去看看"的自主动机 [S15]
2. **无惩罚**：食物吃完了猫只是不来，不会生病或死亡 [S16]
3. **涌现叙事**：游戏零剧情，但玩家自发为猫咪编故事——这种用户生成叙事的粘性极强 [S15][S17]
4. **图标式 UI**：即使未翻译英文版，也在美国爆红，因为 UI 完全基于图标/图形，无需文字 [S16]
5. **内置相机**：截图分享功能是病毒传播的核心驱动力 [S15]

**学术研究**（ResearchGate）[S17]：Neko Atsume 的"亲和空间"（Affinity Space）研究发现，玩家在非正式社区中进行了大量的"附带学习"——分享猫咪组合策略、讨论稀有猫触发条件等，形成自发的知识社区。

**对 Hachimi 的启示**：
- **发现感是首要奖励**：猫咪正在做什么比货币/XP 更有趣 [S15]
- **稀有猫触发条件 = 实验循环**：不同的物品组合吸引不同的猫，映射到 Hachimi 就是不同的习惯组合产生不同的探险事件
- **截图分享是核心增长飞轮**：内置猫咪卡片分享功能
- **简洁 > 复杂**：Neko Atsume 的成功在于做得极少而做得极精 [S16]

**信息来源**：Wikipedia [S14]、Medium 设计拆解 [S15][S16]、ResearchGate [S17]

### 6.2 Cats & Soup（猫汤）—— 放置与合并的经济模型

**基本信息** [S18][S19]：
- HIDEA 开发，2021 年上线
- 月收入约 $300K [S18]
- 放置/挂机类猫咪游戏

**核心机制** [S19][S20]：
猫咪在各种料理站（切菜、煮汤等）工作，产生货币（金币+宝石双币种）。设施可升级，产生指数增长的收入。离线也在产出（上限约 24 小时）。

**经济模型** [S20]：
- 金币（基础货币）：设施运营产出
- 宝石（高级货币）：每日登录、广告、特殊活动
- 广告植入方式很温柔——"由一只小猫带来的广告" [S19]

**值得借鉴的设计模式**：
1. **离线产出**：用户回来发现积累了资源，产生正面惊喜
2. **收集图鉴**：每只新猫是独特发现
3. **低认知负荷**：无失败状态
4. **指数增长的满足感**：数字越来越大

**对 Hachimi 的适配**：
- 猫咪在 App 关闭时也可以"在探险中"，回来后展示探险成果
- 收集图鉴驱动长期留存
- 但**严格不做放置挂机**——Hachimi 的金币和 XP 必须来自真实行为，不能自动产出（这是工具感底线）

**信息来源**：Sensor Tower [S18]、CatSwoppr [S19]、Cats & Soup Wiki [S20]

### 6.3 猫咪头像/精灵图生成工具

调研发现以下可用的猫咪生成方案 [S40][S41][S42][S57][S58]：

| 工具 | 类型 | 许可证 | 特点 | 适配性 |
|------|------|--------|------|--------|
| David Revoy Cat Avatar Generator | 层级合成 PNG | CC-BY-4.0 美术 + MIT 代码 | 15+ 图层组合，~1000 万种唯一猫咪 | ⭐⭐⭐⭐⭐ |
| DiceBear HTTP API | SVG 头像 | MIT | URL 调用即返回 SVG，`/9.x/{style}/svg?seed={name}` | ⭐⭐⭐ |
| RoboHash Set 4 | 像素猫 | CC-BY | `robohash.org/{seed}?set=set4` | ⭐⭐⭐ |
| pixel_art_generator (pub.dev) | Flutter 包 | MIT | 程序化像素画，支持模板+镜像对称 | ⭐⭐⭐⭐ |
| CryptoKitties 模式 | 特征编码 | 概念参考 | 种子→体型/花色/眼睛/嘴巴/配件 | ⭐⭐⭐⭐⭐ |

**推荐方案**（综合两轮调研结论）：

项目已使用 `pixel-cat-maker` 参数化系统（15+ 外观参数），这是最佳选择。建议参考 CryptoKitties 的特征编码思路进一步扩展：

```
每只猫编码为紧凑种子 → 映射到：
- 体型（3-5 变体）
- 毛色/花纹（8-10 种）
- 眼睛形状&颜色（6-8 种）
- 嘴部表情（4-6 种）
- 可解锁配件（10+ 件）
```

从可管理的素材集产出数万种唯一组合。

**信息来源**：GitHub cat-avatar-generator [S40]、Framagit [S41]、DiceBear [S42]、pub.dev [S57]、pixel_art_generator [S58]

---

## 七、游戏化心理学与学术依据

### 7.1 自我决定理论（SDT）—— 最重要的理论框架

**来源**：Springer TechTrends 论文 [S37]、ScienceDirect 系统综述 [S38]

在对 118 种理论的系统综述中，**自我决定理论（Self-Determination Theory）**是游戏化研究中引用最多的理论框架 [S38]。它识别了三种核心心理需求：

1. **自主性（Autonomy）**：用户感到自己在做选择，而非被强迫
   - Hachimi 应用：用户自定义习惯目标、选择猫咪名字/性格、选择探险路线
   - 反面案例：Habitica 的 Dailies 强制性造成被迫感

2. **能力感（Competence）**：用户感到自己在进步、在掌握技能
   - Hachimi 应用：DND 属性可视成长、猫咪进化、等级提升
   - 关键发现：2023 年元分析显示游戏化**确实增强**了自主感和关联感，但对能力感的影响**较小** [S38]——这意味着能力感必须来自**真实习惯的进步**，而非游戏层面的数值膨胀

3. **关联性（Relatedness）**：用户感到与他人/角色的情感连接
   - Hachimi 应用：猫咪的性格、对话、心情变化、进化历程

### 7.2 过度合理化效应——最大的风险

**来源**：Wikipedia 过度合理化效应 [S39]、Growth Engineering [S59]

**过度合理化效应**（Overjustification Effect）：当预期的外部奖励（积分、徽章）减少了内在动机时，一旦奖励停止，先前的内在动机也不会恢复 [S39]。

一项大规模实证研究记录了**限时游戏化方案结束后用户贡献急剧下降** [S39]——用户已经从"因为想做"变成了"因为有奖励"，奖励消失后动力反而比未游戏化时更低。

**缓解策略**（来自学术研究 + 竞品经验）：
1. **奖励设计为信息反馈而非交易报酬**："你的猫学会了新技能，因为你冥想了 10 次！"（信息型）vs "冥想 10 次获得 100 金币"（交易型）[S37]
2. **确保习惯本身始终是核心价值主张**：去掉所有游戏化后，Hachimi 仍应是一个好用的习惯追踪器 [PRD §1]
3. **避免竞争性排行榜**：排行榜将内在动机外化为社会比较 [S59]
4. **使用变量奖励而非固定奖励**：骰子系统的随机性让每次都有期待，避免机械化 [S60]

### 7.3 连击（Streak）设计——最强力也最危险的机制

**来源**：Plotline [S61]、Mind the Product [S62]、Medium 核心游戏化技术 [S60]

游戏化专家 Sam Liberty 对参与机制的力量/风险排名 [S60]：

| 排名 | 机制 | 力量 | 风险 |
|------|------|------|------|
| 1 | 连击（Streaks） | 最强 | 最高——断连导致完全放弃 |
| 2 | 每日奖励 | 高 | 低——正面期待，无损失恐惧 |
| 3 | 限时活动 | 高 | 中——FOMO |
| 4 | 随机奖励 | 高 | 中——变量强化 |
| 5 | 损失厌恶 | 高 | 高——人对损失的感受是等价收益的 2 倍 |
| 6 | 个性化挑战 | 中 | 低——流体验 |
| 7 | 目标承诺系统 | 中 | 低——自设目标强承诺 |

**关键数据**：连击+里程碑组合驱动 **40-60% DAU 提升**（对比单一机制）[S61]。但断连在无恢复机制时导致**彻底弃用** [S62]。

**Hachimi 的连击设计建议**（综合 PRD + 调研）：
- **弹性连击**：5/7 天算连击维持，容许偶尔休息 [PRD §9]
- **"酒馆休息"宽限日**：每周自动 1-2 天宽限，不破坏连击
- **连击中断不清零**：30 天连击断了不从 0 开始，而是"冻结"（如降到 25 天），下次打卡继续
- **DND 优势/劣势绑定**：3+ 天连击 = 探险骰子获得优势；回归断连 = 短期劣势（激励而非惩罚）

### 7.4 核心参与循环设计

**来源**：Medium 31 核心游戏化技术 [S60]、Naavik [S13]、GAMIFICATION+ [S63]

最优的核心循环整合了习惯、猫咪和 DND 三个系统（综合所有调研结论）：

```
1. 触发：晨间通知（"你的猫咪好奇今天的冒险！"）
2. 行动：完成真实世界的习惯
3. 即时奖励：d20 动画骰子决定奖励等级 + 猫咪获得能量
4. 投入：用攒下的能量派猫去 DND 探险
5. 变量奖励：猫咪带回战利品、故事碎片、性格特质
6. 长期进度：XP 累积升级 → 属性成长 → 新区域解锁
```

**为什么这个循环有效**（学术依据）：
- 步骤 1-2 满足**自主性**（用户选择做什么）
- 步骤 3 满足**能力感**（可见进步）
- 步骤 4-5 满足**变量强化**（不可预测的奖励比固定奖励更有吸引力）[S60]
- 步骤 6 满足**目标承诺**（看到长期进展）
- 整个循环通过猫咪满足**关联性**（情感投射）

**信息来源**：Medium [S60]、Naavik [S13]、GAMIFICATION+ [S63]、Plotline [S61]、Mind the Product [S62]

---

## 八、产品架构设计

### 8.1 底部导航栏（5 Tab 方案）

以下设计融合了 PRD 方案和第一轮调研中对 Finch/Habitica/Forest UI 模式的分析：

| # | Tab 名称 | 图标 | 核心内容 | 设计参考 |
|---|---------|------|---------|---------|
| 1 | **今日** | 🏠 | 精选猫展示 + 今日习惯列表 + 快速打卡 | Finch 首页（宠物+任务合一） |
| 2 | **猫屋** | 🏡 | 等距像素风房间，猫咪闲置动画，可互动 | 星露谷室内场景 + Neko Atsume 庭院 |
| 3 | **冒险** | ⚔️ | DND 探险地图 + 场景卡选择 + 检定结果 | BG3 骰子UI + 开罗延时揭晓 |
| 4 | **统计** | 📊 | 热力图 + DND 属性雷达图 + 时间分析 | Habitica 统计面板 |
| 5 | **我的** | 👤 | 设置 + 猫咪图鉴 + 成就 + 旅程数据 | Finch 个人主页 |

**决策依据**：
- 5 Tab 而非 4 Tab：新增的"冒险"Tab 是 DND 机制的核心入口，如果藏在二级菜单会降低发现率和使用频率。Finch 和 Habitica 都是 4-5 个底部 Tab [S11][S6]
- Tab 1 合并"精选猫"和"习惯列表"：Finch 证明了宠物+任务在同一屏的有效性——用户一打开就同时看到可爱的猫和今天要做的事 [S11]
- Tab 2 独立猫屋：不同于 Tab 1 的功能视角，猫屋是纯粹的**情感满足空间**——让用户来"看猫"而不是"做任务" [参考 Neko Atsume 的被动愉悦]

### 8.2 左侧滑动抽屉（Side Drawer）

```
┌─────────────────────────────┐
│  [像素猫头像]  用户名         │
│  等级 Lv.12  ████░░ 340 XP  │
│  职业：游侠（Ranger）        │
├─────────────────────────────┤
│  🐱 猫咪图鉴                │  ← 全收集驱动
│  🏆 成就中心                │  ← 里程碑系统
│  📅 习惯日历                │  ← 热力图入口
│  🗺️ 探索地图                │  ← DND 世界地图
├─────────────────────────────┤
│  🎒 背包（道具/配件）        │  ← 物品管理
│  🛍️ 道具商店                │  ← 金币消费
│  🎲 冒险者档案              │  ← DND 属性面板
├─────────────────────────────┤
│  🔔 提醒设置                │
│  🌙 白噪音                  │  ← 参考 Forest
│  ⚙️ 设置                    │
│  📤 分享进度                │  ← 猫咪卡片分享
└─────────────────────────────┘
```

**与 PRD 的差异**：新增"冒险者档案"快捷入口（DND 属性面板），以及"职业"显示在用户信息区。

### 8.3 各页面详细设计

#### Tab 1：今日（Today）

**顶部区域**：精选猫大卡
- 使用现有精选猫算法（`recency×0.45 + mood×0.30 + growth×0.20 + today×0.05`）
- 猫咪旁显示对话气泡（性格 × 心情 × 当前时间段 = 个性化文案）
- 点击猫咪：弹出互动菜单

**中部区域**：今日习惯列表
- 每项显示：猫咪小头像 | 习惯名 | 进度条 | 🔥连击天数
- 颜色编码（借鉴 Habitica）：蓝色（新）→ 绿色（良好）→ 红色（久未完成）
- 点击卡片 → 一键启动计时器

**底部浮动**：全完成检测
- 当天所有习惯完成 → 触发 "Full House" 全屏庆典动画 + 额外 20 金币奖励 [PRD §6.1]

#### Tab 2：猫屋（Cat House）

**视觉风格**：等距视角像素风房间（参考星露谷室内场景）[P4][P5]
- 16×16 瓦片网格
- 日夜切换（已实现）
- 分区：沙发区/书架区/窗台/睡眠区

**猫咪行为**：
- 闲置动画（行走/梳毛/打盹/伸懒腰/看窗外）
- 最多 10 只活跃猫咪同屏
- 猫咪间有简单的互动逻辑（靠近时可能蹭头/追逐）

**互动方式**：
- 点击猫咪：对话气泡 + 底部操作表（开始专注/查看详情/换装）
- 长按猫咪 → 再点另一只：触发"猫咪结合"探险（Phase 4）

**家具系统**：
- 可解锁装饰家具（里程碑奖励 + 商店购买）
- 家具影响猫咪行为（如猫爬架增加"玩耍"动画频率）

**被动感知事件**（DND 被动感知机制 = `10 + WIS修正`）：
当猫咪的被动感知分数足够高时，猫屋中随机触发隐藏事件 [PRD §5.4]：
- "窗台出现了一只流浪猫"
- "书架掉落了一本神秘书籍"
- "沙发下发现了一枚古老金币"

#### Tab 3：冒险（Quest/Adventure）

这是 DND 机制的核心载体。详见第九节 §9.3。

**核心定位**：纯文字 + 插画的轻量叙事模块，**不是实时战斗游戏** [PRD §5.2]

#### Tab 4：统计（Stats）

- 顶部卡片："冒险者档案"（DND 六维属性雷达图 + 数值，用 `fl_chart` 实现）
- 今日总专注时长 + 连击数 + 活跃猫咪数
- 各习惯 91 天热力图
- 时间分布图（最高效时间段分析）
- 趋势曲线：周/月专注时长变化

#### Tab 5：我的（Profile）

- 用户旅程数据：总专注时长/总猫咪数/最长连击/DND 等级
- 猫咪图鉴（网格视图，含已毕业猫，显示稀有度标签）
- 稀有度分布饼图（Common/Uncommon/Rare/Legendary）
- 成就解锁列表（含进度条和下一个解锁提示）

### 8.4 用户地图设计

探险地图是 Tab 3 的核心视觉元素：

**地图样式**：开罗游戏风格的俯视区域地图
- 像素画风的世界地图，分为多个"区域"
- 每个区域含 5-8 个"场景卡"
- 区域随用户等级/探险进度逐步解锁（迷雾消散效果）

**初始区域建议**（15 个场景卡）：

| 区域 | 场景卡 | 主要检定属性 | 解锁条件 |
|------|--------|------------|---------|
| 猫咪小镇 | 市集广场、铁匠铺、图书馆、酒馆、草药园 | 混合 | 初始可用 |
| 迷雾森林 | 古树小径、精灵泉、蘑菇洞、瞭望塔、月光湖 | DEX/WIS | 等级 5+ |
| 远古遗迹 | 石像谜题、浮空桥、宝藏室、壁画厅、封印之门 | INT/STR | 等级 10+ |

---

## 九、核心系统设计

### 9.1 猫咪系统深化

#### 9.1.1 成长阶段（保留现有 4 阶段，增加视觉深度）

| 阶段 | 触发条件 | 属性上限 | 视觉特征 |
|------|---------|---------|---------|
| 幼猫 Kitten | 创建时 | 14 | 小体型，大眼睛，简单花纹 |
| 少年猫 Young | 50h 专注 | 16 | 中体型，花纹细化 |
| 成年猫 Adult | 100h 专注 | 18 | 标准体型，全花纹+配件槽位开放 |
| 长老猫 Elder | 200h 专注 | 20 | 微大体型，智慧光晕特效，传奇配件 |

进化时触发**星露谷式进化序列帧动画**（白光包裹 → 形态渐变 → 闪光散射 → 新形态展现）[PRD §4.1]

#### 9.1.2 配件系统

代码中 `accessories` 字段已预留 [PRD §4.2]：

| 配件槽位 | 示例 | 获取方式 |
|---------|------|---------|
| 头部 | 学士帽/魔法帽/猫耳发箍/皇冠 | 里程碑解锁 |
| 颈部 | 铃铛项圈/DND 魔法符文项链/围巾 | 成就解锁 |
| 背部 | 迷你背包/冒险包/翅膀（装饰） | 商店购买（金币） |
| 武器（装饰） | 迷你魔杖/迷你剑/盾牌 | DND 探险获得 |
| 环境 | 猫咪坐垫/特殊猫爬架/宝座 | 家具系统 |

**技术实现**：使用 Rive 骨骼动画，通过运行时切换图像填充/图层可见性来换装——**一个 .riv 文件即可支持所有配件组合**，无需数百张独立精灵图 [S34][S36]

#### 9.1.3 性格 × DND 属性绑定

| 性格 | 优势属性 | 探险增益 | 设计来源 |
|------|---------|---------|---------|
| Lazy 懒惰 | CON 体质 | 耐力检定获优势 | PRD §4.3 |
| Curious 好奇 | INT 智力 | 知识类事件获优势 | PRD §4.3 |
| Playful 活泼 | DEX 敏捷 | 敏捷类事件获优势 | PRD §4.3 |
| Shy 害羞 | WIS 感知 | 感知类事件获优势 | PRD §4.3 |
| Brave 勇敢 | STR 力量 | 力量类事件获优势 | PRD §4.3 |
| Clingy 黏人 | CHA 魅力 | 对话/社交事件获优势 | PRD §4.3 |

**机制说明**（完全遵循 SRD 5.2.1 优势规则）：
当猫咪性格与事件类型匹配时，该猫在相关检定中获得**优势**（投 2d20 取高值）。当猫咪处于 lonely/missing 心情时，检定遭受**劣势**（投 2d20 取低值）——这是习惯中断的柔性代价 [PRD §5.2]。

### 9.2 DND 属性系统

#### 9.2.1 六维属性映射

每只猫（即每个习惯）维护独立的属性集 [PRD §5.1]：

| DND 属性 | Hachimi 含义 | 成长触发 | 数据来源 |
|---------|-------------|---------|---------|
| **STR 力量** | 总积累量 | totalMinutes 每+200min → +1 | 现有 `totalMinutes` |
| **DEX 敏捷** | 专注效率 | 完成率>90% 连续 7 次 → +1 | 现有 `completionRate` |
| **CON 体质** | 韧性/连击 | streak 每+10 天 → +1 | 现有 `streak` |
| **INT 智力** | 习惯复杂度 | 基于 goalMinutes 等级映射 | 现有 `goalMinutes` |
| **WIS 感知** | 里程碑触达率 | 每完成 1 个里程碑 → +2 | 现有 milestone 数据 |
| **CHA 魅力** | 综合评分 | 阶段进化次数 × 连击综合分 | 复合计算 |

**核心设计原则**：属性为**计算型字段**，从现有数据（totalMinutes/streak/completionRate/goalMinutes）派生，**不引入新的写路径** [PRD §12]。用户完成专注后，属性在后台自动更新。

**属性值范围**：10-20（SRD 标准人类区间），初始全部 10，上限随成长阶段解锁 [PRD §5.1]

#### 9.2.2 用户等级与职业

**用户等级系统**（独立于猫咪等级）：

用户通过所有习惯的累积 XP 升级。XP 需求参考 SRD 但大幅简化：

| 用户等级 | 累积 XP | 熟练加值 | 解锁内容 |
|---------|---------|---------|---------|
| 1-4 | 0 - 2,000 | +2 | 基础探险区域 |
| 5-8 | 2,000 - 8,000 | +3 | 迷雾森林区域 + 高级配件 |
| 9-12 | 8,000 - 20,000 | +4 | 远古遗迹区域 |
| 13-16 | 20,000 - 50,000 | +5 | 多职兼修 |
| 17-20 | 50,000 - 100,000 | +6 | 传奇内容 |

**职业系统**（3 级解锁，低于 Habitica 的 10 级门槛——吸取教训）：

| 职业 | 特点 | 优势习惯类别 |
|------|------|-------------|
| 游侠 Ranger | 体能习惯 XP +25% | 运动/健身/户外 |
| 法师 Wizard | 学习习惯 XP +25% | 阅读/课程/编程 |
| 牧师 Cleric | 健康习惯 XP +25% | 冥想/睡眠/饮水 |
| 诗人 Bard | 社交习惯 XP +25% | 社交/志愿/陪伴 |
| 盗贼 Rogue | 技能习惯 XP +25% | 手工/乐器/烹饪 |
| 战士 Fighter | 通用型，所有习惯 XP +10% | 全类别 |

10 级后可选**多职兼修**（选第二个职业，获得其 50% 加成）[SRD 多职规则简化]

### 9.3 探险系统（Adventure System）

这是 Tab 3 的核心，也是 DND 机制的主要载体。

**设计灵感来源** [PRD §5.2]：
- 博德之门 3 的技能检定与选择式叙事 [S22][S23]
- 神界原罪的队伍协作检定
- 开罗游戏的检验阶段延时设计 [P9][S24]

**运作流程**：

**第一步：探险准备**
- 在 Adventure Map 选择一张"场景卡"（如"被遗弃的图书馆"）
- 选择 1-2 只猫咪作为探险成员
- 显示场景信息：推荐属性、难度等级、可能奖励

**第二步：事件触发（非实时）**
- 探险不是实时的。**每完成一次真实的专注计时后**，该猫的探险进度前进一格
- 前进一格触发一个"场景事件"
- 每个场景包含 3-5 个事件，即需要 3-5 次专注完成一次完整探险

**第三步：技能检定（完全遵循 SRD 5.2.1）**

```
检定结果 = d20（模拟动画） + 对应属性修正值 + 熟练加值（如适用）
         对比 DC（难度等级）
```

举例 [PRD §5.2]：
- 猫咪（DEX 16，修正+3）遇到"绳索渡桥"事件（DC 13）
- 掷出 d20=11，合计 11+3=14 ≥ 13，**成功**
- BG3 风格动画：骰子翻滚 → 11 → +3 逐字叠加 → 14 → "成功！"

**第四步：结果叙事**
- 成功/失败各有一段简短文字叙述
- 由 Firebase AI（Gemini via `firebase_ai` SDK，已在 pubspec.yaml 中）动态生成
- Fallback 到本地预设文本（保证离线可用）[PRD §12]

**第五步：奖励发放**

| 结果 | 条件 | 奖励 |
|------|------|------|
| 大成功 | 超出 DC 10+ 或 自然 20 | 稀有配件 + 3× XP + 50 金币 + 故事碎片 |
| 成功 | ≥ DC | 标准 XP + 20 金币 + 故事碎片 |
| 失败 | < DC | 安慰奖 10 金币 + 搞笑猫咪动画 |
| 大失败 | 自然 1 | 安慰奖 5 金币 + 特别搞笑动画 + "厄运终结者"成就进度 |

**关键设计原则**：**完成习惯永远是"成功"——骰子只决定探险中的额外奖励**。用户的真实努力不会因为骰子运气差而被否定。

### 9.4 猫咪结合系统（Phase 4）

**前置条件** [PRD §4.4]：
- 两只猫均为成年或长老阶段
- 两只猫同时处于 happy 心情

**触发方式**：猫屋中长按一只猫 → 点击另一只猫 → "结合对话"

**效果**：两只猫作为搭档组合执行探险任务
- 参考 SRD 5.2.1 协作检定规则：一只猫为主检定者，另一只为辅助者
- 辅助猫投 d20，成功则主猫检定获得**优势**

**结合产出**：完成联合探险后，有概率解锁"纪念徽章"配件，仅属于该组合

**设计意图**：强化多习惯用户的粘性。让拥有多只猫变得有价值 [PRD §4.4]。

---

## 十、数值设计体系

### 10.1 核心经济循环

```
专注时间 ─→ XP（猫咪成长/用户升级）
         ├→ 金币（工具货币）
         └→ DND 属性成长 ─→ 探险检定成功率↑
                                    └→ 稀有奖励 ─→ 配件/家具
```

### 10.2 金币收支平衡

**日均收入**（假设用户完成 3 个习惯，每个 20-30 分钟）[PRD §6.1]：

| 来源 | 每日预计 | 说明 |
|------|---------|------|
| 每日首次打卡 | 20 金币 | 固定 |
| 专注完成 | ~60 金币 | 1 金币/分钟，上限 60/天 |
| Full House 奖励 | 20 金币 | 当天全部完成 |
| 探险奖励 | 10-30 金币 | 随机 |
| **日均总计** | **~80-130 金币** | |

**消费场景**：

| 物品类型 | 价格范围 | 储蓄天数 |
|---------|---------|---------|
| 普通配件 | 100-300 金币 | 1-3 天 |
| 精品配件 | 500-800 金币 | 5-8 天 |
| 家具装饰 | 200-600 金币 | 2-6 天 |
| 临时属性加成道具 | 50 金币 | <1 天 |

**设计意图**：储蓄约 5-10 天可购买一件精品配件——这个节奏参考开罗游戏的"短期目标强提示"原则 [P9][S24]。既不太快（无目标感），也不太慢（产生挫败感）。

### 10.3 DND 属性数值曲线

**STR（力量）—— 总时长驱动** [PRD §6.2]：

| STR 值 | 所需总时长 | 修正值 | 效果 |
|--------|----------|--------|------|
| 10（初始） | 0h | +0 | 基础 |
| 12 | 10h | +1 | 力量检定轻微加成 |
| 14 | 30h | +2 | 解锁"重型"事件类型 |
| 16 | 70h | +3 | "英雄时刻"概率提升 |
| 18 | 150h | +4 | 传奇光效 |
| 20 | 200h（满级） | +5 | 最高成就 |

**CON（体质）—— 连击驱动，曲线更陡** [PRD §6.2]：

| CON 值 | 所需连击天数 | 设计意图 |
|--------|-----------|---------|
| 10 | 0 天 | 初始 |
| 14 | 30 天 | 月度里程碑 |
| 18 | 90 天 | 季度挑战 |
| 20 | 180 天 | 半年，极稀有 |

**曲线设计原则**：
- **前期快速成长**：10→14 相对容易，给予早期正反馈
- **后期指数放缓**：18→20 需要极大投入，保证长期追求
- 参考 SRD 的 XP 表设计思路——前几级升得快，后面越来越慢

---

## 十一、美术资源与 AI 生成方案

### 11.1 现有系统

项目已集成 `pixel-cat-maker` 参数化精灵图系统 [PRD §8.1]：
- 4 成长阶段 × 3 姿势变体 × 长毛/短毛 × 镜像 = 大量组合
- 建议继续维护扩展，新增进化动画帧

### 11.2 AI 美术工具链

综合两轮调研，推荐以下工具组合：

| 资源类型 | 推荐工具 | 预估成本 | 信息来源 |
|---------|---------|---------|---------|
| 猫咪配件精灵图 | Gemini Flash 2.0 API | ~$0.13/张 | YouTube 工作流 [P10] |
| 探险场景背景 | PixelLab（$9-22/月） | ~$15/月 | PixelLab 官网 [S29]、YouTube [P11] |
| 猫屋家具精灵图 | Claude Code + Pixel Art Creator MCP | 包含在 Claude 订阅中 | MCP Market [P12] |
| UI 图标/SVG | SVGMaker.io API | 免费/付费层 | There's An AI For That [P13]、SVGMaker [P14] |
| SVG 动画（进化特效） | VectoSolve / SVGator | 免费/付费层 | VectoSolve [P15] |
| 猫咪闲置动画帧 | PixelLab MCP（animate character） | 包含在上述订阅 | YouTube [P11] |
| 探险文字叙述 | Firebase AI（Gemini） | Firebase 用量内 | PRD 已集成 |
| 精灵图精修/调色 | Aseprite（$19.99 一次性） | $19.99 | GitHub [S32] |
| 备选：Retro Diffusion | 专业像素画 AI（$5-15） | ~$10 | Aiarty 对比 [S31] |

**总工具启动成本**：约 $40-60 [综合 S29][S32]

### 11.3 风格一致性约束

写入所有 AI 生成 Prompt 的强制规范 [PRD §8.3][S27][S28][P16]：

```
通用像素美术风格约束（Hachimi Style Guide）：
- 调色板：≤16 色/精灵，参考星露谷暖色调（柔和低饱和）
- 阴影：使用色相偏移（阴影偏冷色、高光偏暖色），非简单明暗
- 轮廓：1px 暗色描边（非纯黑，取主体色深化版）
- 像素尺寸规范：
  - 配件：16×16
  - 家具：32×32
  - 场景背景：192×192
  - 猫咪角色：16×32（星露谷标准）
- 透明背景
- 无抗锯齿（保持锐利像素边缘）
```

**AI 生成提示词模板** [S28][S31]：
```
"32×32 pixel art [物品名], warm palette, 1px colored outline,
2-tone cel shading, chibi proportions, transparent background,
Stardew Valley style, 16-color limit"
```

### 11.4 Claude Code 美术管理结构

建议在 `.claude/` 目录下维护 [PRD §8.3]：

```
.claude/
├── commands/
│   ├── gen-accessory.md    # 生成配件精灵图指令
│   ├── gen-furniture.md    # 生成家具精灵图指令
│   ├── gen-scene.md        # 生成探险场景背景指令
│   └── gen-animation.md    # 生成 SVG 动画效果指令
└── prompts/
    ├── pixel-art-style.md  # 统一像素风格约束（上述内容）
    └── cat-design-guide.md # 猫咪设计规范
```

---

## 十二、Flutter 技术架构

### 12.1 核心包推荐

综合两轮调研确认的 Flutter 包清单：

| 包名 | 用途 | 优先级 | 信息来源 |
|------|------|--------|---------|
| `flame` | 核心 2D 游戏引擎（精灵、游戏循环、组件） | 必备 | Flame 文档 [S33] |
| `rive` | 交互式猫咪动画 + 骨骼动画状态机 | 必备 | Medium Rive vs Lottie [S34]、Themomentum [S36] |
| `flutter_riverpod` | 全局状态管理 | 必备（已使用） | 项目现有 |
| `flame_riverpod` | 桥接 Riverpod 到 Flame 组件 | 必备 | pub.dev [S35] |
| `flame_tiled` | 加载 Tiled 编辑器地图（猫屋/探险场景） | 推荐 | Flame 文档 [S33] |
| `pixelify_flutter` | 像素风 UI 组件（按钮/进度条/面板/CRT 效果） | 推荐 | pub.dev [S64] |
| `pixelarticons` | 像素风图标字体 | 推荐 | GitHub [S65] |
| `fl_chart` | 雷达图/热力图/趋势图 | 推荐（统计页面） | 项目可能已使用 |
| `flutter_svg` | 渲染 SVG（配合 DiceBear 等） | 推荐 | pub.dev |
| `lottie` | UI 微交互（庆祝、加载） | 可选 | Medium [S66] |
| `bonfire` | RPG 框架（寻路/NPC AI/对话，建在 Flame 上） | 评估 | pub.dev |
| `pixel_art_generator` | 程序化像素画模板 | 评估 | pub.dev [S57][S58] |

### 12.2 Rive vs Lottie 决策

| 维度 | Rive | Lottie | 决策 |
|------|------|--------|------|
| 交互性 | 支持状态机、实时输入 | 仅播放动画 | Rive 胜 |
| 性能 | ~60fps（自有渲染器） | ~17fps（复杂动画） | Rive 胜 |
| 运行时换装 | 支持（切换图层/填充色） | 不支持 | Rive 必选 |
| 文件大小 | 更小 | 较大 | Rive 胜 |
| 创作工具 | Rive Editor（免费） | After Effects + Bodymovin | 平手 |
| 像素画兼容 | 需注意禁用抗锯齿 | 同上 | 平手 |

**结论**：**猫咪角色用 Rive**（需要状态机切换 idle/happy/sleep/eat/play + 运行时换装），**UI 微交互用 Lottie**（庆祝烟花/加载动画等一次性播放）[S34][S36]

**信息来源**：Medium Rive 对比 [S34]、Themomentum [S36]、Medium Rive 2025 指南 [S67]

### 12.3 架构设计原则

基于 PRD 的架构约束 [PRD §12] + 调研补充：

1. **Flutter App + 嵌入式游戏元素**（不是"游戏+App 功能"）
   - 主体是标准 Flutter App（习惯管理、设置、统计）
   - Flame `GameWidget` 仅嵌入猫屋和探险场景
   - `overlayBuilderMap` 在游戏画布上叠加 Flutter 原生 UI [S33]

2. **Riverpod 统一状态**
   - 习惯完成 → Riverpod Provider 更新 → 同时触发：
     - 猫咪 Rive 状态机（快乐动画）
     - XP 进度条（Flutter Widget）
     - 探险进度（Flame 游戏逻辑）
   - 确保 Flutter UI 和 Flame 游戏组件响应同一数据源

3. **检定引擎纯 Dart 实现**
   - 不依赖网络，离线可用
   - 数据存 SQLite 本地台账，Firestore 异步同步

4. **像素画渲染关键技巧**
   - 所有 `Paint` 对象设置 `FilterQuality.none`，禁用抗锯齿 [S33]
   - `SpriteBatch` 批量渲染同一图集中的多个精灵（性能关键）[S33]

5. **质量闸门** [PRD §12]
   - 文件 ≤ 800 行
   - 函数 ≤ 30 行
   - 嵌套 ≤ 3 层
   - 分支 ≤ 3

---

## 十三、决策框架

### 13.1 必须做的

| 功能 | 理由 | 来源依据 |
|------|------|---------|
| 软惩罚（心情变差），拒绝强惩罚 | Habitica 扣血造成焦虑 [S5]；Finch 零惩罚 Day-1 留存 60% [S13] | 竞品对比 |
| 骰子动画展示数学过程 | BG3 证明"展示数学=制造戏剧性" [S23] | BG3 分析 |
| 完成习惯=永远成功 | 防止真实努力被随机数否定 | PRD + 游戏化心理学 |
| 弹性连击（5/7 天） | 断连导致弃用是头号流失原因 [S62] | 连击研究 |
| 多层反馈（XP+动画+属性+进度） | 开罗游戏核心设计原则 [P9][S24] | 开罗分析 |
| 探险结果延时揭晓 | 开罗的检验延时设计 [P9]，制造打开动机 | 开罗分析 |
| 内置截图/卡片分享 | Neko Atsume 病毒增长的核心驱动 [S15] | 猫系游戏 |
| DND 属性后台静默成长 | 不增加用户日常操作负担 [PRD §1] | PRD 原则 |
| 3 级解锁职业（非 10 级） | Habitica 10 级门槛损害早期留存 [S50] | 竞品教训 |

### 13.2 绝对不做的

| 禁止项 | 理由 | 来源依据 |
|--------|------|---------|
| ❌ 强制每日登录 | 变成另一个焦虑来源，破坏工具定位 | PRD §10 |
| ❌ 猫咪死亡/永久消失 | 用户情感投入不可承受的损失 | PRD §10 + Finch 模式 [S10] |
| ❌ PVP / 竞争排行榜 | 将内在动机外化为社会比较 [S59] | 游戏化学术 |
| ❌ 付费解锁核心成长 | 破坏"付出即得到"核心契约 | PRD §10 |
| ❌ 实时战斗/Boss | 过度游戏化，偏离工具定位 | PRD §10 |
| ❌ 多猫合并/消耗 | 猫=习惯，删猫=删数据 | PRD §10 |
| ❌ 抽卡/盲盒 | 稀有性脱离真实行为 | PRD §10 |
| ❌ 放置挂机产出 | 金币/XP 必须反映真实行为 | 工具感底线 |

### 13.3 可以考虑但需谨慎的

| 功能 | 风险 | 缓解方案 |
|------|------|---------|
| 限时活动皮肤 | FOMO 压力 | 活动结束后仍可通过其他方式获取（只是更贵） |
| 好友系统 | 高维护成本 | Phase 4 最后做，先验证核心循环 |
| AI 生成叙事 | 质量不稳定 | 本地预设文本 fallback |
| 周挑战 | 可能变成负担 | 奖励为锦上添花而非必需品 |
| 白噪音功能 | 开发成本 | 先用简单音频播放，不做复杂功能 |

---

## 十四、功能路线图

### Phase 1：打磨 MVP（4-6 周）

**目标**：现有功能变得精致，增加消费场景

- [ ] 激活 accessories 系统（首批 8 件配件，AI 生成）
- [ ] 猫咪闲置动画帧序列
- [ ] Full House 全屏庆典升级（粒子+猫咪跳舞）
- [ ] 猫屋 3-5 件可解锁家具
- [ ] 对话文案扩充（6×4=24 → 100+）
- [ ] 金币商店 MVP

### Phase 2：DND 属性系统（6-8 周）

**目标**：DND 六维属性可见化

- [ ] Cat 数据模型新增 6 属性字段（Firestore + SQLite）
- [ ] 属性成长逻辑（纯后台计算）
- [ ] Stats Tab "冒险者档案"雷达图
- [ ] Cat Detail Screen 属性面板
- [ ] 用户等级 + 职业选择（3 级解锁）

### Phase 3：探险系统 MVP（8-12 周）

**目标**：DND 探险核心循环上线

- [ ] Tab 3 探险地图（15 个初始场景卡）
- [ ] 技能检定引擎（纯 Dart，离线可用）
- [ ] BG3 风格骰子动画（Rive）
- [ ] 文字叙事生成（Firebase AI + 本地 fallback）
- [ ] 探险奖励：金币 + 3 件探险专属配件

### Phase 4：猫咪结合 + 社交（12+ 周）

**目标**：多猫协作 + 分享增长

- [ ] 猫咪结合系统（配对探险）
- [ ] 进度分享（猫咪截图卡片）
- [ ] 周挑战系统
- [ ] 好友系统（参考 Forest 多人模式）
- [ ] 扩展探险区域和场景卡

---

## 十五、完整信息来源索引

### 第一轮调研来源（本会话 Deep Research）

| 编号 | 来源标题 | URL | 类型 |
|------|---------|-----|------|
| S1 | SRD v5.2.1 - D&D Beyond | https://www.dndbeyond.com/srd | 官方文档 |
| S2 | Proficiency - 5e 2024 SRD | https://5e24srd.com/playing-the-game/proficiency.html | 规则参考 |
| S3 | SRD_CC_v5.2.1.pdf | https://media.dndbeyond.com/compendium-images/srd/5.2/SRD_CC_v5.2.1.pdf | 官方 PDF |
| S4 | Habitica - Wikipedia | https://en.wikipedia.org/wiki/Habitica | 百科 |
| S5 | Habitica's Gamification Strategy - Trophy | https://trophy.so/blog/habitica-gamification-case-study | 案例研究 |
| S6 | Habitica Review & Alternatives - ProdApps | https://productivity-apps.com/apps/habitica | 评测 |
| S7 | Forest's Gamified Focus - Appcues | https://goodux.appcues.com/blog/forests-gamified-focus | UX 分析 |
| S8 | Forest Gamification Case Study - Trophy | https://trophy.so/blog/forest-gamification-case-study | 案例研究 |
| S9 | Forest App Success Story - AppSamurai | https://appsamurai.com/blog/mobile-app-success-story-forest-by-seekrtech/ | 商业分析 |
| S10 | Finch Review - Eat Proteins | https://eatproteins.com/finch-review/ | 评测 |
| S11 | UX Teardown: Finch - Medium | https://medium.com/@deepthi.aipm/ux-teardown-finch-self-care-app-18122357fae7 | UX 拆解 |
| S12 | Finch Showcase - ScreensDesign | https://screensdesign.com/showcase/finch-self-care-pet | UI 分析 |
| S13 | New Horizons in Habit-Building Gamification - Naavik | https://naavik.co/deep-dives/deep-dives-new-horizons-in-gamification/ | 行业深度 |
| S14 | Neko Atsume - Wikipedia | https://en.wikipedia.org/wiki/Neko_Atsume | 百科 |
| S15 | Game Design Breakdown: Neko Atsume - Medium | https://alexiamandeville.medium.com/game-design-breakdown-the-simplicity-of-neko-atsume-a8616a937a47 | 设计分析 |
| S16 | Neko Atsume: Universal Usability - Medium | https://medium.com/@laurielepham/neko-atsume-a-lesson-in-universal-usability-4c54a1507a84 | UX 分析 |
| S17 | Incidental Learning in Neko Atsume - ResearchGate | https://www.researchgate.net/publication/311886688 | 学术论文 |
| S18 | Cats & Soup - Sensor Tower | https://app.sensortower.com/overview/1581431235?country=US | 市场数据 |
| S19 | CatSwoppr Review: Cats and Soup | https://www.catswoppr.io/post/catswoppr-game-review-cats-and-soup | 评测 |
| S20 | Currencies - Cats & Soup Wiki | https://catsandsoup.miraheze.org/wiki/Currencies | Wiki |
| S21 | Baldur's Gate 3 - Wikipedia | https://en.wikipedia.org/wiki/Baldur%27s_Gate_3 | 百科 |
| S22 | BG3's D&D Systems - Game Developer | https://www.gamedeveloper.com/design/what-works-and-doesn-t-work-about-baldur-s-gate-3-s-use-of-d-d-systems | 专业分析 |
| S23 | BG3 Dice-Rolling Interface - Gaming Respawn | https://gamingrespawn.com/features/54148/baldurs-gate-iiis-new-dice-rolling-interface-truly-captures-the-feeling-of-dd-ability-checks/ | UX 评测 |
| S24 | Kairosoft Games: Progression Mastered | https://entertainmentanalytical.blog/2024/06/01/kairosoft-games-progression-mastered/ | 设计分析 |
| S25 | Game Dev Story - Kairosoft Wiki | https://kairosoft.fandom.com/wiki/Game_Dev_Story | Wiki |
| S26 | Game Dev Story - Wikipedia | https://en.wikipedia.org/wiki/Game_Dev_Story | 百科 |
| S27 | Sprite Sizes / Character Sheets - Stardew Valley Forums | https://forums.stardewvalley.net/threads/sprite-sizes-character-sheets-pixel-art.5597/ | 社区讨论 |
| S28 | 2D Pixel Art Style Guide - Sprite-AI | https://www.sprite-ai.art/blog/2d-pixel-art-style-guide | 风格指南 |
| S29 | PixelLab - AI Pixel Art Generator | https://www.pixellab.ai/ | 工具官网 |
| S30 | Pixel Art AI: PixelLab - Bytethesis | https://bytethesis.one/posts/pixel-art-ai-pixel-lab | 评测 |
| S31 | AI Pixel Art Generator: 8 Tools - Aiarty | https://www.aiarty.com/ai-image-generator/ai-pixel-art-generator.htm | 工具对比 |
| S32 | Aseprite - GitHub | https://github.com/aseprite/aseprite | 开源工具 |
| S33 | Flame Engine - Images Documentation | https://docs.flame-engine.org/latest/flame/rendering/images.html | 技术文档 |
| S34 | Rive vs Lottie for Flutter - Medium | https://medium.com/@imaga/rive-animation-for-flutter-apps | 技术对比 |
| S35 | flame_riverpod - pub.dev | (pub.dev/packages/flame_riverpod) | 包文档 |
| S36 | Flutter X Rive - Themomentum | https://www.themomentum.ai/blog/flutter-x-rive---create-smooth-flutter-animations | 教程 |
| S37 | SDT in Gamification - Springer | https://link.springer.com/article/10.1007/s11528-024-00968-9 | 学术论文 |
| S38 | Theory in Gamification Research - ScienceDirect | https://www.sciencedirect.com/science/article/pii/S0747563221002867 | 系统综述 |
| S39 | Overjustification Effect - Wikipedia | https://en.wikipedia.org/wiki/Overjustification_effect | 百科 |
| S40 | Cat Avatar Generator - GitHub | https://github.com/vicalejuri/cat-avatar-generator | 开源工具 |
| S41 | Cat Avatar Generator - Framagit | https://framagit.org/Deevad/cat-avatar-generator | 开源工具 |
| S42 | DiceBear Avatar Library | https://www.dicebear.com/ | 工具官网 |
| S43 | D&D SRD v5.2 - Tribality | https://www.tribality.com/2025/04/23/dd-system-reference-document-v5-2/ | 新闻报道 |
| S44 | D&D SRD 5.2 - Roll20 | https://pages.roll20.net/dnd-srd | 平台页面 |
| S45 | Level Advancement (5e24) - dnd-wiki.org | https://dnd-wiki.org/wiki/Level_Advancement_(5e24) | Wiki |
| S46 | Finch Editors' Choice - FoxData | https://foxdata.com/en/blogs/finch-as-app-store-editors-choice-a-self-care-companion/ | 新闻 |
| S47 | $12M Mental Health App - Medium | https://medium.com/@jashsak/the-12m-mental-health-app-that-broke-every-silicon-valley-rule-bd9d06e725f8 | 商业分析 |
| S48 | Finch Review - Autonomous.ai | https://www.autonomous.ai/ourblog/finch-self-care-app-review-full-breakdown | 评测 |
| S49 | Finch Review - Yoga Journal | https://www.yogajournal.com/lifestyle/finch-self-care-app/ | 评测 |
| S50 | Habitica Alternatives - Habi.app | https://habi.app/insights/habitica-alternatives/ | 竞品分析 |
| S51 | New DnD SRD Rules - D&D Fan | https://dungeonsanddragonsfan.com/dnd-srd-new-rules/ | 新闻 |
| S52 | Proficiency | D&D 2024 - Roll20 | https://roll20.net/compendium/dnd5e/Rules:Proficiency | 规则参考 |
| S53 | Habitica Reviews - Trustpilot | https://www.trustpilot.com/review/habitica.com | 用户评价 |
| S54 | How Forest App Did It - Medium | https://medium.com/@heiko.damaske_86475/how-did-the-forest-app-do-it-673a5976f7b | 分析 |
| S55 | Habicat - App Store | https://apps.apple.com/us/app/habicat-gamified-habit/id6444766871 | 竞品 |
| S56 | Habicat - App Store (评价) | (同上) | 用户评价 |
| S57 | pixel_art_generator - pub.dev | https://pub.dev/packages/pixel_art_generator | Flutter 包 |
| S58 | pixel_art_generator (详情) | (同上) | 包文档 |
| S59 | Dark Side of Gamification - Growth Engineering | https://www.growthengineering.co.uk/dark-side-of-gamification/ | 分析 |
| S60 | 31 Core Gamification Techniques - Medium | https://sa-liberty.medium.com/the-31-core-gamification-techniques-part-3-engagement-loops-d2cc457860e3 | 专家分析 |
| S61 | Streaks for Gamification - Plotline | https://www.plotline.so/blog/streaks-for-gamification-in-mobile-apps | 最佳实践 |
| S62 | Designing Streaks for Growth - Mind the Product | https://www.mindtheproduct.com/designing-streaks-for-long-term-user-growth/ | 产品设计 |
| S63 | Best Gamified Habit App 2026 - GAMIFICATION+ | https://gamificationplus.uk/which-gamified-habit-building-app-do-i-think-is-best-in-2026/ | 行业评测 |
| S64 | pixelify_flutter - pub.dev | https://pub.dev/documentation/pixelify_flutter/latest/ | Flutter 包 |
| S65 | pixelarticons - GitHub | https://github.com/alexcmgit/pixelarticons | 图标库 |
| S66 | Lottie Animations in Flutter - DEV | https://dev.to/sayed_ali_alkamel/lottie-animations-in-flutter | 教程 |
| S67 | Rive Animation 2025 Guide - Medium | https://uianimation.medium.com/rive-animation-for-app-development-the-ultimate-2025-guide-8869fe52e43c | 指南 |

### 第二轮调研来源（上传 PRD 引用）

| 编号 | 来源标题 | URL |
|------|---------|-----|
| P1 | Forest's Gamified Focus - Appcues | https://goodux.appcues.com/blog/forests-gamified-focus |
| P2 | Forest Gamification - UX Planet | https://uxplanet.org/what-to-learn-from-the-forest-apps-gamification-5d8fe48eb4f4 |
| P3 | Habitica Video Guide - YouTube | https://www.youtube.com/watch?v=230NecNTaSA |
| P4 | Stardew Valley Game Design - YouTube | https://www.youtube.com/watch?v=BYHtzIphtKk |
| P5 | ConcernedApe Pixel Art Interview | https://mentalnerd.com/blog/getting-started-pixel-art-interview/ |
| P6 | Ability Scores - 5eSRD | https://www.5esrd.com/tools-resources/system-reference-document-5-1-1/ability-scores/ |
| P7 | SRD v5.2.1 - D&D Beyond | https://www.dndbeyond.com/srd |
| P8 | SRD Conversion Guide - YouTube | https://www.youtube.com/watch?v=swGASXxGKok |
| P9 | 开罗游戏设计分析 - Indienova | https://indienova.com/indie-game-development/design-analysis-of-kairosoft-games/ |
| P10 | Claude+Gemini Game Art Workflow - YouTube | https://www.youtube.com/watch?v=9XsX7CFljkk |
| P11 | PixelLab MCP + Claude Code - YouTube | https://www.youtube.com/watch?v=THwZYWuOdZI |
| P12 | Pixel Art Creator - MCP Market | https://mcpmarket.com/zh/tools/skills/pixel-art-creator |
| P13 | SVGMaker.io | https://theresanaiforthat.com/ai/svgmaker-io/ |
| P14 | Top 10 AI SVG Tools 2026 - SVGMaker | https://svgmaker.io/blogs/top-10-ai-svg-generation-tools-in-2026-compared |
| P15 | AI SVG Animation Tools 2026 - VectoSolve | https://vectosolve.com/blog/ai-svg-animation-tools-2026 |
| P16 | Stardew Valley Pixel Art Style - Reddit | https://www.reddit.com/r/PixelArt/comments/1py13zy/ |
| P17 | Forest App Review - Voxel Hub | https://voxelhub.org/contributor-post/forest-app-review/ |

---

> **报告结束**。本文档融合了两轮独立调研的全部发现，覆盖法律合规、竞品分析、游戏设计理论、心理学研究、技术架构和美术方案六大维度。所有关键结论均标注可追溯来源编号。建议将本文档作为 Hachimi v2.0 开发的统一参考基线。
