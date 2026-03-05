#!/usr/bin/env bash
set -euo pipefail

required=(
  GOOGLE_SERVICES_JSON
  FIREBASE_OPTIONS_DART
  KEYSTORE_BASE64
  KEYSTORE_PASSWORD
  KEY_ALIAS
  KEY_PASSWORD
  WIF_PROVIDER
  WIF_SERVICE_ACCOUNT
)

missing=()
for key in "${required[@]}"; do
  if [[ -z "${!key:-}" ]]; then
    missing+=("$key")
  fi
done

if ((${#missing[@]} > 0)); then
  echo "Missing required release secrets: ${missing[*]}" >&2
  exit 1
fi

decode_check=(GOOGLE_SERVICES_JSON FIREBASE_OPTIONS_DART KEYSTORE_BASE64)
for key in "${decode_check[@]}"; do
  if ! printf '%s' "${!key}" | base64 --decode >/dev/null 2>&1; then
    echo "Secret $key is not valid base64 payload." >&2
    exit 1
  fi
done

if [[ -n "${MINIMAX_API_KEY:-}" || -n "${GEMINI_API_KEY:-}" ]]; then
  echo "Warning: legacy AI key secrets detected; they are no longer used by release workflow." >&2
fi

echo "Release secrets check passed."
