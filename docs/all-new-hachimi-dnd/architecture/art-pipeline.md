# 渲染引擎、美术管线与技术选型

> SSOT for v2.0 的渲染架构（Rive + Flame）、美术资源管线和 Flutter 技术栈。
> **Status:** Draft
> **Evidence:** `pubspec.yaml`、`lib/core/theme/`、`assets/`
> **Related:** [data-model.md](data-model.md) · [decisions/log.md](../decisions/log.md) D9
> **Changelog:** 2026-03-15 — 从"零新依赖 PNG 管线"重写为"胶水编程 Rive+Flame 方案"

---

## 1. 架构概览

```
┌────────────────────────────────────────────────┐
│  Flutter App（习惯管理、设置、统计）              │
│  ┌──────────────────┐  ┌─────────────────────┐ │
│  │  Flame GameWidget │  │  Rive RiveAnimation │ │
│  │  酒馆场景/冒险场景  │  │  猫咪角色动画        │ │
│  │  (flame_tiled)    │  │  (状态机+换装)      │ │
│  └──────────────────┘  └─────────────────────┘ │
│  ┌──────────────────────────────────────────┐  │
│  │  Riverpod Providers（统一状态管理）         │  │
│  │  flame_riverpod 桥接 Flame ↔ Provider     │  │
│  └──────────────────────────────────────────┘  │
└────────────────────────────────────────────────┘
```

**关键原则**：Flutter App 是主体，Flame/Rive 是嵌入式组件。不是"游戏中嵌 App"，而是"App 中嵌游戏元素"。

## 2. 渲染引擎技术栈

### 2.1 必装依赖

| 包名 | 协议 | 版本 | 用途 |
|------|------|------|------|
| `rive` | MIT | ^0.13.0 | 猫咪骨骼动画 + 状态机 + 运行时换装 |
| `flame` | MIT | ^1.x | 2D 游戏引擎（场景渲染、游戏循环） |
| `flame_rive` | MIT | latest | Rive 组件嵌入 Flame 场景 |
| `flame_riverpod` | MIT | latest | Riverpod ↔ Flame 状态桥接 |
| `flame_audio` | MIT | latest | 游戏音效（检定音、环境音） |
| `flame_tiled` | MIT | latest | Tiled 编辑器地图加载（酒馆布局） |
| `fl_chart` | MIT | latest | 属性雷达图（Tab 3 冒险者档案） |
| `audioplayers` | MIT | ^6.0.0 | 短音效（任务完成叮叮叮） |

### 2.2 推荐依赖

| 包名 | 协议 | 用途 | 引入时机 |
|------|------|------|---------|
| `just_audio` | Apache-2.0 | 白噪音/BGM 循环播放 | Phase 3+ |
| `lottie` | MIT | UI 庆祝动画（全屏粒子） | Phase 2 |
| `flutter_animate` | BSD-3 | 声明式动画链 | Phase 1 |
| `confetti` | MIT | 庆祝粒子效果 | Phase 1 |

### 2.3 明确拒绝

| 包名 | 拒绝原因 |
|------|---------|
| `spine_flutter` | 商用需付费 Spine Editor 许可证（$99-$3,500+） |
| `bonfire` | 与 Riverpod 架构冲突 + 需禁用 Impeller |
| `flare_flutter` / `nima` | 已废弃（2021 年停更） |

## 3. Rive 猫咪角色系统

### 3.1 .riv 文件结构

每个进化阶段 1 个 .riv 文件：

| 文件 | 阶段 | 状态机 |
|------|------|--------|
| `cat_kitten.riv` | 幼猫 | idle / happy / sleep / walk |
| `cat_adolescent.riv` | 少年猫 | idle / happy / sleep / walk / play |
| `cat_adult.riv` | 成年猫 | idle / happy / sleep / walk / play / eat |

### 3.2 运行时换装

Rive 支持通过图层可见性和填充色替换实现换装：

```dart
// 伪代码：运行时切换毛色
artboard.fill('pelt_base').color = appearance.peltColor;
// 切换配件可见性
artboard.node('accessory_hat').isVisible = equippedAccessory == 'hat';
artboard.node('accessory_collar').isVisible = equippedAccessory == 'collar';
```

**优势**：一个 .riv 文件支持所有外观组合，不需要 677 个独立精灵条目。

### 3.3 与现有系统的关系

| 现有组件 | 处理方式 |
|---------|---------|
| `PixelCatRenderer` | **Phase Art 淘汰**，被 RiveAnimation Widget 替代 |
| `PixelCatSprite` Widget | **Phase Art 淘汰**，被 RiveAnimation Widget 替代 |
| `CatAppearance` 模型 | **保留**，作为 Rive 运行时换装的参数源 |
| `pixel_cat_constants.dart` | **重构**，保留性格/心情常量，删除精灵索引逻辑 |
| 13 层合成管线 | **Phase Art 淘汰** |
| ClanGen spritesheets | **Phase Art 删除**（CC BY-NC 不可商用） |

### 3.4 推进策略：先逻辑后美术

```
Phase 0（当前）: 用 ClanGen 精灵做占位 → 实现所有 DnD 逻辑
Phase Art（后续）: 创建原创 Rive 角色 → 替换 PixelCatRenderer → 删除 ClanGen 资产
```

Phase 0 的所有 DnD 代码（Provider/Service/Model）不依赖渲染层，切换引擎时无需修改。

## 4. Flame 场景系统

### 4.1 嵌入方式

```dart
// 在 Flutter Widget 树中嵌入 Flame 游戏
GameWidget<TavernGame>(
  game: TavernGame(ref: ref),  // flame_riverpod 桥接
  overlayBuilderMap: {
    'hud': (ctx, game) => CoinDisplay(),  // Flutter UI 叠加在游戏画布上
  },
)
```

### 4.2 应用场景

| 场景 | Flame 组件 | Phase |
|------|-----------|-------|
| 酒馆（Tab 2） | TavernGame + flame_tiled 瓦片地图 | Phase 3 |
| 冒险场景背景 | SceneBackground + 像素场景图 | Phase 2 |
| 骰子投掷 | 仍用 CustomPainter（不需要 Flame） | Phase 2 |

### 4.3 Flame ↔ Riverpod 数据流

```
用户完成专注
  → Riverpod Provider 更新（dice_earned, xp_up）
  → flame_riverpod 桥接通知 Flame 组件
  → 猫咪 Rive 状态机切换到 'happy'
  → 酒馆场景中猫咪跳跃动画
```

## 5. 原创美术资产来源

### 5.1 猫咪角色（Rive）

| 方案 | 优先级 | 说明 |
|------|--------|------|
| Rive Editor 自绘 | 首选 | 免费编辑器，矢量绘制+骨骼绑定+状态机 |
| 委托 Rive 社区设计师 | 备选 | Rive 社区有付费定制服务 |
| AI 辅助 + 手动精修 | 补充 | Gemini 生成概念图 → Rive Editor 矢量化 |

### 5.2 场景背景/道具（像素风）

| 来源 | 协议 | 内容 |
|------|------|------|
| PixelLab AI | 商用（订阅） | 场景背景、家具、道具 |
| Kenney Game Assets | CC0 | 60,000+ 通用游戏资产 |
| OpenGameArt | CC0 / CC-BY | 像素风瓦片、环境素材 |
| LuizMelo (itch.io) | 商用（付费） | 专业像素角色帧动画 |

### 5.3 音效

| 来源 | 协议 | 内容 |
|------|------|------|
| Freesound.org | CC0 / CC-BY | 环境音、交互音效 |
| Kenney.nl | CC0 | 游戏音效包 |
| 自制（GarageBand） | 原创 | 连锁奖励音阶（5-8 个递增音高） |

## 6. 像素风格约束（Style Guide）

即使切换到 Rive 矢量角色，整体美学仍保持**像素风**。约束：

```
Hachimi Style Guide:
- 角色：Rive 矢量绘制，但风格模拟像素感（锐利边缘、有限调色板）
- 场景：PixelLab 生成的像素背景（≤16 色，星露谷暖色调）
- UI：保持现有 Material 3 + RetroPixel 双主题策略
- 图标：pixelarticons 字体（MIT）
- 骰子：CustomPainter 几何绘制（不需要精灵图）
```

## 7. 叙事文本工程化

（保持不变，从之前版本延续）

### 7.1 文本量

| 类别 | 数量 |
|------|------|
| 场景叙事 | 300 段（15场景×10事件×2） |
| 主哈基米对话 | 120 句 |
| 骰子结果文案 | 72 句 |
| 队伍互动 | 36 句 |
| **合计** | ~528 段 × 15 语言 |

### 7.2 国际化

叙事文本使用独立 JSON 文件（`assets/l10n/adventure/{locale}.json`），不进 ARB。

### 7.3 质量控制

AI 批量生成 → 人工审核 → AI 翻译 → 母语者抽检（CJK ≥50%）
