# Hachimi — Documentation Index

> **Document-Driven Development (DDD):** Every feature, behavior, and architecture decision is specified in this `docs/` folder **before** implementation. The documents are the contract; code is the implementation. When a document and code conflict, the document takes precedence.

---

## Architecture

| Document | Description |
|----------|-------------|
| [Overview](architecture/overview.md) | System design, tech stack, dependency flow, key patterns |
| [Data Model](architecture/data-model.md) | Firestore schema (SSOT) — all collections, fields, and atomic operations |
| [Cat System](architecture/cat-system.md) | Cat game design (SSOT) — breeds, XP, moods, room slots, draft algorithm |
| [State Management](architecture/state-management.md) | Riverpod provider graph (SSOT) — all providers and their responsibilities |
| [Folder Structure](architecture/folder-structure.md) | Directory layout, naming conventions, layer rules |

---

## Product

| Document | Description |
|----------|-------------|
| [PRD v3.0](product/prd.md) | Full product requirements — features, navigation, analytics strategy |
| [User Stories](product/user-stories.md) | User stories with acceptance criteria |

---

## Firebase

| Document | Description |
|----------|-------------|
| [Setup Guide](firebase/setup-guide.md) | Step-by-step Firebase configuration for new contributors |
| [Analytics Events](firebase/analytics-events.md) | GA4 custom event definitions (SSOT) — all events, parameters, user properties |
| [Security Rules](firebase/security-rules.md) | Firestore security rule spec and deploy instructions |
| [Remote Config](firebase/remote-config.md) | A/B test parameter definitions and Console setup |

---

## Design

| Document | Description |
|----------|-------------|
| [Design System](design/design-system.md) | Material 3 theme (SSOT) — color system, typography, components, spacing |
| [Screens](design/screens.md) | Screen-by-screen UI layout, interactions, and analytics events |

---

## Guides

| Document | Description |
|----------|-------------|
| [Development Workflow](guides/development-workflow.md) | Build modes, hot reload, debugging tools, daily development cycle |
| [Dev / Debug Setup](guides/dev-debug-setup.md) | Device connection, Firebase credentials, troubleshooting install failures |
| [Git Worktree](guides/git-worktree.md) | Parallel development with Git worktrees and Claude Code |

---

## Contributing

| Document | Description |
|----------|-------------|
| [Contributing Guide](CONTRIBUTING.md) | Development workflow, branch naming, commit conventions |

---

## Chinese Documentation

| 文档 | 说明 |
|------|------|
| [中文文档索引](zh-CN/README.md) | 所有文档的中文镜像 |
