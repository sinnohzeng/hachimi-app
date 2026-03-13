# Claude Code Skills、Agents 与 Plugins 使用指南

## Purpose（目的）

为 Hachimi 项目的开发者提供一份完整的 Claude Code 扩展能力参考手册，涵盖所有已安装的 Skills（斜杠命令）、Agents（子 Agent）和 MCP Plugins（模型上下文协议插件）的使用场景、触发方式和参数说明。

## Scope（适用范围）

适用于所有使用 Claude Code（CLI 或 VSCode 扩展）参与 Hachimi 项目开发的团队成员。

## Status: Active

## Evidence（证据来源）

- Claude Code 会话系统提示词中的 `available skills` 列表
- Claude Code 会话系统提示词中的 `available agents` 列表
- MCP Server 配置

## Related（相关文档）

- [开发工作流](development-workflow.md)
- [Git Worktree 指南](git-worktree.md)
- [本地开发反馈循环](local-dev-feedback-loop.md)

---

## 一、Skills 总览（斜杠命令）

Skills 是用户可以通过输入 `/skill-name` 直接调用的命令。Claude 会自动加载对应的 Skill 提示词并按其流程执行。

### 快速索引

| 分类 | 命令 | 一句话说明 |
|------|------|-----------|
| **Git 工作流** | `/commit` | 创建规范的 Git 提交 |
| | `/commit-push-pr` | 提交 + 推送 + 创建 PR 一条龙 |
| | `/clean_gone` | 清理本地已失效的远程分支 |
| **代码审查** | `/code-review` | 对 PR 进行代码审查 |
| | `/review-pr` | 多 Agent 协作的综合 PR 审查 |
| **代码质量** | `/simplify` | 审查已变更代码的复用性、质量和效率 |
| **前端开发** | `/frontend-design` | 创建高质量、有设计感的前端界面 |
| **功能开发** | `/feature-dev` | 引导式功能开发（含代码库理解和架构设计） |
| **计划与执行** | `/writing-plans` | 编写多步骤实施计划 |
| | `/executing-plans` | 按计划执行实施（含审查检查点） |
| | `/review-plan` | 对实施计划进行架构级审查 |
| **创意与探索** | `/brainstorming` | 功能创意探索、需求分析与设计讨论 |
| **测试与调试** | `/test-driven-development` | 测试驱动开发工作流 |
| | `/systematic-debugging` | 系统化调试（根因分析） |
| **Git Worktree** | `/using-git-worktrees` | 在隔离的 Git Worktree 中工作 |
| **并行开发** | `/dispatching-parallel-agents` | 将独立任务分发给多个并行 Agent |
| | `/subagent-driven-development` | 子 Agent 驱动的任务执行 |
| **完成与验证** | `/verification-before-completion` | 完成前强制运行验证命令 |
| | `/requesting-code-review` | 请求对已完成工作进行代码审查 |
| | `/receiving-code-review` | 接收并处理代码审查反馈 |
| | `/finishing-a-development-branch` | 完成开发分支（合并/PR/清理） |
| **项目管理** | `/revise-claude-md` | 根据当前会话学习更新 CLAUDE.md |
| | `/claude-md-improver` | 审计并改进 CLAUDE.md 文件质量 |
| | `/claude-automation-recommender` | 分析代码库并推荐 Claude Code 自动化配置 |
| **工具类** | `/keybindings-help` | 自定义 Claude Code 键盘快捷键 |
| | `/loop` | 定期循环执行某个命令或斜杠命令 |
| **Web 与研究** | `/firecrawl-cli` | Web 搜索、网页抓取、深度研究 |
| | `/skill-gen` | 从文档 URL 自动生成 Skill |
| **API 开发** | `/claude-api` | 构建 Claude API / Anthropic SDK 应用 |
| **Skill 开发** | `/writing-skills` | 创建或编辑 Claude Code Skills |

---

## 二、Skills 详细使用说明

### 2.1 Git 工作流类

#### `/commit` — 创建 Git 提交

**场景**：当你完成了一段代码修改，想要创建一个规范的 Git 提交时使用。

**使用方式**：
```
/commit
```

**说明**：
- 自动分析当前 staged 和 unstaged 的变更
- 生成符合 Conventional Commit 风格的提交消息
- 自动添加 `Co-Authored-By` 标记

**带参数使用**：
```
/commit -m "feat: add dark mode toggle"
```

---

#### `/commit-push-pr` — 提交、推送并创建 PR

**场景**：当功能开发完成，需要一次性完成提交、推送到远程、并创建 Pull Request 时使用。

**使用方式**：
```
/commit-push-pr
```

**说明**：
- 自动完成 `commit → push → gh pr create` 全流程
- PR 标题和正文会根据提交内容自动生成
- 适合功能分支开发完毕后的收尾操作

---

#### `/clean_gone` — 清理失效的本地分支

**场景**：远程分支已被删除（例如 PR 合并后），但本地还残留对应分支时使用。

**使用方式**：
```
/clean_gone
```

**说明**：
- 清理所有标记为 `[gone]` 的本地分支
- 同时清理关联的 Git Worktree
- 适合定期执行以保持本地仓库整洁

---

### 2.2 代码审查类

#### `/code-review` — 代码审查

**场景**：需要对一个 PR 进行代码审查时使用。

**使用方式**：
```
/code-review
/code-review 123         # 审查 PR #123
/code-review <PR-URL>    # 通过 URL 审查
```

**说明**：
- 审查代码变更的质量、风格和潜在问题
- 检查是否符合项目规范（CLAUDE.md 中定义的规则）

---

#### `/review-pr` — 综合 PR 审查

**场景**：需要对 PR 进行更全面、多维度的审查时使用。比 `/code-review` 更深入，会调度多个专业子 Agent。

**使用方式**：
```
/review-pr
/review-pr 123
```

**说明**：
- 使用多个专业 Agent 并行审查：
  - **code-reviewer**：代码质量与风格
  - **silent-failure-hunter**：静默失败与错误处理
  - **code-simplifier**：代码简化建议
  - **comment-analyzer**：注释质量分析
  - **pr-test-analyzer**：测试覆盖率分析
  - **type-design-analyzer**：类型设计分析
- 适合重要功能或大型 PR 的正式审查

---

### 2.3 代码质量类

#### `/simplify` — 代码简化审查

**场景**：完成代码编写后，想要检查是否有可以简化、复用或优化的地方。

**使用方式**：
```
/simplify
```

**说明**：
- 审查最近修改的代码（基于 `git diff`）
- 检查代码复用机会、质量问题和效率问题
- 自动修复发现的问题

---

### 2.4 前端开发类

#### `/frontend-design` — 高质量前端界面设计

**场景**：需要创建有设计感的前端界面、组件或页面时使用。

**使用方式**：
```
/frontend-design
```

然后描述你想要创建的界面，例如：
```
我需要一个用户个人资料页面，包含头像、昵称编辑和统计数据展示
```

**说明**：
- 生成具有创意性的、生产级别的前端代码
- 避免"AI 生成的通用美学"，追求独特的设计风格
- 适用于 Web 组件、页面或完整应用的前端部分

---

### 2.5 功能开发类

#### `/feature-dev` — 引导式功能开发

**场景**：需要开发一个新功能，希望 Claude 先理解代码库架构再动手实现。

**使用方式**：
```
/feature-dev
```

然后描述你的功能需求，例如：
```
为猫咪系统添加一个"猫咪睡眠"状态，当专注计时器暂停时猫咪进入睡眠动画
```

**说明**：
- 先探索代码库，理解现有架构和模式
- 设计功能架构方案
- 然后按计划实施
- 适合中大型功能的开发

---

### 2.6 计划与执行类

#### `/writing-plans` — 编写实施计划

**场景**：有一个多步骤的任务或需求，需要先制定详细的实施计划再动手写代码。

**使用方式**：
```
/writing-plans
```

然后描述你的需求或规格说明，例如：
```
我需要实现用户成就系统，包含成就定义、进度追踪和解锁通知三个模块
```

**说明**：
- 生成结构化的实施计划文档
- 包含任务分解、依赖关系和执行顺序
- 计划文件会写入 `plan/` 目录
- 只生成计划，不执行代码实现

---

#### `/executing-plans` — 执行实施计划

**场景**：已经有了一份实施计划（通过 `/writing-plans` 生成或手动编写），需要按计划逐步执行。

**使用方式**：
```
/executing-plans
```

**说明**：
- 按计划文档中的步骤逐一执行
- 在关键节点设置审查检查点
- 确保实施与计划保持一致
- 适合在独立会话中执行之前制定的计划

---

#### `/review-plan` — 架构级计划审查

**场景**：实施计划制定完成后，在开始编码前进行架构级审查。

**使用方式**：
```
/review-plan
```

或者直接说：
```
审查计划
检查方案
review plan
```

**说明**：
- 审查架构设计、技术选型、可扩展性、安全性等维度
- 确保计划达到生产级标准
- 在 Plan Mode 完成后自动触发

---

### 2.7 创意与探索类

#### `/brainstorming` — 头脑风暴

**场景**：在开始任何创意性工作之前使用——创建功能、构建组件、添加新行为、修改现有行为等。

**使用方式**：
```
/brainstorming
```

然后描述你想要探索的方向，例如：
```
我想为猫咪游戏添加一个社交功能，让用户可以看到朋友的猫咪
```

**说明**：
- 探索用户意图和需求
- 讨论设计方案和权衡
- 在实施之前充分理解需求
- **必须在任何创意性工作之前使用**

---

### 2.8 测试与调试类

#### `/test-driven-development` — 测试驱动开发

**场景**：需要实现一个功能或修复一个 Bug，希望遵循 TDD（测试驱动开发）流程。

**使用方式**：
```
/test-driven-development
```

然后描述你要实现的功能或要修复的 Bug，例如：
```
实现猫咪经验值计算服务，根据专注时长计算获得的经验值
```

**说明**：
- 遵循 Red-Green-Refactor 循环
- 先写测试，再写实现，最后重构
- 适合需要高可靠性的核心业务逻辑

---

#### `/systematic-debugging` — 系统化调试

**场景**：遇到 Bug、测试失败或意外行为时，需要系统化地定位根因。

**使用方式**：
```
/systematic-debugging
```

然后描述你遇到的问题，例如：
```
专注计时器在切换到后台时偶尔会跳过记录，日志显示 onPause 回调未被触发
```

**说明**：
- 系统化地收集证据、形成假设、验证假设
- 避免"猜测式修复"
- 适合复杂的、难以复现的 Bug

---

### 2.9 Git Worktree 类

#### `/using-git-worktrees` — 使用 Git Worktree 隔离开发

**场景**：需要在不影响当前工作目录的情况下，在独立的环境中进行功能开发。

**使用方式**：
```
/using-git-worktrees
```

**说明**：
- 创建隔离的 Git Worktree
- 在独立的目录中工作，不影响主工作区
- 适合并行开发多个功能或进行实验性修改
- 参考 [Git Worktree 指南](git-worktree.md) 获取更多信息

---

### 2.10 并行开发类

#### `/dispatching-parallel-agents` — 并行 Agent 任务分发

**场景**：面对 2 个以上相互独立、没有共享状态或顺序依赖的任务时使用。

**使用方式**：
```
/dispatching-parallel-agents
```

然后描述你的多个独立任务，例如：
```
任务 1：为 HabitService 添加单元测试
任务 2：为 CatService 添加单元测试
任务 3：更新 API 文档
```

**说明**：
- 将独立任务分配给多个子 Agent 并行执行
- 显著提升多任务场景的效率
- 任务之间不能有依赖关系

---

#### `/subagent-driven-development` — 子 Agent 驱动开发

**场景**：有一份实施计划，其中包含可以独立执行的任务，希望利用子 Agent 加速开发。

**使用方式**：
```
/subagent-driven-development
```

**说明**：
- 基于已有计划，将可并行的任务分配给子 Agent
- 主 Agent 负责协调和集成
- 适合大型功能的实施阶段

---

### 2.11 完成与验证类

#### `/verification-before-completion` — 完成前验证

**场景**：即将声明工作完成、代码已修复或测试通过之前，强制要求运行验证命令。

**使用方式**：
```
/verification-before-completion
```

**说明**：
- 在声明"完成"之前，必须运行验证命令并确认输出
- 遵循"先有证据，再有断言"的原则
- 防止在未验证的情况下就声称修复成功
- **Claude 会在即将完成工作时自动触发此 Skill**

---

#### `/requesting-code-review` — 请求代码审查

**场景**：完成任务、实现重要功能后，或合并前需要验证工作是否符合要求。

**使用方式**：
```
/requesting-code-review
```

**说明**：
- 对已完成的工作进行自查式代码审查
- 验证实现是否符合计划和编码标准
- 适合在提交 PR 之前使用

---

#### `/receiving-code-review` — 接收代码审查反馈

**场景**：收到代码审查反馈后，在实施建议之前使用，特别是当反馈不明确或技术上有疑问时。

**使用方式**：
```
/receiving-code-review
```

**说明**：
- 以技术严谨性审视反馈，而非盲目实施
- 验证建议的正确性
- 避免"表演式同意"——不应不加思考地接受所有反馈

---

#### `/finishing-a-development-branch` — 完成开发分支

**场景**：实现完成、所有测试通过后，需要决定如何集成工作（合并、创建 PR 或清理）。

**使用方式**：
```
/finishing-a-development-branch
```

**说明**：
- 提供结构化的选项：直接合并、创建 PR 或清理
- 引导完成开发分支的收尾工作
- 适合功能分支开发完毕后的决策

---

### 2.12 项目管理类

#### `/revise-claude-md` — 更新 CLAUDE.md

**场景**：当前会话中学到了新的项目规则、模式或注意事项，需要持久化到 CLAUDE.md 中。

**使用方式**：
```
/revise-claude-md
```

**说明**：
- 基于当前会话的经验更新 CLAUDE.md
- 确保未来的会话能受益于这些学习
- 适合在解决了棘手问题或发现了新规律后使用

---

#### `/claude-md-improver` — 审计改进 CLAUDE.md

**场景**：想要全面检查、审计和改进项目中所有 CLAUDE.md 文件的质量。

**使用方式**：
```
/claude-md-improver
```

**说明**：
- 扫描所有 CLAUDE.md 文件
- 评估质量、完整性和准确性
- 输出质量报告并进行针对性更新
- 适合定期维护或项目初始设置时使用

---

#### `/claude-automation-recommender` — 自动化配置推荐

**场景**：想要了解项目可以使用哪些 Claude Code 自动化功能（hooks、subagents、skills、plugins、MCP servers）。

**使用方式**：
```
/claude-automation-recommender
```

**说明**：
- 分析代码库结构
- 推荐适合的 Claude Code 自动化配置
- 适合首次设置 Claude Code 或优化工作流时使用

---

### 2.13 工具类

#### `/keybindings-help` — 自定义快捷键

**场景**：想要自定义 Claude Code 的键盘快捷键、重新绑定按键或添加组合键。

**使用方式**：
```
/keybindings-help
```

然后描述你想要的快捷键配置，例如：
```
把提交快捷键改为 ctrl+shift+c
添加一个 chord 快捷键用于运行测试
```

---

#### `/loop` — 定期循环执行

**场景**：需要定期轮询某个状态或周期性运行某个命令。

**使用方式**：
```
/loop 5m /commit          # 每 5 分钟执行 /commit
/loop 10m check deploy    # 每 10 分钟检查部署状态（默认 10 分钟间隔）
/loop 2m flutter test     # 每 2 分钟运行测试
```

**参数**：
- 第一个参数（可选）：时间间隔，格式为 `Xm`（如 `5m` 表示 5 分钟），默认 `10m`
- 后续参数：要执行的命令或斜杠命令

**说明**：
- 适合持续监控 CI 状态、定期检查部署等场景
- 不适用于一次性任务

---

### 2.14 Web 与研究类

#### `/firecrawl-cli` — Web 搜索与抓取

**场景**：需要搜索互联网、阅读网页内容、深度研究某个主题时使用。**完全替代内置的 WebFetch 和 WebSearch 工具。**

**使用方式**：
```
/firecrawl-cli
```

然后描述你需要的信息，例如：
```
搜索 Flutter 3.41 的 breaking changes
阅读 Riverpod 3.x 的迁移指南
研究 Firebase Firestore 的离线缓存最佳实践
```

**适用场景**：
- 任何 URL 或网页内容的获取
- Web、图片和新闻搜索
- 深度研究和调查
- 阅读文档、文章、API 参考
- 当前事件、趋势、事实核查

**说明**：
- 返回为 LLM 优化的干净 Markdown 内容
- 处理 JavaScript 渲染、绕过常见的阻止机制
- 所有互联网相关任务都应使用此 Skill

---

#### `/skill-gen` — 从文档生成 Skill

**场景**：想要从某个库或工具的文档 URL 自动生成一个 Claude Code Skill。

**使用方式**：
```
/skill-gen
```

然后提供文档 URL，例如：
```
https://docs.flutter.dev/cookbook/persistence/sqlite
```

**说明**：
- 使用 Firecrawl 抓取文档内容
- 自动生成完整的 Skill 文件
- 适合为常用的库或工具创建专属 Skill

---

### 2.15 API 开发类

#### `/claude-api` — 构建 Claude API 应用

**场景**：代码中使用了 `anthropic` SDK 或 `@anthropic-ai/sdk`，或者用户要求使用 Claude API、Anthropic SDK 或 Agent SDK 构建应用。

**使用方式**：
```
/claude-api
```

**触发条件**：
- 代码中导入了 `anthropic`、`@anthropic-ai/sdk` 或 `claude_agent_sdk`
- 用户要求使用 Claude API 或 Anthropic SDK

**不触发**：
- 代码中导入了 `openai` 或其他 AI SDK
- 通用编程任务

---

### 2.16 Skill 开发类

#### `/writing-skills` — 创建或编辑 Skills

**场景**：想要创建新的 Claude Code Skill、编辑已有 Skill 或验证 Skill 是否正常工作。

**使用方式**：
```
/writing-skills
```

**说明**：
- 引导完成 Skill 的创建、测试和部署
- 适合扩展 Claude Code 的能力

---

## 三、Agents（子 Agent）详细说明

Agents 是 Claude Code 在执行任务时自动调度的专业子进程。用户通常不需要直接调用它们，Claude 会根据任务自动选择合适的 Agent。

### 3.1 通用类 Agent

| Agent 类型 | 说明 | 自动触发场景 |
|-----------|------|-------------|
| `general-purpose` | 通用 Agent，处理复杂、多步骤任务 | 搜索代码、研究问题等需要自主完成的复杂任务 |
| `Explore` | 代码库快速探索 Agent | 需要按模式查找文件、搜索关键词或回答代码库相关问题时 |
| `Plan` | 软件架构 Agent | 需要设计实施策略时 |
| `claude-code-guide` | Claude Code 使用指南 Agent | 用户询问 Claude Code 功能、设置、MCP 服务器等问题时 |

### 3.2 功能开发类 Agent

| Agent 类型 | 说明 | 自动触发场景 |
|-----------|------|-------------|
| `feature-dev:code-explorer` | 代码库深度分析 Agent | 需要追踪执行路径、理解架构层次、映射依赖关系时 |
| `feature-dev:code-reviewer` | 代码审查 Agent | 审查代码的 Bug、逻辑错误、安全漏洞和代码质量时 |
| `feature-dev:code-architect` | 代码架构师 Agent | 分析现有代码模式，设计功能架构蓝图时 |

### 3.3 代码质量类 Agent

| Agent 类型 | 说明 | 自动触发场景 |
|-----------|------|-------------|
| `code-simplifier:code-simplifier` | 代码简化 Agent | 编写或修改代码后，需要简化以提高可读性和可维护性时 |
| `superpowers:code-reviewer` | 项目步骤审查 Agent | 完成计划中的主要步骤后，需要验证实现是否符合原计划和编码标准时 |

### 3.4 PR 审查类 Agent

| Agent 类型 | 说明 | 自动触发场景 |
|-----------|------|-------------|
| `pr-review-toolkit:code-reviewer` | PR 代码审查 Agent | 编写或修改代码后，检查是否符合项目规范和最佳实践 |
| `pr-review-toolkit:silent-failure-hunter` | 静默失败猎手 Agent | 审查涉及错误处理、catch 块、回退逻辑的代码变更 |
| `pr-review-toolkit:code-simplifier` | PR 代码简化 Agent | 代码编写后需要简化时自动触发 |
| `pr-review-toolkit:comment-analyzer` | 注释分析 Agent | 生成大量文档注释后、PR 提交前检查注释准确性 |
| `pr-review-toolkit:pr-test-analyzer` | 测试覆盖分析 Agent | PR 创建或更新后，确保测试覆盖充分 |
| `pr-review-toolkit:type-design-analyzer` | 类型设计分析 Agent | 引入新类型、PR 中添加类型、或重构类型时 |

### 3.5 架构审查类 Agent

| Agent 类型 | 说明 | 自动触发场景 |
|-----------|------|-------------|
| `architect-reviewer` | 架构审查 Agent | 实施计划制定完成后，审查架构设计、技术选型、可扩展性和安全性 |

### 3.6 如何请求 Claude 使用特定 Agent

虽然 Agent 通常由 Claude 自动调度，但你可以通过描述需求来引导使用特定类型的 Agent：

```
请帮我探索代码库中所有与猫咪系统相关的文件和模式
→ Claude 会使用 Explore Agent

请帮我审查 PR #42 的测试覆盖率
→ Claude 会使用 pr-test-analyzer Agent

请帮我分析这段代码中的静默失败风险
→ Claude 会使用 silent-failure-hunter Agent
```

---

## 四、MCP Plugins（模型上下文协议插件）

### 4.1 Context7 — 实时文档查询

**插件名称**：`context7`

**功能说明**：
- 获取任何编程库或框架的最新文档和代码示例
- 文档内容直接注入到 Claude 的上下文中
- 比 Claude 的训练数据更新、更准确

**使用方式**：

当你需要查阅某个库的最新文档时，Claude 会自动调用 Context7。你也可以显式请求：

```
请用 Context7 查一下 Riverpod 3.x 的 StreamProvider 用法
帮我查阅 GoRouter 的 redirect 配置文档
```

**包含的工具**：
- `resolve-library-id`：将库名解析为 Context7 库 ID
- `query-docs`：从 Context7 获取指定库的文档内容

**适用场景**：
- 需要查阅某个库的最新 API 文档
- 对某个框架的新版本功能不确定时
- 需要参考官方代码示例时

---

## 五、已废弃的 Skills

以下 Skills 已被废弃，请使用替代品：

| 废弃的 Skill | 替代品 | 说明 |
|-------------|--------|------|
| `/brainstorm` | `/brainstorming` | 名称更新 |
| `/execute-plan` | `/executing-plans` | 名称更新 |
| `/write-plan` | `/writing-plans` | 名称更新 |

---

## 六、典型工作流示例

### 6.1 完整的功能开发流程

```
1. /brainstorming          ← 探索需求和设计
2. /writing-plans          ← 制定实施计划
3. /review-plan            ← 审查计划
4. /using-git-worktrees    ← 创建隔离工作环境
5. /test-driven-development ← TDD 实现功能
6. /simplify               ← 简化代码
7. /review-pr              ← 审查代码
8. /commit-push-pr         ← 提交并创建 PR
9. /finishing-a-development-branch ← 收尾
```

### 6.2 Bug 修复流程

```
1. /systematic-debugging   ← 系统化定位根因
2. /test-driven-development ← 先写失败测试，再修复
3. /verification-before-completion ← 验证修复
4. /commit                 ← 提交修复
```

### 6.3 大型任务并行开发

```
1. /writing-plans                    ← 制定计划
2. /dispatching-parallel-agents      ← 分发独立任务
3. /requesting-code-review           ← 审查结果
4. /commit-push-pr                   ← 提交并创建 PR
```

### 6.4 日常维护

```
/clean_gone                          ← 清理本地分支
/claude-md-improver                  ← 改进项目文档
/claude-automation-recommender       ← 优化工作流配置
```

---

## Changelog

| 日期 | 变更 |
|------|------|
| 2026-03-13 | 初始版本：涵盖 34 个 Skills、16 种 Agents、1 个 MCP Plugin |
