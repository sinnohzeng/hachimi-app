# Git Worktree: Parallel Development Guide

> **Purpose:** Explain Git Worktree principles, tooling, and practical workflows for parallel Claude Code sessions.
> **Scope:** Any developer using Claude Code (Max plan) who wants to run multiple AI sessions concurrently.
> **Status:** Active
> **Evidence:** Git official docs, Claude Code docs, community best practices (incident.io, GitButler, motlin.com)
> **Related:** [dev-debug-setup.md](./dev-debug-setup.md) · [Claude Code common workflows](https://code.claude.com/docs/en/common-workflows)
> **Changelog:** 2026-02-20 — Initial version

---

## 1. What Is Git Worktree?

### 1.1 The Problem

In standard Git workflow, a repository has exactly **one working directory**. To work on a different branch, you must:

1. Stash or commit your current changes
2. Switch branches with `git checkout` or `git switch`
3. Wait for the working directory to update
4. Repeat in reverse when switching back

This becomes a serious bottleneck when:

- You need to review a PR while developing a feature
- An urgent hotfix interrupts your current work
- You want to run **multiple Claude Code sessions** on different tasks simultaneously

### 1.2 The Solution

Git Worktree (introduced in Git 2.5) allows you to **check out multiple branches simultaneously**, each in its own separate directory. All worktrees share the same `.git` database — no duplicated history, no wasted disk space.

```
# Mental model

~/.git/              ← Shared repository database (one copy)
├── main-worktree/   ← Branch: main (your primary checkout)
├── feature-a/       ← Branch: feature-a (worktree #1)
├── bugfix-b/        ← Branch: bugfix-b (worktree #2)
└── experiment-c/    ← Branch: experiment-c (worktree #3)
```

### 1.3 Key Properties

| Property | Description |
|----------|-------------|
| Shared history | All worktrees share the same `.git` object database, refs, and remotes |
| Independent state | Each worktree has its own `HEAD`, index (staging area), and working files |
| Branch lock | A branch can only be checked out in **one** worktree at a time |
| Lightweight | Only working files are duplicated — not the entire Git history |
| Native | Built into Git since v2.5 — no plugins or extensions required |

---

## 2. Core Commands

### 2.1 Create a Worktree

```bash
# Create worktree with a new branch
git worktree add ../feature-a -b feature-a

# Create worktree from existing branch
git worktree add ../bugfix-b bugfix-b

# Create worktree from a specific commit/tag
git worktree add ../release-v2 v2.0.0
```

### 2.2 List All Worktrees

```bash
git worktree list
# Output:
# /home/user/project        abc1234 [main]
# /home/user/feature-a      def5678 [feature-a]
# /home/user/bugfix-b       ghi9012 [bugfix-b]
```

### 2.3 Remove a Worktree

```bash
# Remove a worktree (directory must be clean)
git worktree remove ../feature-a

# Force remove (discards uncommitted changes)
git worktree remove --force ../feature-a
```

### 2.4 Prune Stale Entries

```bash
# Clean up worktree references for deleted directories
git worktree prune
```

---

## 3. How Git Worktree Works Internally

```
┌─────────────────────────────────────────────────────────────┐
│                    .git/ (shared database)                   │
│                                                             │
│  objects/    ← All commits, trees, blobs (shared)           │
│  refs/       ← All branches, tags (shared)                  │
│  config      ← Repository configuration (shared)            │
│  worktrees/  ← Metadata for each linked worktree            │
│    ├── feature-a/                                           │
│    │   ├── HEAD        ← Points to feature-a branch         │
│    │   ├── index       ← Independent staging area           │
│    │   ├── gitdir      ← Path back to .git/worktrees/...   │
│    │   └── locked      ← Optional lock file                 │
│    └── bugfix-b/                                            │
│        ├── HEAD        ← Points to bugfix-b branch          │
│        ├── index       ← Independent staging area           │
│        └── gitdir                                           │
└─────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Main Worktree│    │  feature-a  │    │  bugfix-b   │
│ (original)  │    │  (linked)   │    │  (linked)   │
│             │    │             │    │             │
│ .git/ (real)│    │ .git (file) │    │ .git (file) │
│ src/        │    │ src/        │    │ src/        │
│ lib/        │    │ lib/        │    │ lib/        │
└─────────────┘    └─────────────┘    └─────────────┘
```

**Key insight:** Linked worktrees contain a `.git` **file** (not directory) that points back to the main repository's `.git/worktrees/<name>/` metadata. This is how Git maintains the connection without duplicating the database.

---

## 4. Worktree + Claude Code: Parallel Development

### 4.1 Why Worktrees Matter for Claude Code

| Without Worktrees | With Worktrees |
|-------------------|----------------|
| Multiple Claude sessions edit the same files | Each session has isolated file state |
| Branch switching interrupts all sessions | Each session works on its own branch |
| Merge conflicts with yourself | Changes stay isolated until deliberate merge |
| One session's changes can confuse another | Complete context isolation |

### 4.2 Claude Code Built-in `/worktree` Command

Claude Code provides a built-in worktree command that automates the workflow:

```
# Inside Claude Code, type:
/worktree
```

This automatically:

1. Creates a new Git worktree branched from `HEAD`
2. Switches the session's working directory to the new worktree
3. Places worktrees in `.claude/worktrees/`
4. Prompts cleanup on session exit

### 4.3 Recommended Parallel Workflow

```
Terminal 1 (Main feature)          Terminal 2 (Bugfix)
┌────────────────────────┐        ┌────────────────────────┐
│ cd ~/project           │        │ cd ~/project-bugfix    │
│ claude                 │        │ claude                 │
│                        │        │                        │
│ Working on: feature-x  │        │ Working on: fix-123    │
│ Branch: feature-x      │        │ Branch: fix-123        │
│ Files: isolated         │        │ Files: isolated         │
└────────────────────────┘        └────────────────────────┘

Terminal 3 (Tests/Review)
┌────────────────────────┐
│ cd ~/project-review    │
│ claude                 │
│                        │
│ Working on: PR review  │
│ Branch: pr-456         │
│ Files: isolated         │
└────────────────────────┘
```

### 4.4 Step-by-Step Setup

```bash
# 1. From your main project directory, create worktrees
cd ~/workspace/hachimi-app
git worktree add ../hachimi-feature-a -b feature-a
git worktree add ../hachimi-bugfix-b -b bugfix-b

# 2. Open separate terminals for each worktree
# Terminal 1:
cd ~/workspace/hachimi-app          # Main development
claude

# Terminal 2:
cd ~/workspace/hachimi-feature-a    # Feature work
claude

# Terminal 3:
cd ~/workspace/hachimi-bugfix-b     # Bugfix work
claude

# 3. When done, merge and clean up
cd ~/workspace/hachimi-app
git merge feature-a
git worktree remove ../hachimi-feature-a
git branch -d feature-a
```

---

## 5. Community Best Practices

### 5.1 incident.io's `w` Function (4-5 Parallel Agents)

incident.io created a shell function for frictionless worktree management:

```bash
w myproject new-feature              # Create and enter worktree
w myproject new-feature claude       # Launch Claude in worktree
w myproject new-feature git status   # Run commands in worktree context
```

Their approach:
- Centralize worktrees under `~/projects/worktrees/`
- Prefix branch names with username for team collaboration
- Run 4-5 parallel Claude Code sessions routinely
- Use Plan Mode to review Claude's approach before execution

### 5.2 GitButler's Hook-Based Approach (No Worktrees Needed)

GitButler offers an alternative using Claude Code lifecycle hooks:

1. **Session detection** — hooks alert GitButler when files change
2. **Automatic branch creation** — one branch per Claude Code session
3. **Smart commits** — one commit per chat round, automatically organized

This eliminates worktree complexity but requires the GitButler CLI.

### 5.3 Crystal: Desktop GUI for Parallel Sessions

[Crystal](https://github.com/stravu/crystal) is an open-source desktop app that provides a visual interface for managing multiple Claude Code sessions in parallel worktrees.

### 5.4 The `/worktree` + `/todo` Pattern

From motlin.com:

```bash
# Create N parallel worktrees, each with a single task
/worktree 3

# Each worktree gets:
# - Its own branch from main
# - A dedicated .llm/todo.md with one task
# - An independent Claude Code session running /todo
```

For managing API limits with many worktrees:

```bash
# Space requests to avoid rate limiting
for i in $(seq 1 5); do
  claude --print /worktree
  sleep 1200    # 20-minute gap between launches
done
```

---

## 6. Pitfalls and How to Avoid Them

### 6.1 Common Issues

| Pitfall | Cause | Solution |
|---------|-------|----------|
| Branch already checked out | Git prevents the same branch in two worktrees | Always create a **new branch** for each worktree |
| Build artifacts conflict | `node_modules/`, `build/` not shared properly | Run dependency install in each worktree separately |
| IDE confusion | IDE may not recognize worktree as project | Open each worktree as a separate project/window |
| Merge conflicts with yourself | Parallel edits to the same file | Assign different **modules/files** to each session |
| Stale worktrees accumulate | Forgetting to clean up | Run `git worktree list` regularly; prune unused ones |
| Shared lock files | `.lock` files conflict across worktrees | Add lock files to `.gitignore` |

### 6.2 Golden Rules

1. **One task per worktree** — never share a worktree between multiple concerns
2. **Different files per session** — avoid two Claude sessions editing the same file
3. **Merge frequently** — don't let worktree branches diverge too far from `main`
4. **Clean up promptly** — remove worktrees as soon as the task is merged
5. **Run `/init` in each worktree** — ensure Claude Code is oriented to the codebase context
6. **Limit parallel sessions to 2-3** on Max plan — balance throughput vs. quota consumption

---

## 7. Quick Reference Card

```bash
# ─── Create ───
git worktree add <path> -b <new-branch>     # New branch
git worktree add <path> <existing-branch>    # Existing branch

# ─── Inspect ───
git worktree list                            # List all worktrees
git worktree list --porcelain                # Machine-readable format

# ─── Clean Up ───
git worktree remove <path>                   # Remove worktree
git worktree remove --force <path>           # Force remove
git worktree prune                           # Prune stale entries

# ─── Claude Code ───
/worktree                                    # Built-in command
/worktree 3                                  # Create 3 parallel worktrees

# ─── Workflow ───
cd <worktree-path> && claude                 # Launch Claude in worktree
git merge <branch> && git worktree remove <path>  # Merge and clean up
```
