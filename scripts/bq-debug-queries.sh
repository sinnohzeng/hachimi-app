#!/usr/bin/env bash
# ============================================================================
# Hachimi — BigQuery 调试查询脚本
#
# 用途：快速查询 Crashlytics 崩溃数据和 GA4 分析数据
# 前提：bq CLI 已安装、已通过 gcloud auth login 认证
#
# 使用方法：
#   ./scripts/bq-debug-queries.sh <command> [options]
#
# 命令：
#   crashes    查看最近崩溃记录
#   hotspots   崩溃热力图（按 issue 分组统计）
#   usage      功能使用频率排行
#   versions   版本崩溃率对比
#   help       显示帮助信息
# ============================================================================

set -euo pipefail

# ── 配置 ──────────────────────────────────────────────────────────────
PROJECT_ID="hachimi-ai"
CRASHLYTICS_TABLE="${PROJECT_ID}.firebase_crashlytics.com_hachimi_hachimi_app"
# GA4 表名需要替换 PROPERTY_ID（首次使用时在 BigQuery 中查看实际数据集名）
ANALYTICS_DATASET="analytics_PROPERTY_ID"
# ────────────────────────────────────────────────────────────────────────

# 默认参数
DAYS=7
VERSION=""
LIMIT=50

usage() {
  cat <<'HELP'
Hachimi BigQuery 调试查询工具

用法：
  ./scripts/bq-debug-queries.sh <command> [options]

命令：
  crashes    查看最近崩溃记录
  hotspots   崩溃热力图（按 issue 分组）
  usage      功能使用频率排行
  versions   版本崩溃率对比
  help       显示此帮助信息

选项：
  --days N       查询最近 N 天的数据（默认：7）
  --version X    筛选特定应用版本（如 2.27.0）
  --limit N      返回结果数量（默认：50）

示例：
  ./scripts/bq-debug-queries.sh crashes --days 3
  ./scripts/bq-debug-queries.sh crashes --version 2.27.0 --limit 20
  ./scripts/bq-debug-queries.sh hotspots --days 30
  ./scripts/bq-debug-queries.sh usage --days 7
  ./scripts/bq-debug-queries.sh versions
HELP
}

# ── 参数解析 ──────────────────────────────────────────────────────────
COMMAND="${1:-help}"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --days)
      DAYS="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --limit)
      LIMIT="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1"
      usage
      exit 1
      ;;
  esac
done

# ── 前置检查 ──────────────────────────────────────────────────────────
check_bq() {
  if ! command -v bq &>/dev/null; then
    echo "错误: 需要安装 bq CLI（随 Google Cloud SDK 一起安装）"
    echo "安装方式: https://cloud.google.com/sdk/docs/install"
    exit 1
  fi
}

run_query() {
  local query="$1"
  bq query \
    --use_legacy_sql=false \
    --max_rows="${LIMIT}" \
    --format=prettyjson \
    "${query}"
}

# ── 版本过滤条件构建 ──────────────────────────────────────────────────
version_filter() {
  if [[ -n "${VERSION}" ]]; then
    echo "AND app_version = '${VERSION}'"
  fi
}

# ── 查询命令 ──────────────────────────────────────────────────────────

cmd_crashes() {
  check_bq
  echo "▶ 查询最近 ${DAYS} 天的崩溃记录${VERSION:+（版本: ${VERSION}）}..."
  run_query "
SELECT
  event_timestamp,
  app_version,
  device_model,
  os_version,
  issue_title,
  is_fatal,
  blame_frame.file AS blame_file,
  blame_frame.line AS blame_line,
  blame_frame.symbol AS blame_symbol
FROM \`${CRASHLYTICS_TABLE}\`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL ${DAYS} DAY)
  $(version_filter)
ORDER BY event_timestamp DESC
LIMIT ${LIMIT}
"
}

cmd_hotspots() {
  check_bq
  echo "▶ 查询最近 ${DAYS} 天的崩溃热力图..."
  run_query "
SELECT
  issue_id,
  issue_title,
  COUNT(*) AS crash_count,
  COUNTIF(is_fatal) AS fatal_count,
  COUNT(DISTINCT device_model) AS affected_devices,
  MIN(event_timestamp) AS first_seen,
  MAX(event_timestamp) AS last_seen
FROM \`${CRASHLYTICS_TABLE}\`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL ${DAYS} DAY)
  $(version_filter)
GROUP BY issue_id, issue_title
ORDER BY crash_count DESC
LIMIT ${LIMIT}
"
}

cmd_usage() {
  check_bq
  echo "▶ 查询最近 ${DAYS} 天的功能使用频率..."
  run_query "
SELECT
  event_name,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM \`${PROJECT_ID}.${ANALYTICS_DATASET}.events_*\`
WHERE _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL ${DAYS} DAY))
  AND event_name NOT IN ('session_start', 'first_visit', 'screen_view', 'user_engagement')
GROUP BY event_name
ORDER BY event_count DESC
LIMIT ${LIMIT}
"
}

cmd_versions() {
  check_bq
  echo "▶ 查询版本崩溃率对比（最近 90 天）..."
  run_query "
SELECT
  app_version,
  COUNT(*) AS total_crashes,
  COUNTIF(is_fatal) AS fatal_crashes,
  COUNT(DISTINCT device_model) AS affected_devices,
  MIN(event_timestamp) AS first_crash,
  MAX(event_timestamp) AS last_crash
FROM \`${CRASHLYTICS_TABLE}\`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY app_version
ORDER BY app_version DESC
"
}

# ── 命令分发 ──────────────────────────────────────────────────────────
case "${COMMAND}" in
  crashes)   cmd_crashes ;;
  hotspots)  cmd_hotspots ;;
  usage)     cmd_usage ;;
  versions)  cmd_versions ;;
  help|--help|-h) usage ;;
  *)
    echo "未知命令: ${COMMAND}"
    usage
    exit 1
    ;;
esac
