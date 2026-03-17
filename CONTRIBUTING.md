# Contributing to Hachimi

Thank you for your interest in Hachimi.

## License

Hachimi is released under a proprietary license (see [LICENSE](LICENSE)).
**External code contributions (pull requests) are not accepted.**
The codebase is shared publicly as a portfolio reference, not as an open-source project.

## What you can do

- **Report bugs** — open a [Bug Report](https://github.com/sinnohzeng/hachimi-app/issues/new?template=bug_report.yml) with reproduction steps
- **Request features** — open a [Feature Request](https://github.com/sinnohzeng/hachimi-app/issues/new?template=feature_request.yml) to discuss product direction
- **Report security vulnerabilities** — see [SECURITY.md](SECURITY.md) for the private reporting process

## For developers learning from this codebase

If you are studying the architecture or forking for personal use, here is how the project is maintained:

### Document-Driven Development (DDD)

Every code change follows this order:

1. Read the relevant spec in `docs/` (or `docs/zh-CN/` for Chinese)
2. Update the spec if the change introduces a new interface, model, route, or service
3. Implement in code
4. Keep EN and zh-CN docs in sync

### Quality red lines

These are enforced by CI and the `dart run tool/quality_gate.dart` gate:

| Metric | Limit |
| ------ | ----- |
| File size | ≤ 800 lines |
| Function size | ≤ 30 lines |
| Nesting depth | ≤ 3 |
| Branch count | ≤ 5 / function |

### Architecture layers

```
Screens → Providers → Services → Firebase SDK
```

Screens never import Services directly. Providers never call the Firebase SDK directly.

### Dependency flow

- State management: Riverpod 3.x (`StreamProvider`, `FutureProvider`, `StateNotifierProvider`)
- All Firebase interactions are encapsulated in `lib/services/`
- See `docs/architecture/` for the full architecture overview
