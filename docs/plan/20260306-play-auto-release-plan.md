# Plan: Play Auto-Release + Supply-Chain Hardening

> Date: 2026-03-06 | Status: Active | Scope: CI/CD pipeline

## Goal

Upgrade the release pipeline from "tag > internal track > manual promote" to "tag > production track (automatic)" while hardening supply-chain security.

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Release track | production (100% rollout) | Near-daily cadence makes staged rollout impractical |
| Auth | WIF/OIDC (unchanged) | Already best-practice keyless auth |
| Action pinning | Commit SHA + Dependabot | Prevents tag-repointing supply-chain attacks |
| Secrets isolation | GitHub `production` Environment | Only `v*` tags can access release secrets |
| Build provenance | Sigstore attestation | Verifiable APK origin |

## Changes Made

| File | Change |
|------|--------|
| `.github/workflows/release.yml` | SHA pins, `permissions: {}`, `environment: production`, `track: production`, whatsnew guard, provenance, enhanced release body + summary |
| `.github/workflows/ci.yml` | SHA pins for 4 actions |
| `.github/dependabot.yml` | New — weekly GitHub Actions updates |
| `distribution/whatsnew/*` | Version-specific content (was generic) |
| `docs/release/process.md` | Production track, rollback procedure, supply-chain security |
| `docs/release/google-play-setup.md` | Environment setup, production track |
| `docs/release/play-auto-release-runbook.md` | New — manual setup guide + operations |
| `.claude/rules/12-workflow-release.md` | Production track, whatsnew guard failure pattern |

## Items Deferred (Over-Engineering)

- RC tag routing (`vX.Y.Z-rc.N`) — zero historical usage
- Auto-generated whatsnew via Dart script — fragile with 500-char limit
- Country availability drift detection — no exclusions exist
- 4-job workflow split — adds overhead without benefit
- Staged rollout — incompatible with daily release cadence

## Manual Steps Required

See `docs/release/play-auto-release-runbook.md` for detailed instructions.

## Changelog

| Date | Change |
|------|--------|
| 2026-03-06 | Initial plan created and executed |
