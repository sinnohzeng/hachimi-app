# Finch 全面竞品对标报告（2026 版）
> 面向猫咪主题习惯打卡 App 的深度参照研究

***

## 一、产品概述与核心背景

Finch: Self Care Pet 是一款以「自我关怀」为核心的虚拟宠物养成 + 习惯追踪 App，由 Nino（Thomas Aquinas Nugraha Budi）和 Stephanie Yuan 联合创立。两位创始人均有抑郁和焦虑症的亲身经历，在历经 **8 次失败**之后才找到这套有效的设计公式。App 于 2021 年上线，至 2026 年 2 月已积累约 **1000 万日活用户（DAU）**，估算月收入超过 **800 万美元**（移动端 IAP $300 万 + Web 端 $500 万+），年化收入已突破 $9600 万美元。[^1][^2][^3]

Finch 以「**你照顾你自己，就是在照顾你的小鸟**」为核心哲学，将习惯打卡从枯燥的自我管理升华为一场与虚拟伙伴共同成长的情感旅程。它的最终形态不像一款传统习惯工具，更接近一个将心理学与游戏化深度融合的「精神健康伴侣」。[^2]

***

## 二、核心游戏循环（Core Loop）

Finch 的核心机制是一个由四个环节构成的正反馈飞轮：[^4]

```
完成目标 → 获得能量 → 小鸟出发冒险（8小时实时）→ 带回彩虹石
    ↑                                                     ↓
每日任务 ←←←←←←←←← 彩虹石 → 商店购买自定义道具
```

### 四个关键环节

**1. 完成目标（Tasks → Energy）**
每完成一项自定义目标，获得 +5 能量。呼吸练习、日记写作、音景聆听等内置活动也提供能量。满能量后小鸟才能出发「冒险」。能量满值随成长阶段递增：雏鸟期 15 → 成年期 35。[^4]

**2. 冒险机制（Adventure，8 小时实时）**
小鸟出发后在真实世界中「离开 8 小时」——这是 Finch 最精妙的习惯设计：每完成一个目标，冒险时间缩短 10 分钟，自然驱动用户白天多次打开 App，晚上等候小鸟归来。冒险回来后，小鸟带回彩虹石和随机「探险日记」故事，制造开箱感与期待感。[^1][^4]

**3. 彩虹石（Rainbow Stones）**
游戏内唯一软货币，**无法直接购买**，只能通过完成目标、每日任务、好友互动、冒险等方式赚取。这一设计将游戏进度与现实行为牢牢绑定——每一颗彩虹石都承载着用户真实的行动记忆。[^4]

**4. 消费与成长**
彩虹石用于服装店、家具店、颜色工作室和旅行目的地四个商店，驱动小鸟的外观自定义和成长。此外，每月限时季节活动提供限量服装，构成类「Battle Pass」的长期留存机制。[^4]

***

## 三、小鸟成长阶段系统

小鸟历经 5 个成长阶段，每阶段由累计冒险次数触发，渐进式解锁更多自定义权限。这种设计让用户**永远知道下一个里程碑在哪里**，形成持续的「再坚持一下」驱动力。[^4]

| 阶段 | 解锁冒险次数 | 满能量值 | 冒险时长 | 新解锁内容 |
|------|:-----------:|:-------:|:-------:|-----------|
| 蛋 → 雏鸟 | 第 1 次 | 15 | ~8 小时 | 服装店、家具店 |
| 幼儿期 | 第 8 次 | 20 | ~7 小时 | 颜色工作室（喙/身体） |
| 儿童期 | 第 23 次 | 25 | ~6 小时 | 颜色工作室（头斑/翅膀）、旅行功能 |
| 青少年期 | 第 43 次 | 30 | ~6 小时 | 颜色工作室（脸颊/脚） |
| 成年期 | 第 68 次 | 35 | ~6 小时 | 颜色工作室（腹部完整自定义） |

***

## 四、引导流程（Onboarding）全解析

Finch 的引导流共 **28 屏**，遵循一条铁律：**先建立情感依恋，再展示功能**。[^2]

**引导流程的关键决策序列：**

1. **选蛋壳颜色**（而不是注册邮箱）——第一个操作即传递价值观：*你自己比你的个人信息更重要*[^1]
2. **填写昵称 + 选代词**（他/她/ta），不要求实名，极低门槛[^1]
3. **5-6 道引导问卷**（睡眠时长、起床困难、需要哪类支持），根据答案自动生成第一批目标，解决冷启动问题[^1]
4. **命名小鸟** + 即时解锁里程碑奖励——首次体验「完成→奖励」正反馈循环[^1]
5. **三张小卡片**简述核心循环，请求通知授权（可跳过）[^1]
6. **引导添加 Widget**，实现「不进 App 也能看到小鸟」的钩子[^1]
7. **目标库选择** + 可选付费引导，最终抵达主页

D1 留存率因此高达约 **60%**，在订阅制 App 中属于行业顶尖水平。[^4]

***

## 五、用户体验地图：5 个引力层

Finch 的 UX 由五个时间尺度递进的「引力层」叠加构成：

| 层次 | 内容 | 时间特征 |
|------|------|---------|
| 层 1：引导层 | 孵蛋 → 命名 → 性格问卷 | 一次性，约 5-8 分钟 |
| 层 2：日常循环层 | 打卡 → 能量 → 冒险 → 归来 | 每天，多次打开 |
| 层 3：成长层 | 小鸟成长阶段 → 解锁自定义功能 | 周级、累积 |
| 层 4：元游戏层 | 商店 / 季节活动 / 每日任务 | 月级、长期 |
| 层 5：社交层 | Tree Town / Goal Buddies / Guardian | 持续黏性 |

***

## 六、激励心理学：Finch 的行为设计底层

Finch 并没有向用户暴露任何心理学术语，但其每个设计决策都有坚实的行为科学依据。[^4]

### 6.1 Fogg 行为模型（B = MAP）

Fogg 行为模型指出，行为（B）只在**动机（M）、能力（A）、提示（P）**三者同时具备时才会发生。Finch 的精妙之处在于它三者兼顾：[^5][^6]

- **动机**：对小鸟的情感依恋（本能的养育/陪伴欲）
- **能力**：极低摩擦的目标打卡设计（1 秒完成一项）
- **提示**：推送通知 + 小鸟等待能量的视觉状态

### 6.2 自我决定论（Self-Determination Theory）

SDT 认为内在动机需要三个基础：自主感、胜任感、关系感。Finch 对应实现：[^5]
- **自主感**：自定义目标内容、频率、分类
- **胜任感**：小目标低门槛 + 渐进式解锁
- **关系感**：Good Vibes、Goal Buddies、Guardian 礼赠

### 6.3 可变比率强化（Variable Ratio Reinforcement）

Finch 借鉴了行为心理学中最强力的奖励机制：不定时发放惊喜奖励（神秘礼物包、随机冒险故事、随机道具掉落）。这种「偶尔惊喜」比固定奖励更能维持长期行为动力，原理类似老虎机，但服务于健康目的。[^4]

### 6.4 情感设计（Emotional Engineering）

Sophie Pilley 的设计分析将 Finch 定位为创造了治疗师所说的「**抱持环境（holding environment）**」——一个让人感到安全、可以脆弱的空间。具体实现包括：小鸟歪头眨眼模拟「主动倾听」、触觉反馈模拟「轻柔身体接触」、成就音效「庆祝但不惊吓」、非惩罚性设计消除失败羞耻感。[^2]

### 6.5 非惩罚性设计（Non-Punitive Design）

这是 Finch 区别于大多数习惯 App 的最核心价值观：**小鸟永远不会死**。用户消失一周回来，小鸟仍然健康快乐。这对有焦虑、抑郁、ADHD 的核心用户群尤为关键——传统 Streak 机制带来的失败感往往是用户放弃的主要原因。[^7]

***

## 七、多感官反馈系统（三重 Juice 设计）

「Juice」是游戏设计中的专业术语，指同一个用户操作同时触发视觉+听觉+触觉三重反馈，让简单操作感觉「有分量」。Finch 的任务完成体验正是经典的 Juice 设计：[^2]

```
用户完成一项目标
  ├→ 视觉：彩虹石上浮动画 + 小鸟跳跃表情
  ├→ 听觉：「叮」音效（连续完成时音高递增，形成上行音阶）
  └→ 触觉：轻微 HapticFeedback.lightImpact()

全部目标完成时：
  ├→ 视觉：全屏粒子庆祝动画 + 小鸟跳舞
  ├→ 听觉：庆祝和弦 + 「Full House」提示
  └→ 触觉：较重震动反馈
```

这种连锁正反馈音效设计可称为「**奖励音阶级联（Reward Chime Cascade）**」——连续完成任务时依次播放 C→D→E→F→G 音阶，让打卡本身产生如弹奏乐器般的愉悦感。[^2]

***

## 八、社交系统全解析

### 8.1 Tree Town（树镇）

通过好友码添加好友，构建小型社交圈。核心互动机制：[^4]

- **Good Vibes**：每天可互赠，发送/接收方各获 +3 能量，接收方额外 +2 彩虹石
- **好友小鸟来访**：好友的小鸟大约每小时会「串门」一次
- **树镇展示**：所有好友的小鸟聚集在一棵大树上

### 8.2 Goal Buddies（目标搭档）

2025 年 4 月上线（v3.73.0）的新社交功能：允许用户与好友共同承诺同一目标，互相可见对方的完成进度。2025 年 8 月进一步升级为**无限期持续**的 Accountability Buddies（责任搭档），加强了「虚拟自习室」的陪伴感。[^8][^9]

### 8.3 Guardian 礼赠计划

任何人可在 Finch 官网通过 **Stripe** 支付购买 Plus 订阅赠给他人，无需知道对方真实身份。截至报告撰写时，已有超过 **163,000 名用户**通过此系统接受了他人的礼赠。这一机制的精妙之处在于：它将「付费」包装成了「利他行为」，使订阅决策从「我要不要花钱」变成了「我能不能帮助别人」。[^2]

***

## 九、商业模式深度解析

### 9.1 双轨收入结构

Finch 建立了业内罕见的「移动端 + Web 端」双轨变现架构，这是其收入规模远超 App 内营收的核心秘密：[^10][^3]

| 收入来源 | 渠道 | 月收入估算 |
|---------|------|:--------:|
| 移动端 IAP | App Store (iOS) + Google Play | ~$300 万 |
| Web 端订阅 | 官网 + Stripe 支付 | ~$500 万+ |
| **合计** | — | **$800 万+** |

Web 端收入通过 Stripe 直接处理，**完全绕过 App Store 和 Google Play 的 15-30% 抽成**，极大提升了实际利润率。[^1]

### 9.2 付费层级设计

| 功能 | 免费版 | Finch Plus |
|------|:------:|:----------:|
| 无限目标设置 | ✅ | ✅ |
| 基础活动（呼吸/日记） | ✅ | ✅ |
| 急救包（危机干预） | ✅ 永久免费 | ✅ |
| 高级呼吸/反思练习（100+） | ❌ | ✅ |
| 商店 50% 折扣 | ❌ | ✅ |
| Atticus Times 通讯邮件 | ❌ | ✅ |
| Cloud Backup 云备份 | ❌ | ✅ |
| 每月限时活动提前解锁（Day 20 vs Day 25） | Day 25 | Day 20 |

### 9.3 Android vs iOS 定价争议

这是 Finch 社区最持续发酵的舆论危机：iOS 年费 **$14.99/年**，Android 年费 **$69.99/年**，差距高达 **365%**。对于一个以「公平与关怀」为品牌价值观的 App，此定价策略与产品理念严重背道而驰，已造成相当的品牌信任损耗。[^11]

### 9.4 用户获取（UA）策略

Finch 在 Meta、TikTok 投放大量「**wall-of-text POV 文字流广告**」和「第一人称自白视频」，这类创意策略能以低成本精准触达有心理健康需求的目标用户。同时，用户自发在 TikTok 和 Reddit 分享的「真实体验帖」形成了极强的口碑 UA 飞轮。[^1]

***

## 十、2025 年重大更新与产品演进

2025 年是 Finch 产品迭代最密集的一年，但也是争议最多的一年。

### 正向更新

| 日期 | 版本 | 更新内容 | 意义 |
|------|------|---------|------|
| 2025-04-03 | v3.73.0 | **Goal Buddies** 上线 | 深化社交层，虚拟陪伴感 |
| 2025-04-17 | v3.73.5 | **App Pause 暂停模式** | 压力缓解，保护 Streak 不流失 |
| 2025-05-01 | v3.73.13 | **Streak Repair 免费修复**（每 3 次冒险存 2 次）+ Cloud Backup 正式化 | 降低因中断放弃的概率 |
| 2025-06-05 | v3.73.21 | **Accountability Buddies** | 从「共同目标」升级为持续陪伴 |
| 2025-08-08 | v3.73.52 | Goal Buddies 升级为无限期 | 长效社交留存 |

### 争议性变更

**Journeys → Self-care Areas 替换（2025 年 5 月）**[^12][^8]
`Journeys`（旅程）是大量 ADHD 和慢性病用户依赖的弹性目标组织系统。2025 年 5 月，Finch 将其完全删除并替换为`Self-care Areas`（自我关怀区域）。社区反应激烈，许多用户表示自己多年来精心组织的目标结构被强制重置，「感觉被抛弃」。这是迄今 Finch 引发最强烈负面反馈的单次功能变更。[^12]

**AI 广告素材争议（2025 年 Q4）**[^13]
10 月，社区发现 Finch 开始在广告中使用 AI 生成的图像创意，随即引发大规模「出走声明」帖，标志性的帖子《Goodbye, Finch》获得 1181 票支持和 188 条评论。用户认为此举违背了 Finch 作为「人文关怀 App」的初心，部分忠实用户宣布取消续费。[^13]

***

## 十一、Micropets 系统——第三层玩法

Micropets 是 Finch 在主小鸟之外构建的**第三层收藏玩法**，截至 2026 年 2 月已有 **58 只**微型宠物可供收集。[^14]

**获取方式有两条路径：**

1. **季节活动奖励**：每月限时活动坚持完成足够冒险次数（普通用户 25 天，Plus 用户 20 天）自动获得当月主题 Micropet[^14]
2. **孵蛋系统**：在「Professor Oat's Lab」领取彩蛋，将其绑定到一个目标，连续完成该目标 **7 天**后孵化[^15][^16]

每只 Micropet 拥有独特的行走/站立/睡眠动画和专属声音，可以陪同主小鸟一起冒险。这套系统巧妙地为**习惯养成（7 天坚持）**设计了具体奖励，将抽象的「培养习惯」转化为「孵化宠物」的具体体验。

***

## 十二、竞品全面对标矩阵

### 12.1 核心竞品概览

| App | 核心定位 | 游戏化程度 | 惩罚机制 | 宠物系统 | 社交 | 主要定价 | D1 留存 |
|-----|---------|:---------:|:-------:|:-------:|:----:|---------|:------:|
| **Finch** | 自我关怀伴侣 | ⭐⭐⭐⭐⭐ | ❌ 零惩罚 | ✅ 小鸟成长 | 中 | $70/年（Android） | ~60%[^4] |
| **Habitica** | 生产力 RPG | ⭐⭐⭐⭐⭐ | ✅ 扣血扣经验 | ❌ | 强 | 免费/$5月[^17] | — |
| **SuperBetter** | 心理韧性游戏 | ⭐⭐⭐⭐ | ❌ | ❌ | 弱 | 免费增值 | — |
| **Daylio** | 心情日志 | ⭐⭐ | ❌ | ❌ | ❌ | 免费增值 | ~65%[^4] |
| **Fabulous** | 科学行为教练 | ⭐⭐ | ❌ | ❌ | ❌ | $40-100/年[^17] | — |
| **Habitify** | 数据驱动追踪 | ⭐ | ❌ | ❌ | ❌ | $5/月[^17] | — |
| **Neko Atsume** | 极简猫咪收集 | ⭐⭐ | ❌ | ✅ 猫咪来访 | ❌ | 免费+买断 | — |

### 12.2 Habitica 深度对标

Habitica 是 Finch 在「游戏化程度」上最接近的竞品，也是 DND 融合方向最直接的参照：[^17]

- **职业系统**：4 大职业（战士/法师/治愈者/盗贼），**第 10 级**后才解锁，避免新手过载[^17]
- **公会和 BOSS 战**：用户可以组成团队共同攻打 BOSS，漏打卡会对队友造成真实伤害——这是 Habitica 的双刃剑，社交压力有效但可能引发焦虑[^17]
- **装备系统**：完成任务掉落装备，装备影响数值成长——真正的 RPG 闭环
- **致命弱点**：无任何情感支持层，无呼吸练习，无心理健康功能，对焦虑/抑郁用户**可能有害**

**Habitica vs Finch 的本质差异**：Habitica 是「用游戏惩罚失败」，Finch 是「用游戏奖励成功」。这一哲学差异决定了用户群体的根本不同。

### 12.3 SuperBetter 深度对标

SuperBetter 是学术背书最强的竞品，有 NIH 研究和宾夕法尼亚大学的随机对照实验支持：[^18]

- **叙事框架**：坏习惯 = 「Bad Guys（反派）」，好习惯 = 「Power-ups（能量提升）」，好友 = 「Allies（同盟）」——这正是 DND 世界观的精简版[^19]
- **节制设计**：主动限制每天可完成的成就数量，防止过度游戏化导致的空洞感
- **不惩罚不打开**：消失一周回来不受任何惩罚
- **致命弱点**：UI 过时、情感温度低、无宠物陪伴，用户留存远不如 Finch

### 12.4 Neko Atsume 的极简主义启示

Neko Atsume（猫咪收集）是「零压力」极端案例：「投食→等待→猫咪来访→收集」的极简循环，没有惩罚，没有强制参与。UGA 学术研究表明其成功源于玩家对像素猫产生的「概念性情感（conceptual affect）」——即便只是像素，依然能引发真实的依恋感。这对猫咪主题 App 尤其有参照价值：**有时候宠物「只是在那里」本身就足够有魔力**。[^7]

### 12.5 2025 年新兴竞品涌现

Finch 的争议性更新催生了大量「离轨用户」寻找替代品，社区中出现的新竞品包括：[^20]
- **Catzy**：据报道由前 Finch 团队成员创立，采用猫咪主题，定位为「Finch 的精神续集」
- **Ottopia / FoxTale**：类 Finch 架构的新兴宠物养成 App
- **Quabble / Tabby**：更轻量的自我关怀宠物方向

这些竞品的涌现表明：Finch 的核心设计模式已经被验证为可复制的成功公式，但市场对于「更少争议、更清晰定位」的同类产品存在真实需求缺口。

***

## 十三、Finch 的负面案例：失败的产品决策

理解 Finch **做错了什么**与理解它做对了什么同等重要。

### 13.1 功能蔓延（Feature Creep）

Finch 的衰退几乎都始于对核心体验的反复修改。典型症状是：每次更新都在删除或重命名已被用户深度依赖的功能（Journey → Self-care Areas，自动情绪弹窗被移除，Tree Town 非用户标签被删除）。研究者发现，每次重大功能删改后，社区都会出现一批「使用达到数百天的用户宣布放弃」的现象。[^21][^13]

**教训**：功能删减比功能增加风险更大——用户对已建立的使用习惯有极强的情绪依附。

### 13.2 情感承诺的反噬

Finch 的高情感投入设计是其成功的源头，但也是最脆弱的地方。当 AI 广告素材事件（2025 Q4）让用户感觉「被背叛」时，反应远比对待普通 App 激烈得多。情感产品的信任一旦破裂，就像朋友的背叛，远比功能缺陷更难修复。[^13]

**教训**：情感产品必须在所有公开行为（广告、定价、招聘、社区回应）上保持价值观一致性。

### 13.3 过密 UI 对新用户的阻碍

Finch 最频繁出现的差评是「被扔进 App，不知道能量/石头/冒险怎么运作」。一个旨在帮助焦虑用户的 App，其密集的信息层次反而制造了信息焦虑。这对引入 DND 元素的 App 来说是极重要的警示——DND 规则对普通用户远比「彩虹石」更陌生。[^11]

**教训**：功能必须渐进式揭示，绝不能在第一周就暴露所有系统。

### 13.4 忽略平台公平性

Android 用户支付高达 iOS 用户 365% 的价格，被社区普遍认为是对 Android 用户的「歧视」。这一问题被大量差评提及，严重损害了 Finch「关怀弱势群体」的品牌形象。[^11]

***

## 十四、技术栈逆向推断

Finch 从未公开其技术方案，以下基于间接证据的推断：

| 技术层 | 推断 | 依据 |
|-------|------|------|
| **前端框架** | React Native（大概率）| 团队以「Product Engineer」招聘，非「Flutter/iOS Dev」；2021 年 RN 市占更高[^22] |
| **角色动画** | Spine + Lottie（推测）| 动画师 Bella Alfonsi 的作品集显示为 2D 骨骼动画风格[^22] |
| **后端** | AWS 或类似云服务 | 用户账号、冒险数据、订阅管理等需要云支持[^22] |
| **支付** | App Store + Stripe（Web 端）| Guardian 计划需要独立支付系统[^3] |
| **团队规模** | ~5 名工程师 | 2026 年 3 月仍在招聘第 5 名工程师[^22] |

**核心启示**：5 名工程师维护年收入接近 $1 亿美元的产品。这证明聚焦核心体验并做到极致，比堆砌功能更有商业价值。对于 Flutter 技术栈，Flutter 在动画（Rive 状态机）和渲染层面的能力完全能够匹配甚至超越 React Native 方案。[^22]

***

## 十五、对 Hachimi 项目的核心设计洞察

### 15.1 可以直接移植的设计原则

**① 情感优先于功能**
引导流的第一个操作应该是「帮猫猫取名」或「选一只猫咪的花纹」，而不是「设置你的第一个习惯」。先让用户爱上角色，再展示系统。[^2]

**② 现实行为与游戏进度的锁定关系**
Finch 的彩虹石只能赚、不能买——这是核心价值观的设计表达。Hachimi 的任何游戏货币都应遵循同样的原则：**货币是现实行动的记忆，而非付款的收据**。[^4]

**③ 8 小时冒险机制的猫咪版**
「猫咪每天离开营地去冒险，晚上带着 DND 风格的探险报告回来」是最自然的猫咪化版本。早上打卡送猫出门，晚上等候归来，天然产生多次日开动力。[^1]

**④ DND 职业系统应在第 10 级以后才解锁**
Habitica 的经验证明：职业系统不应在第 1 天暴露。DND 的 6 属性（STR/CON/DEX/INT/WIS/CHA）映射到猫咪能力，通过习惯积累自动成长，而不是手动选择。[^17]

**⑤ 非惩罚设计是铁律**
猫咪绝对不能死亡或饥饿。用户消失一周回来，猫咪应该温柔地撒娇，而不是显示愤怒或饥饿。[^2]

**⑥ Micropets 孵蛋机制的直接借鉴**
将 Finch 的 Micropet 孵蛋机制直接移植：将蛋绑定到一个具体目标，连续完成 7 天孵化。这把「养成习惯」转化为「孵化宠物」的具体期待，是最自然的习惯激励机制。[^15]

**⑦ Web 端 Guardian 礼赠**
待产品成熟后，建立 Web 端支付层（绕过 App Store 抽成）+ 用户互赠订阅机制，是 Finch 最具商业智慧的决策。[^3]

### 15.2 DND 元素的正确融合边界

DND 规则书复杂，普通用户无需了解任何规则。融合的核心原则是「**DND 只做命名和包装层，游戏感做深度，工具性做底层**」：

```
日常工具层（0 摩擦）
    ↓ 产生「金币/能量/经验」
宠物养成层（情感核心）
    ↓ 产生「探险事件」
DND 叙事层（戏剧张力）
    ↓ 产生「长期成就感」
世界地图层（成就归档）
```

「猫咪尝试翻越城墙，它的敏捷 +3，掷 d20 = 17，成功！」——用户不需要知道 SRD 5.2.1 的规则，只需感受到随机性带来的戏剧感。[^4]

### 15.3 必须规避的设计陷阱

| 陷阱 | Finch 案例 | 对 Hachimi 的警示 |
|------|-----------|-----------------|
| **功能蔓延** | Journey 删除、自动情绪移除 | MVP 阶段克制添加功能，只做一件事[^21] |
| **密集 UI 无引导** | 新用户不理解能量/石头系统 | DND 元素对普通用户更陌生，必须渐进式揭示[^11] |
| **强制社交** | Tree Town 非用户标签删除 | 习惯 App 用户多独自使用，社交必须完全可选[^13] |
| **平台定价歧视** | Android 4× iOS | Android 与 iOS 定价必须一致[^11] |
| **情感产品 AI 广告** | 2025 Q4 AI 广告素材事件 | 品牌内容必须保持人文温度[^13] |
| **Streak 的两难** | 严格 Streak 导致失败羞耻 | 采用「弹性每周目标」而非严格每日连击；或提供 App Pause 机制[^23] |

***

## 十六、关键数据锚点汇总

| 指标 | 数据 | 来源 |
|------|------|------|
| DAU | ~1000 万（2026 年 2 月） | [^1][^24] |
| 移动端 IAP 月收入 | ~$300 万/月 | [^3][^10] |
| Web 端月收入（估算） | ~$500 万+/月 | [^3] |
| D1 留存率 | ~60% | [^4] |
| D30 留存率 | ~22% | [^4] |
| Guardian 受益用户 | 163,000+ | [^2] |
| Micropets 总数 | 58 只（2026 年 2 月） | [^14] |
| 小鸟成长阶段 | 5 阶段（68 次冒险至成年） | [^4] |
| 引导流屏幕数 | 28 屏 | [^1] |
| 季节活动连续月数 | 40+ 个月（截至 2025 年） | [^4] |
| 团队规模 | ~5 名工程师 | [^22] |
| 创始人失败次数 | 8 次 | [^2] |
| 竞品 Daylio D1 留存 | ~65% | [^4] |

***

## 十七、引用来源索引

| 编号 | 来源名称 | URL |
|------|---------|-----|
| [^25] | The Magic of Finch — Sophie Pilley | https://www.sophiepilley.com/post/the-magic-of-finch-where-self-care-meets-enchanted-design |
| [^22] | New Horizons in Habit-Building Gamification — Naavik | https://naavik.co/deep-dives/deep-dives-new-horizons-in-gamification/ |
| [^26] | How Finch turned self-care into a $100M+ game — two & a half gamers (YouTube) | https://www.youtube.com/watch?v=GTG63SH8pLE |
| [^27] | Life of a birb — Retention.Blog | https://www.retention.blog/p/life-of-a-birb |
| [^1] | Rainbow Stones — Finch Wiki (Fandom) | https://finch.fandom.com/wiki/Rainbow_Stones |
| [^12] | Stages of Growth — Finch Wiki (Fandom) | https://finch.fandom.com/wiki/Stages_of_Growth |
| [^7] | How are gamification elements perceived in self-care apps — University of Twente | https://essay.utwente.nl/fileshare/file/96506/Krasteva_BA_BMS_.pdf |
| [^28] | Finch Self Care App Review — Webisoft | https://webisoft.com/articles/finch-self-care-app/ |
| [^29] | 2025 App Update Announcements — Finch Wiki (Fandom) | https://finch.fandom.com/wiki/2025_App_Update_Announcements |
| [^30] | New self care areas replacing journeys? — Reddit r/finch | https://www.reddit.com/r/finch/comments/1iiuvqi/new_self_care_areas_replacing_journeys/ |
| [^31] | App Pause — Reddit r/finch | https://www.reddit.com/r/finch/comments/1k1ik78/app_pause/ |
| [^8] | Finch Makes $3M IAP Revenue Monthly — Gamigion | https://www.gamigion.com/finch-makes-3m-iap-revenue-monthly-on-mobile-5m-on-web/ |
| [^4] | Matej Lancaric: Finch $3M/month IAP revenue — LinkedIn | https://www.linkedin.com/posts/matejlancaric_finch-making |
| [^10] | Why Gamifying Self-Care with a Virtual Pet Works — LinkedIn (Heather Arbiter) | https://www.linkedin.com/pulse/why-gamifying-self-care-virtual-pet-works-finch-heather-arbiter-gjkpe |
| [^32] | Finch App Review: Why Android Users Are Paying 4× More — YouTube | https://www.youtube.com/watch?v=_C5xo8j13Ho |
| [^33] | Goodbye, Finch — Reddit r/finch | https://www.reddit.com/r/finch/comments/1o3zu51/goodbye_finch/ |
| [^34] | All the recent changes and why I think they're harmful — Reddit r/finch | https://www.reddit.com/r/finch/comments/1pod70k/all_the_recent_changes_and_why_i_think_theyre/ |
| [^2] | New Buddy Feature — Reddit r/finch | https://www.reddit.com/r/finch/comments/1jgs3k3/new_buddy_feature/ |
| [^13] | Goal Buddies — Finch Help Center | https://help.finchcare.com/hc/en-us/articles/37936388919693-Goal-Buddies |
| [^3] | Micropets — Finch Wiki (Fandom) | https://finch.fandom.com/wiki/Micropets |
| [^18] | Micropet Egg Guide — Reddit r/finch | https://www.reddit.com/r/finch/comments/1phm6aq/probably_a_dumb_question_but_how_do_you_get/ |
| [^24] | Looking for Alternative Options — Reddit r/finch | https://www.reddit.com/r/finch/comments/1qtzdiv/looking_for_alternative_options/ |
| [^35] | 5 Best Finch App Alternatives in 2026 — Habi | https://habi.app/insights/finch-alternatives/ |
| [^11] | Using the Fogg Behaviour Model — Triage Method | https://triagemethod.com/using-the-fogg-behaviour-model-to-get-better-results-with-your-clients/ |
| [^21] | Fogg Behavior Model — The Decision Lab | https://thedecisionlab.com/reference-guide/psychology/fogg-behavior-model |
| [^36] | SuperBetter's Gamification Strategy — Trophy.so | https://trophy.so/blog/superbetter-gamification-case-study |
| [^37] | Gamification for Mental Health — PMC / NIH | https://pmc.ncbi.nlm.nih.gov/articles/PMC11353921/ |
| [^38] | Neko Atsume Affective Play — UGA Grady | https://grady.uga.edu/research/book-chapter-neko-atsume-affective-play-and-mobile-casual-gaming/ |
| [^39] | Finch Tech Report 2（Finch 技术路线逆向分析报告）| 本项目既有调研文档 |
| [^23] | Finch Complete Report（Finch 完全拆解报告）| 本项目既有调研文档 |

---

## References

1. [How Finch turned self-care into a $100M+ game - YouTube](https://www.youtube.com/watch?v=GTG63SH8pLE) - This is not a meditation app. This is one of the smartest subscription businesses on mobile. In this...

2. [The Magic of Finch: Where Self-Care Meets Enchanted Design](https://www.sophiepilley.com/post/the-magic-of-finch-where-self-care-meets-enchanted-design) - This is the story of how Finch, a mental health app, uses carefully crafted "magic" to transform one...

3. [Matej Lancaric's Post - LinkedIn](https://www.linkedin.com/posts/matejlancaric_finch-making-%F0%9D%9F%AF%F0%9D%97%BA%F0%9D%97%B6%F0%9D%97%B9%F0%9D%97%BA%F0%9D%97%BC%F0%9D%97%BB%F0%9D%98%81%F0%9D%97%B5-iap-activity-7426527989011599360-S1M5) - Finch making $3mil/month IAP revenue on mobile and most likely $5mil+/month revenue on web Finch has...

4. [New Horizons in Habit-Building Gamification - Naavik](https://naavik.co/deep-dives/deep-dives-new-horizons-in-gamification/) - In this deep dive, we look at the growing genre of habit-building self-improvement apps and how gami...

5. [Using The Fogg Behaviour Model To Get Better Results With Your ...](https://triagemethod.com/using-the-fogg-behaviour-model-to-get-better-results-with-your-clients/) - The Fogg Behaviour Model (B = MAP) shows that behaviour only happens when Motivation, Ability, and a...

6. [Fogg Behavior Model - The Decision Lab](https://thedecisionlab.com/reference-guide/psychology/fogg-behavior-model) - It proposes that there are three necessary elements for any behavior to occur: Capability, Opportuni...

7. [[PDF] How are gamification elements perceived in self-care apps by users?](https://essay.utwente.nl/fileshare/file/96506/Krasteva_BA_BMS_.pdf) - AIM The aim of this research was to find out how do users appreciate gamification elements in self-c...

8. [2025 App Update Announcements - Finch: Self Care Pet Wiki](https://finch.fandom.com/wiki/2025_App_Update_Announcements) - May 1, 2025. Version: v3.73.13; Mail/Notifications moved to Bag, save up to a max of 2 free Streak r...

9. [New buddy feature. : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1jgs3k3/new_buddy_feature/) - I'm aware not everyone cares for the social aspect of this app and that's okay. It's optional to par...

10. [Finch Makes $3M IAP Revenue Monthly on Mobile & $5M+ on Web!](https://www.gamigion.com/finch-makes-3m-iap-revenue-monthly-on-mobile-5m-on-web/) - With ~9M DAU, ~75% US audience, insane retention, and almost no ads, Finch could add ads tomorrow an...

11. [Finch App Review: Why Android Users Are Paying 4× More (2026)](https://www.youtube.com/watch?v=_C5xo8j13Ho) - finch works for many people the free version genuinely helps with habits and mood tracking but the a...

12. [New self care areas replacing journeys? : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1iiuvqi/new_self_care_areas_replacing_journeys/) - I downloaded Finch on my work phone for work tasks, and journeys were replaced by self care areas. T...

13. [Goodbye, Finch. : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1o3zu51/goodbye_finch/) - The usage of AI in an Ad has confirmed my worst fear about the progress of Finch. They no longer hav...

14. [Micropets | Finch: Self Care Pet Wiki - Fandom](https://finch.fandom.com/wiki/Micropets) - Users can collect a themed micropet on Day 25 of a seasonal event, or alternatively Day 20 for Finch...

15. [Probably a dumb question, but how do you get micropets? - Reddit](https://www.reddit.com/r/finch/comments/1phm6aq/probably_a_dumb_question_but_how_do_you_get/) - You can get an egg by going into your bag and then to Micropets, and tapping the lab in the top righ...

16. [How to GET MICROPET EGGS in Finch (Step by Step) - YouTube](https://www.youtube.com/watch?v=MXF_WBCZZx4) - Micropet eggs are fun collectibles in Finch. This tutorial explains how to get micropet eggs and wha...

17. [5 Best Finch App Alternatives in 2026 (Tested and Compared) - Habi](https://habi.app/insights/finch-alternatives/) - Tested 5 Finch app alternatives for habit tracking and self-care. Honest reviews with pricing, pros,...

18. [Behavior Change Support Systems for Self-Treating Procrastination](https://pmc.ncbi.nlm.nih.gov/articles/PMC11888082/) - We identified 127 behavior change support apps for procrastination through a systematic screening pr...

19. [The Fogg Behavior Change Model: A Simple Summary - PeopleShift](https://people-shift.com/articles/the-fogg-behavior-model/) - The Fogg behavior change model says an individual's behaviors are a function of their motivation, ab...

20. [Looking for alternative options     : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1qtzdiv/looking_for_alternative_options/) - Task Hero is good if you have less repeating goals, it works more as a checklist than a self care ap...

21. [All the recent changes and why I think they're harmful : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1pod70k/all_the_recent_changes_and_why_i_think_theyre/) - They get more feedback from fans demanding more stuff than they do from people wanting the app for m...

22. [finch-tech-report-2.md](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/166964243/84e3f683-e128-4341-ade4-7e783a60d2e4/finch-tech-report-2.md?AWSAccessKeyId=ASIA2F3EMEYEU4E3744V&Signature=HlYaEF9djgMXCOHdj1SDwTCtIgE%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEPn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIECJZav0vj3tDkojd6qruz2IgC%2B%2BAmhu%2FJ6ZHM9WT5ySAiEA%2BQiXaqWXOzbEZp1tXKI6GgnpZ6mNNhSsCQwJNCj4BvAq%2FAQIwv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARABGgw2OTk3NTMzMDk3MDUiDPaxmimQC5AUsPAGnSrQBFPEZ6MFdA6aL7%2B5alQVTSHDQ%2BR61AVKlYmFs54dEdumocQ5QAQGKtTlFCNOAHCG1l2VKXRY0c0KJKSBeQzwndMbLXY243KEbkhAJ404WDUb3tjaooWBIUqaq5dC2e1a0IF9mptpfY99uCgdJ%2BJcjo0I%2F9pK0fc3ZDpxgGGBt2Q6uYcgew57vW%2FS3EUVuXOSpGBgKLvGgrmxQKCyF%2FnfvunR1rW0%2F214oiPudHZWBQ0ZwBi5MMx1MSYxT4Ctywr1Bwyz2835%2BBC3dxAyGPKzA3Z7mpP850I4kekIp1etdE%2Flh%2FCoQ%2Fd5UXtvySfIUib9qhLD3g%2FEM7n1yVdKFoAfNv6dT0UXhOA0Vgfy8O7agE09mXf22vFAMgTGp6nJmNOL%2BOWhMVNo5P54kdX6HJQ3hQAd%2FyGM8vcCR4uHt%2FI212kCnd%2B6ZaXT2dB4t3pJW1aSU9wDnTcUGoPPkMcRj8wdg9EJhXUtNN24Y6AMix3aOS9smEaN96jU1h2Oeh%2FlK6nmdzuOwtbraxGW72AN3P2FhjdUAXSmfLRIUKr2jrLrTnTcmYazVwxp2K5ewV2uKelIqxbA%2Bh1qRNezgSTePQK%2FYK0wVnkuklpXbnDuSx6JuWK%2BBql%2BTE5TdoZ0fThUaD2CIJI0YvV6YoDj5l5vTpifbcwdgCedCdqdlvPMVgn14DtP258JPj8%2BW%2Ba8J08KF7AsS%2FX%2FXg01eIZL3egwuPXYq7CHDNRKkJt5OHtj1mBjfyVSqEKaE4dZsvZiFF9z1rUw09%2FmOcE9auwjWT2WOCQ%2F%2FZMwssbbzQY6mAEv6MhdUJPyoXjMyjIN9baYZW6Zv3Wq9Ysj0yI5jdKX7mEvjdoGxxiGfIARwOLIx7jWWh4WFOfGQPa2TFRLPsODE3S7pHaTjaSxOvqgXIFRKGpD3cF7RgE8Sk2L3l1HUkneRiGh%2F51kbrS5qJRYx5h30BN6HqrFCG0YKdiTwvMzHa7%2FgG9UeP8pc0QpS%2Fc7ZKAnjy2qIlu6gQ%3D%3D&Expires=1773596933) - # Finch 技术路线逆向分析报告
# —— 及 Hachimi（Flutter）的对等实现方案

> **日期**：2026-03-15
> **议题**：Finch 用了什么技术？它的动画、音效...

23. [App Pause : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1k1ik78/app_pause/) - You can now pause your progress without losing your daily streak! With App Pause, you'll still be ab...

24. [Felix Braberg's Post - Finch - LinkedIn](https://www.linkedin.com/posts/felix-braberg-7a732b51_finch-how-to-gamify-self-care-and-grow-activity-7426531163097325568-xMn2) - Finch: How to Gamify Self-Care and Grow to 10 million DAU Finch scaled to roughly 10 million daily a...

25. [finch-complete-report.md](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/166964243/2fc9e325-f0d7-4901-a527-23533f429784/finch-complete-report.md?AWSAccessKeyId=ASIA2F3EMEYEU4E3744V&Signature=BgofmmHcG6D76AQKS5qFZQtOg3A%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEPn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIECJZav0vj3tDkojd6qruz2IgC%2B%2BAmhu%2FJ6ZHM9WT5ySAiEA%2BQiXaqWXOzbEZp1tXKI6GgnpZ6mNNhSsCQwJNCj4BvAq%2FAQIwv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARABGgw2OTk3NTMzMDk3MDUiDPaxmimQC5AUsPAGnSrQBFPEZ6MFdA6aL7%2B5alQVTSHDQ%2BR61AVKlYmFs54dEdumocQ5QAQGKtTlFCNOAHCG1l2VKXRY0c0KJKSBeQzwndMbLXY243KEbkhAJ404WDUb3tjaooWBIUqaq5dC2e1a0IF9mptpfY99uCgdJ%2BJcjo0I%2F9pK0fc3ZDpxgGGBt2Q6uYcgew57vW%2FS3EUVuXOSpGBgKLvGgrmxQKCyF%2FnfvunR1rW0%2F214oiPudHZWBQ0ZwBi5MMx1MSYxT4Ctywr1Bwyz2835%2BBC3dxAyGPKzA3Z7mpP850I4kekIp1etdE%2Flh%2FCoQ%2Fd5UXtvySfIUib9qhLD3g%2FEM7n1yVdKFoAfNv6dT0UXhOA0Vgfy8O7agE09mXf22vFAMgTGp6nJmNOL%2BOWhMVNo5P54kdX6HJQ3hQAd%2FyGM8vcCR4uHt%2FI212kCnd%2B6ZaXT2dB4t3pJW1aSU9wDnTcUGoPPkMcRj8wdg9EJhXUtNN24Y6AMix3aOS9smEaN96jU1h2Oeh%2FlK6nmdzuOwtbraxGW72AN3P2FhjdUAXSmfLRIUKr2jrLrTnTcmYazVwxp2K5ewV2uKelIqxbA%2Bh1qRNezgSTePQK%2FYK0wVnkuklpXbnDuSx6JuWK%2BBql%2BTE5TdoZ0fThUaD2CIJI0YvV6YoDj5l5vTpifbcwdgCedCdqdlvPMVgn14DtP258JPj8%2BW%2Ba8J08KF7AsS%2FX%2FXg01eIZL3egwuPXYq7CHDNRKkJt5OHtj1mBjfyVSqEKaE4dZsvZiFF9z1rUw09%2FmOcE9auwjWT2WOCQ%2F%2FZMwssbbzQY6mAEv6MhdUJPyoXjMyjIN9baYZW6Zv3Wq9Ysj0yI5jdKX7mEvjdoGxxiGfIARwOLIx7jWWh4WFOfGQPa2TFRLPsODE3S7pHaTjaSxOvqgXIFRKGpD3cF7RgE8Sk2L3l1HUkneRiGh%2F51kbrS5qJRYx5h30BN6HqrFCG0YKdiTwvMzHa7%2FgG9UeP8pc0QpS%2Fc7ZKAnjy2qIlu6gQ%3D%3D&Expires=1773596933) - # Finch 完全拆解报告：系统机制、用户体验地图、竞品对标与猫咪 DND App 设计借鉴

## 一、产品概述与背景

Finch 是一款以「自我关怀」为核心的虚拟宠物养成 + 习惯追踪 App...

26. [How to Upgrade to Finch Plus 2026? - YouTube](https://www.youtube.com/watch?v=rJ1hUW8jui8) - In this video, you'll learn how to upgrade to Finch Plus step by step. Upgrading to Finch Plus gives...

27. [Why Finch is My Favorite Mental Health App - Lemon8](https://www.lemon8-app.com/@joinsaturnsocial/7453878117040456235?region=us) - This app is not just about tracking habits; it incorporates elements of social interaction and gamif...

28. [From 0 to $2M in 4 years. Finch's self-care app blueprint is a ... - X](https://x.com/dailystartupfix/status/1921942935446175875) - Finch's self-care app blueprint is a masterclass in growth: Finch's success mirrors a 25% rise in me...

29. [Finch: Self-Care Pet - Apps on Google Play](https://play.google.com/store/apps/details?id=com.finch.finch&hl=en_US) - Finch is a self-care pet app that helps you feel prepared and positive, one day at a time. Take care...

30. [Why Gamifying Self-Care with a Virtual Pet Works for Finch - LinkedIn](https://www.linkedin.com/pulse/why-gamifying-self-care-virtual-pet-works-finch-heather-arbiter-gjkpe) - Finch gamifies self-care with a virtual pet, boosting motivation, and helping users develop healthie...

31. [Finch Q2 2025 Product Recap | Expanded Coverage, Enterprise ...](https://www.tryfinch.com/blog/product-recap-q2-2025) - Finch grew active connections 166% YoY in Q2 2025, expanded payroll & HR coverage to 250+ systems, a...

32. [What I hope eventually comes to the app in 2026 : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1q3y8z2/what_i_hope_eventually_comes_to_the_app_in_2026/) - Future features for Finch app in 2026. Finch app seasonal events and themes. Unique self-care routin...

33. [Wellness apps are hooking you, not helping you. | Nicki Sprinz](https://www.linkedin.com/posts/nicki-sprinz-6b8a0459_wellness-apps-are-hooking-you-not-helping-activity-7387154310570196992-_LQp) - The research backs this up. Studies show gamification in mental health apps produces no significant ...

34. [Why all of the signs are actually signals that Finch is likely selling in ...](https://www.reddit.com/r/finch/comments/1kup17q/why_all_of_the_signs_are_actually_signals_that/) - Investors especially pushes for revenue scaling if an exit (sale) isn't immediately on the table. AI...

35. [Top Mental Health Tools on Finch for Self-Care - Lemon8](https://www.lemon8-app.com/@mckaylaashlyn/7454183244641174062?region=us) - Explore the best mental health tools on Finch that can help you enhance your self-care routine. Disc...

36. [Using Finch App for Self-Care in 2025: A Review | TikTok](https://www.tiktok.com/@finchcare/video/7455047513851055406) - 791 Likes, 27 Comments. TikTok video from Finchcare (@finchcare): “Discover how the Finch app enhanc...

37. [Things You SHOULD Know About Finch App : r/finch - Reddit](https://www.reddit.com/r/finch/comments/1epa6hg/things_you_should_know_about_finch_app/) - I'm not motivated to open finch app anymore:( 155. 41. how do I ... Finch Plus only $14.99 per year ...

38. [Elevate Your Self-Care with the Finch App | TikTok](https://www.tiktok.com/@renduh/video/7607990825989016846) - This innovative app provides a range of tools designed to help you prioritize your mental health and...

39. [Finch Capital's €10m Investment In Big XYT and the State of FinTech ...](https://www.harringtonstarr.com/resources/podcast/finch-capital-s--10m-investment-in-big-xyt-and-the-state-of-fintech-in-24-25/) - One recent example of this approach is Finch Capital's €10 million investment in Big XYT, a company ...

