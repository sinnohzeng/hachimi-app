# Git Worktree：并行开发完全指南

> **Purpose（目的）：** 详解 Git Worktree 的原理、工具链与实战工作流，帮助开发者在 Claude Code 中实现多会话并行开发。
> **Scope（适用范围）：** 使用 Claude Code Max 套餐、需要同时运行多个 AI 会话的开发者。
> **Status（状态）：** Active
> **Evidence（证据来源）：** Git 官方文档、Claude Code 官方文档、社区最佳实践（incident.io、GitButler、motlin.com）
> **Related（相关文档）：** [dev-debug-setup.md](./dev-debug-setup.md) · [Claude Code 常用工作流](https://code.claude.com/docs/en/common-workflows)
> **Changelog（更新日志）：** 2026-02-20 — 初版

---

## 1. 什么是 Git Worktree？

### 1.1 传统 Git 工作流的痛点

在标准的 Git 工作流中，一个仓库 **只有一个工作目录** 。如果你想切换到另一个分支，必须经历以下步骤：

1. 暂存（`git stash`）或提交当前未完成的修改
2. 用 `git checkout` 或 `git switch` 切换分支
3. 等待工作目录更新文件
4. 完成后再切回来，恢复之前的工作

这在以下场景中会成为 **严重的效率瓶颈** ：

- 开发功能时，需要暂停去审查一个 PR（Pull Request，拉取请求）
- 紧急的线上 Hotfix（热修复）打断了当前的开发任务
- 你想 **同时运行多个 Claude Code 会话** ，分别处理不同的任务

### 1.2 Worktree 的解决方案

Git Worktree（工作树）是 Git 2.5 引入的原生功能，它允许你 **同时签出多个分支** ，每个分支位于独立的目录中。所有 Worktree 共享同一个 `.git` 数据库——不重复存储历史记录，不浪费磁盘空间。

```
# 心智模型

~/.git/              ← 共享的仓库数据库（只有一份）
├── main-worktree/   ← 分支：main（你的主签出）
├── feature-a/       ← 分支：feature-a（Worktree #1）
├── bugfix-b/        ← 分支：bugfix-b（Worktree #2）
└── experiment-c/    ← 分支：experiment-c（Worktree #3）
```

### 1.3 核心特性

| 特性 | 说明 |
|------|------|
| 共享历史 | 所有 Worktree 共享同一个 `.git` 对象数据库、引用和远程配置 |
| 独立状态 | 每个 Worktree 拥有自己的 `HEAD`、Index（暂存区）和工作文件 |
| 分支锁定 | 同一个分支 **只能** 在一个 Worktree 中被签出 |
| 轻量级 | 只复制工作文件——不复制整个 Git 历史 |
| 原生支持 | Git 2.5 起内置，无需安装插件或扩展 |

---

## 2. 基础命令

### 2.1 创建 Worktree

```bash
# 创建 Worktree 并同时新建分支
git worktree add ../feature-a -b feature-a

# 基于已有分支创建 Worktree
git worktree add ../bugfix-b bugfix-b

# 基于特定 Commit 或 Tag 创建 Worktree
git worktree add ../release-v2 v2.0.0
```

### 2.2 查看所有 Worktree

```bash
git worktree list
# 输出示例：
# /home/user/project        abc1234 [main]
# /home/user/feature-a      def5678 [feature-a]
# /home/user/bugfix-b       ghi9012 [bugfix-b]
```

### 2.3 删除 Worktree

```bash
# 删除 Worktree（目录必须是干净的）
git worktree remove ../feature-a

# 强制删除（丢弃未提交的修改）
git worktree remove --force ../feature-a
```

### 2.4 清理过期条目

```bash
# 清理已删除目录的 Worktree 引用
git worktree prune
```

---

## 3. 底层原理：Worktree 是怎么工作的？

### 3.1 内部结构

```
┌─────────────────────────────────────────────────────────────┐
│                    .git/（共享数据库）                         │
│                                                             │
│  objects/    ← 所有 Commit、Tree、Blob 对象（共享）            │
│  refs/       ← 所有分支、标签引用（共享）                       │
│  config      ← 仓库配置（共享）                               │
│  worktrees/  ← 每个链接 Worktree 的元数据                     │
│    ├── feature-a/                                           │
│    │   ├── HEAD        ← 指向 feature-a 分支                │
│    │   ├── index       ← 独立的暂存区                        │
│    │   ├── gitdir      ← 指回 .git/worktrees/... 的路径     │
│    │   └── locked      ← 可选的锁文件                        │
│    └── bugfix-b/                                            │
│        ├── HEAD        ← 指向 bugfix-b 分支                 │
│        ├── index       ← 独立的暂存区                        │
│        └── gitdir                                           │
└─────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  主 Worktree │    │  feature-a  │    │  bugfix-b   │
│  （原始目录） │    │ （链接目录） │    │ （链接目录） │
│             │    │             │    │             │
│ .git/（目录）│    │ .git（文件）│    │ .git（文件）│
│ src/        │    │ src/        │    │ src/        │
│ lib/        │    │ lib/        │    │ lib/        │
└─────────────┘    └─────────────┘    └─────────────┘
```

### 3.2 关键细节

- **主 Worktree** 的 `.git` 是一个 **目录** ，包含完整的仓库数据库
- **链接 Worktree** 的 `.git` 是一个 **文件** （不是目录），内容是指回主仓库 `.git/worktrees/<name>/` 元数据的路径
- 所有 Worktree 共享同一份 Object 数据库，因此 `git log`、`git reflog` 等命令在任何 Worktree 中都能看到完整历史
- Git 通过 **分支锁定** 机制防止同一个分支在多个 Worktree 中被同时签出，避免状态冲突

### 3.3 与 `git clone` 的区别

| 对比项 | `git worktree add` | `git clone` |
|--------|-------------------|-------------|
| 历史存储 | 共享（不复制） | 完全复制 |
| 磁盘占用 | 仅工作文件 | 完整仓库 + 工作文件 |
| 远程同步 | 自动共享 Remote（远程仓库）配置 | 独立的 Remote 配置 |
| 分支关系 | 同仓库、互相可见 | 完全独立 |
| 适用场景 | 同项目并行开发 | 独立项目副本 |

---

## 4. Worktree + Claude Code：并行开发实战

### 4.1 为什么 Worktree 对 Claude Code 至关重要？

| 无 Worktree | 有 Worktree |
|-------------|-------------|
| 多个 Claude 会话编辑相同文件，互相干扰 | 每个会话拥有隔离的文件状态 |
| 切换分支会打断所有会话 | 每个会话在自己的分支上独立工作 |
| 容易「跟自己产生合并冲突」 | 修改保持隔离，直到你主动合并 |
| 一个会话的修改可能让另一个会话困惑 | 完全的上下文隔离 |

### 4.2 Claude Code 内置 `/worktree` 命令

Claude Code 提供了内置的 Worktree 管理命令：

```
# 在 Claude Code 会话中输入：
/worktree
```

该命令会自动完成以下操作：

1. 基于当前 `HEAD` 创建一个新的 Git Worktree
2. 将当前会话的工作目录切换到新的 Worktree
3. Worktree 存放在 `.claude/worktrees/` 目录下
4. 会话退出时提示你是否保留或删除该 Worktree

### 4.3 推荐的并行工作流

```
终端 1（主要功能开发）               终端 2（Bug 修复）
┌────────────────────────┐        ┌────────────────────────┐
│ cd ~/project           │        │ cd ~/project-bugfix    │
│ claude                 │        │ claude                 │
│                        │        │                        │
│ 任务：feature-x        │        │ 任务：fix-123          │
│ 分支：feature-x        │        │ 分支：fix-123          │
│ 文件：隔离              │        │ 文件：隔离              │
└────────────────────────┘        └────────────────────────┘

终端 3（测试 / 代码审查）
┌────────────────────────┐
│ cd ~/project-review    │
│ claude                 │
│                        │
│ 任务：PR 审查           │
│ 分支：pr-456           │
│ 文件：隔离              │
└────────────────────────┘
```

### 4.4 手把手操作流程

```bash
# ━━━ 第 1 步：创建 Worktree ━━━
cd ~/workspace/hachimi-app
git worktree add ../hachimi-feature-a -b feature-a
git worktree add ../hachimi-bugfix-b -b bugfix-b

# ━━━ 第 2 步：在不同终端启动 Claude Code ━━━

# 终端 1：主开发目录
cd ~/workspace/hachimi-app
claude

# 终端 2：功能开发
cd ~/workspace/hachimi-feature-a
claude

# 终端 3：Bug 修复
cd ~/workspace/hachimi-bugfix-b
claude

# ━━━ 第 3 步：完成后合并并清理 ━━━
cd ~/workspace/hachimi-app
git merge feature-a
git worktree remove ../hachimi-feature-a
git branch -d feature-a
```

### 4.5 Flutter 项目的特殊注意事项

由于 Hachimi 是 Flutter 项目，创建 Worktree 后需要额外执行：

```bash
# 在每个新 Worktree 中执行依赖安装
cd ~/workspace/hachimi-feature-a
flutter pub get

# 如果需要构建，还需要确保 build/ 目录独立
# （build/ 已在 .gitignore 中，不会冲突）
```

**注意：** `build/` 和 `.dart_tool/` 目录不会在 Worktree 之间共享，每个 Worktree 需要独立生成。这意味着首次构建会比较慢，但能确保完全隔离。

---

## 5. 社区最佳实践

### 5.1 incident.io 的 `w` 函数（4-5 个并行 Agent）

incident.io 团队创建了一个自定义 Shell 函数来消除 Worktree 管理的摩擦：

```bash
w myproject new-feature              # 创建并进入 Worktree
w myproject new-feature claude       # 在 Worktree 中启动 Claude
w myproject new-feature git status   # 在 Worktree 上下文中执行命令
```

他们的关键策略：

- **集中存放** ：所有 Worktree 统一放在 `~/projects/worktrees/` 下
- **用户名前缀** ：分支名以用户名为前缀，方便团队协作识别
- **日常并行 4-5 个** Claude Code 会话
- **Plan Mode 优先** ：先用 Plan Mode 审查 Claude 的方案，再执行代码变更
- **语音驱动开发** ：用语音工具口述需求 5 分钟，标记相关文件，让 Claude 生成实现

### 5.2 GitButler 的 Hook 方案（无需 Worktree）

GitButler 提供了一种 **不需要 Worktree** 的替代方案，利用 Claude Code 的生命周期 Hook（钩子）实现：

1. **会话检测** ——Hook 在文件变更时通知 GitButler，并携带唯一的 Session ID（会话标识）
2. **自动创建分支** ——GitButler 为每个检测到的会话自动创建一个独立分支
3. **智能提交** ——每轮对话自动生成一次 Commit（提交），并根据 Prompt（提示词）和修改的文件自动生成提交信息

最终效果：「每轮对话一个 Commit，每个 Claude Code 会话一个分支」——无需手动管理 Worktree。

### 5.3 Crystal：桌面 GUI 管理工具

[Crystal](https://github.com/stravu/crystal) 是一个开源桌面应用，提供可视化界面来管理多个 Claude Code 会话在并行 Worktree 中的运行。

### 5.4 `/worktree` + `/todo` 模式

来自 motlin.com 的工作流：

```bash
# 创建 N 个并行 Worktree，每个分配一个独立任务
/worktree 3

# 每个 Worktree 自动获得：
# - 从 main 分支拉出的独立分支
# - 专属的 .llm/todo.md，只包含一个任务
# - 独立的 Claude Code 会话，运行 /todo 命令
```

为了避免多个并行会话过快消耗 API 配额：

```bash
# 设置启动间隔，避免触发速率限制
for i in $(seq 1 5); do
  claude --print /worktree
  sleep 1200    # 每次启动间隔 20 分钟
done
```

---

## 6. 常见陷阱与规避方法

### 6.1 问题速查表

| 陷阱 | 原因 | 解决方案 |
|------|------|----------|
| 「Branch is already checked out」 | Git 不允许同一分支在两个 Worktree 中签出 | 为每个 Worktree 创建 **新分支** |
| 构建产物冲突 | `node_modules/`、`build/` 等目录未正确隔离 | 在每个 Worktree 中 **独立安装依赖** |
| IDE 无法识别项目 | IDE 可能不认识 Worktree 的目录结构 | 将每个 Worktree 作为 **独立项目** 打开 |
| 跟自己产生合并冲突 | 多个会话并行编辑了同一个文件 | 给不同会话分配 **不同的模块 / 文件** |
| 过期 Worktree 堆积 | 忘记清理已完成的 Worktree | 定期执行 `git worktree list`，及时清理 |
| 共享锁文件冲突 | `.lock` 文件在 Worktree 间冲突 | 将锁文件添加到 `.gitignore` |

### 6.2 黄金法则

1. **一个 Worktree 只做一件事** ——不要在同一个 Worktree 中混合多个不相关的任务
2. **不同会话负责不同文件** ——避免两个 Claude 会话编辑同一个文件
3. **频繁合并** ——不要让 Worktree 分支与 `main` 偏离太远
4. **及时清理** ——任务合并后立即删除 Worktree
5. **每个 Worktree 执行 `/init`** ——确保 Claude Code 正确感知代码库上下文
6. **Max 套餐建议并行 2-3 个会话** ——在吞吐量和配额消耗之间取得平衡

---

## 7. 速查卡片

```bash
# ━━━ 创建 ━━━
git worktree add <路径> -b <新分支名>        # 新建分支
git worktree add <路径> <已有分支名>          # 已有分支

# ━━━ 查看 ━━━
git worktree list                            # 列出所有 Worktree
git worktree list --porcelain                # 机器可读格式

# ━━━ 清理 ━━━
git worktree remove <路径>                   # 删除 Worktree
git worktree remove --force <路径>           # 强制删除
git worktree prune                           # 清理过期条目

# ━━━ Claude Code ━━━
/worktree                                    # 内置命令（自动创建）
/worktree 3                                  # 创建 3 个并行 Worktree

# ━━━ 完整工作流 ━━━
cd <worktree路径> && claude                  # 在 Worktree 中启动 Claude
git merge <分支> && git worktree remove <路径>  # 合并后清理
```

---

## 8. 推荐阅读

- [Git 官方文档：git-worktree](https://git-scm.com/docs/git-worktree)
- [Claude Code 官方文档：常用工作流](https://code.claude.com/docs/en/common-workflows)
- [Claude Code 官方文档：Agent Teams](https://code.claude.com/docs/en/agent-teams)
- [incident.io：使用 Claude Code 和 Git Worktrees 加速交付](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees)
- [GitButler：无需 Worktree 管理多个 Claude Code 会话](https://blog.gitbutler.com/parallel-claude-code)
- [motlin.com：Claude Code 并行开发与 /worktree](https://motlin.com/blog/claude-code-worktree)
- [Anthropic 工程博客：用并行 Claude 构建 C 编译器](https://www.anthropic.com/engineering/building-c-compiler)
