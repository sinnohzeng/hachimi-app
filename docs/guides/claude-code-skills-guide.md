# Claude Code Skills, Agents & Plugins Guide

## Purpose

A comprehensive reference for all Claude Code extensions installed in the Hachimi project — covering Skills (slash commands), Agents (sub-agents), and MCP Plugins.

## Scope

For all developers using Claude Code (CLI or VSCode extension) on the Hachimi project.

## Status: Active

## Evidence

- Claude Code session system prompt: `available skills` list
- Claude Code session system prompt: `available agents` list
- MCP Server configuration

## Related

- [Development Workflow](development-workflow.md)
- [Git Worktree Guide](git-worktree.md)
- [Local Dev Feedback Loop](local-dev-feedback-loop.md)
- [中文版](../zh-CN/guides/claude-code-skills-guide.md)

---

## 1. Skills Overview (Slash Commands)

Skills are user-invocable commands triggered by typing `/skill-name`. Claude loads the corresponding skill prompt and follows its workflow.

### Quick Reference

| Category | Command | Description |
|----------|---------|-------------|
| **Git Workflow** | `/commit` | Create a conventional git commit |
| | `/commit-push-pr` | Commit + push + create PR in one step |
| | `/clean_gone` | Clean up local branches with deleted remotes |
| **Code Review** | `/code-review` | Review a pull request |
| | `/review-pr` | Comprehensive multi-agent PR review |
| **Code Quality** | `/simplify` | Review changed code for reuse, quality & efficiency |
| **Frontend** | `/frontend-design` | Create high-quality, distinctive frontend interfaces |
| **Feature Dev** | `/feature-dev` | Guided feature development with architecture focus |
| **Planning** | `/writing-plans` | Write multi-step implementation plans |
| | `/executing-plans` | Execute plans with review checkpoints |
| | `/review-plan` | Architecture-level plan review |
| **Creative** | `/brainstorming` | Explore ideas, requirements & design before implementation |
| **Testing & Debug** | `/test-driven-development` | TDD workflow |
| | `/systematic-debugging` | Systematic root-cause debugging |
| **Git Worktree** | `/using-git-worktrees` | Work in isolated git worktrees |
| **Parallel Dev** | `/dispatching-parallel-agents` | Dispatch independent tasks to parallel agents |
| | `/subagent-driven-development` | Sub-agent driven task execution |
| **Verification** | `/verification-before-completion` | Run verification before claiming completion |
| | `/requesting-code-review` | Request code review for completed work |
| | `/receiving-code-review` | Process code review feedback with rigor |
| | `/finishing-a-development-branch` | Complete a development branch |
| **Project Mgmt** | `/revise-claude-md` | Update CLAUDE.md with session learnings |
| | `/claude-md-improver` | Audit and improve CLAUDE.md files |
| | `/claude-automation-recommender` | Recommend Claude Code automation setup |
| **Utilities** | `/keybindings-help` | Customize keyboard shortcuts |
| | `/loop` | Run commands on a recurring interval |
| **Web & Research** | `/firecrawl-cli` | Web search, scraping & deep research |
| | `/skill-gen` | Generate a Skill from a documentation URL |
| **API Dev** | `/claude-api` | Build Claude API / Anthropic SDK applications |
| **Skill Dev** | `/writing-skills` | Create or edit Claude Code Skills |

---

## 2. Detailed Skill Usage

For detailed usage instructions, parameters, and examples for each skill, see the [Chinese version](../zh-CN/guides/claude-code-skills-guide.md) which contains comprehensive documentation.

### Key Usage Patterns

**Git workflow:**
```
/commit                    # Auto-generates conventional commit
/commit -m "feat: ..."     # With custom message
/commit-push-pr            # Full commit → push → PR flow
/clean_gone                # Prune stale local branches
```

**Code review:**
```
/code-review 123           # Review PR #123
/review-pr                 # Multi-agent comprehensive review
```

**Planning & execution:**
```
/brainstorming             # Before any creative work
/writing-plans             # Create implementation plan
/review-plan               # Architecture review of plan
/executing-plans           # Execute plan with checkpoints
```

**Testing & debugging:**
```
/test-driven-development   # Red-Green-Refactor cycle
/systematic-debugging      # Root-cause analysis workflow
```

**Web research:**
```
/firecrawl-cli             # Search, scrape, research (replaces WebFetch/WebSearch)
```

**Recurring tasks:**
```
/loop 5m /commit           # Run /commit every 5 minutes
/loop 10m check deploy     # Check deploy status every 10 minutes
```

---

## 3. Agents (Sub-Agents)

Agents are specialized sub-processes automatically dispatched by Claude during task execution.

| Agent Type | Purpose |
|-----------|---------|
| `general-purpose` | Complex, multi-step autonomous tasks |
| `Explore` | Fast codebase exploration (file patterns, keyword search) |
| `Plan` | Architecture design and implementation planning |
| `claude-code-guide` | Claude Code feature questions |
| `feature-dev:code-explorer` | Deep execution path tracing and dependency mapping |
| `feature-dev:code-reviewer` | Bug, security & quality review |
| `feature-dev:code-architect` | Feature architecture design |
| `code-simplifier:code-simplifier` | Code simplification for clarity |
| `superpowers:code-reviewer` | Post-step plan compliance review |
| `pr-review-toolkit:code-reviewer` | PR standards compliance review |
| `pr-review-toolkit:silent-failure-hunter` | Silent failure & error handling review |
| `pr-review-toolkit:code-simplifier` | PR code simplification |
| `pr-review-toolkit:comment-analyzer` | Comment accuracy & maintainability review |
| `pr-review-toolkit:pr-test-analyzer` | Test coverage analysis |
| `pr-review-toolkit:type-design-analyzer` | Type design quality analysis |
| `architect-reviewer` | Architecture, tech choices & scalability review |

---

## 4. MCP Plugins

### Context7 — Real-time Documentation

- **Tools**: `resolve-library-id`, `query-docs`
- **Usage**: Automatically invoked when Claude needs up-to-date library documentation
- **Trigger**: Ask Claude to look up docs for any library (e.g., "Check Riverpod 3.x StreamProvider docs")

---

## 5. Deprecated Skills

| Deprecated | Replacement |
|-----------|-------------|
| `/brainstorm` | `/brainstorming` |
| `/execute-plan` | `/executing-plans` |
| `/write-plan` | `/writing-plans` |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-13 | Initial version: 34 Skills, 16 Agent types, 1 MCP Plugin |
