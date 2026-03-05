#!/usr/bin/env bash
set -euo pipefail

if ! command -v bq >/dev/null 2>&1; then
  echo "bq CLI is required." >&2
  exit 1
fi

if ! command -v gcloud >/dev/null 2>&1; then
  echo "gcloud CLI is required." >&2
  exit 1
fi

PROJECT_ID="${PROJECT_ID:-}"
LOCATION="${LOCATION:-US}"
DATASET="${DATASET:-obs}"
TTL_DAYS="${TTL_DAYS:-90}"
ANALYTICS_DATASET="${ANALYTICS_DATASET:-}"

if [[ -z "${PROJECT_ID}" ]]; then
  echo "Set PROJECT_ID before running this script." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SQL_DIR="${ROOT_DIR}/functions/sql/observability"

if [[ -z "${ANALYTICS_DATASET}" ]]; then
  ANALYTICS_DATASET="$(
    bq --project_id="${PROJECT_ID}" ls \
      | awk '/analytics_[0-9]+/ {print $1; exit}'
  )"
fi

if [[ -z "${ANALYTICS_DATASET}" ]]; then
  echo "Cannot find Analytics dataset. Set ANALYTICS_DATASET explicitly." >&2
  exit 1
fi

bq --project_id="${PROJECT_ID}" --location="${LOCATION}" mk --dataset --if_not_exists "${PROJECT_ID}:${DATASET}"

SCHEMA_SQL_TMP="$(mktemp)"
trap 'rm -f "${SCHEMA_SQL_TMP}"' EXIT
sed "s/__ANALYTICS_DATASET__/${ANALYTICS_DATASET}/g" \
  "${SQL_DIR}/obs_schema.sql" > "${SCHEMA_SQL_TMP}"

bq --project_id="${PROJECT_ID}" --location="${LOCATION}" query --use_legacy_sql=false < "${SCHEMA_SQL_TMP}"

bq --project_id="${PROJECT_ID}" --location="${LOCATION}" update \
  --default_table_expiration "$((TTL_DAYS * 24 * 3600))" \
  "${PROJECT_ID}:${DATASET}"

bq --project_id="${PROJECT_ID}" --location="${LOCATION}" mk \
  --transfer_config \
  --data_source=scheduled_query \
  --target_dataset="${DATASET}" \
  --display_name="hachimi_refresh_ai_debug_tasks_v1" \
  --schedule="every 15 minutes" \
  --params="{\"query\":\"$(tr '\n' ' ' < "${SQL_DIR}/refresh_ai_debug_tasks.sql" | sed 's/"/\\\\"/g')\"}" || true

if [[ -n "${BILLING_ACCOUNT_ID:-}" ]]; then
  gcloud beta billing budgets create \
    --billing-account="${BILLING_ACCOUNT_ID}" \
    --display-name="hachimi-obs-budget" \
    --budget-amount="${BUDGET_AMOUNT:-50}" \
    --threshold-rule=percent=0.5,basis=CURRENT_SPEND \
    --threshold-rule=percent=0.8,basis=CURRENT_SPEND \
    --threshold-rule=percent=1.0,basis=CURRENT_SPEND \
    --project="${PROJECT_ID}" || true
fi

echo "Observability setup completed for project ${PROJECT_ID}."
