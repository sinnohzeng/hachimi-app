# Security Policy

## Supported Versions

Only the latest release receives security fixes. Older versions are not maintained.

| Version | Supported |
| ------- | --------- |
| Latest  | ✅        |
| < Latest | ❌       |

## Scope

This policy covers the Hachimi Android application and its backend infrastructure:

- **Firebase Authentication** — user identity and session management
- **Cloud Firestore** — habit data, cat data, focus session records, AI diary entries, chat history
- **Firebase Cloud Functions** — `deleteAccountV1`, `wipeUserDataV1` callables
- **AI integrations** — Gemini and MiniMax API calls from the client

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.** Public disclosure before a fix is ready puts all users at risk.

Instead, use GitHub's private vulnerability reporting:

👉 [Report a vulnerability privately](https://github.com/sinnohzeng/hachimi-app/security/advisories/new)

### What to include

A useful report contains:

1. A clear description of the vulnerability and its potential impact
2. Steps to reproduce, including any relevant device, OS version, or app version
3. Proof-of-concept code or screenshots if available
4. Your assessment of severity (Critical / High / Medium / Low)

### Response timeline

| Milestone | Target |
| --------- | ------ |
| Initial acknowledgement | Within 7 days |
| Severity assessment | Within 14 days |
| Fix or mitigation | Varies by severity; critical issues are prioritised |
| Public disclosure | Coordinated with reporter after fix is released |

## Out of Scope

The following are **not** considered vulnerabilities for this project:

- Issues in third-party libraries that are already publicly disclosed (report upstream)
- Attacks that require physical access to an unlocked device
- Self-XSS or issues that only affect the attacker's own account
- Denial-of-service attacks targeting Firebase infrastructure (report to Google)

## Hall of Fame

Responsible disclosures that result in a confirmed fix will be credited here (with permission).
