#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${1:-hachimi-ai}"
REQUIRED_FUNCTIONS=("deleteAccountV2" "wipeUserDataV2")

if ! command -v firebase >/dev/null 2>&1; then
  echo "Error: firebase CLI is required." >&2
  exit 1
fi

echo "Checking account lifecycle functions in project: ${PROJECT_ID}"
LIST_OUTPUT="$(firebase functions:list --project "${PROJECT_ID}" 2>/dev/null || true)"

if [[ -z "${LIST_OUTPUT}" ]]; then
  echo "Error: unable to fetch Cloud Functions list for ${PROJECT_ID}." >&2
  exit 1
fi

MISSING=()
for fn in "${REQUIRED_FUNCTIONS[@]}"; do
  if ! grep -qE "(^|[[:space:]])${fn}([[:space:]]|$)" <<<"${LIST_OUTPUT}"; then
    MISSING+=("${fn}")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Missing required functions: ${MISSING[*]}" >&2
  echo "--- firebase functions:list output ---" >&2
  echo "${LIST_OUTPUT}" >&2
  exit 1
fi

echo "All required account lifecycle functions are deployed."
