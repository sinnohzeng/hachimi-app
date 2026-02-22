# Release Workflow

> Mandatory post-implementation workflow for committing, tagging, releasing, and verifying CI.

---

## Trigger

After a feature, fix, or any meaningful code change is completed and verified locally (`dart analyze lib/` passes), this workflow MUST be executed automatically — do NOT wait for the user to ask.

---

## Step 1: Format, Commit, and Tag

1. **Format the entire codebase** — run `dart format lib/ test/` on ALL files, not just the ones you edited. CI enforces `--set-exit-if-changed` and will fail on any unformatted file.
2. **Bump version** — increment patch version and build number in `pubspec.yaml` (e.g. `2.8.1+26` -> `2.8.2+27`). The pubspec version MUST match the tag or CI will fail at the "Verify version consistency" step.
3. **Update CHANGELOG.md** — add a new section at the top following the existing Keep a Changelog format.
4. **Write a Git commit message in English** — use conventional commit style (`feat:`, `fix:`, `refactor:`, etc.). The message body should explain *why*, not just *what*.
5. **Create an annotated tag** — `git tag -a vX.Y.Z -m "vX.Y.Z: brief description"`
6. **Push commit and tag together** — `git push origin main --tags`

---

## Step 2: Create GitHub Release

Use `gh release create` with a **user-facing release body**. The release page is what users see when they visit the project — it must NOT be just a changelog link.

### Release body structure:

```markdown
## What's New in vX.Y.Z

### [Feature/Change Title 1]
[2-3 sentences explaining the change in plain language. Focus on what the user will experience, not implementation details.]

### [Feature/Change Title 2]
[Same approach — user-facing, benefit-oriented language.]

---

**Full changelog:** [CHANGELOG.md](https://github.com/sinnohzeng/hachimi-app/blob/main/CHANGELOG.md)
```

### Writing principles:

- **User-first language** — explain *what changed for the user*, not what code was modified
- **Group related changes** — combine small related fixes into logical sections
- **Plain language** — avoid jargon like "ConsumerWidget", "surfaceContainerHigh", "ARB files"
- **No bare links** — never just link to CHANGELOG.md as the entire release body

---

## Step 3: Monitor CI Build

1. After pushing the tag, **immediately start watching the CI run** — use `gh run list` to find the run ID, then `gh run watch <id> --exit-status` to block until completion.
2. If CI **fails**:
   - Read the failed step logs: `gh run view <id> --log-failed`
   - Fix the issue locally (most common: `dart format` failures)
   - Push a fix commit to main
   - Move the tag to the new commit: `git tag -d vX.Y.Z && git tag -a vX.Y.Z -m "..."` then `git push origin vX.Y.Z --force`
   - Watch the new CI run until it passes
3. **Do not consider the task complete until CI is green** and the release has the APK artifact attached.

---

## Common CI Failure Patterns

| Failure Step | Root Cause | Fix |
|---|---|---|
| Check formatting | Missed running `dart format` on all files | Run `dart format lib/ test/`, commit, move tag |
| Verify version consistency | pubspec version doesn't match tag | Fix pubspec version, commit, move tag |
| Static analysis | New error-level lint | Fix the lint issue, commit, move tag |
| Build release APK | Compilation error | Fix the code, commit, move tag |
