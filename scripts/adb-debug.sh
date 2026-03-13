#!/usr/bin/env bash
# ============================================================================
# Hachimi — ADB 设备调试脚本
#
# 用途：快速读取 Android 真机日志、错误、崩溃信息，支持 Claude Code 调试闭环
# 前提：Android 设备通过 USB 连接并已启用开发者模式
#
# 使用方法：
#   ./scripts/adb-debug.sh <command> [options]
#
# 命令：
#   status       设备连接状态 + App 运行状态
#   logs         日志快照（默认最近 500 行，仅 Flutter 相关）
#   errors       仅错误/异常（E/F 级别 + 关键词过滤）
#   crash        最近一次崩溃的完整堆栈
#   clear        清空 logcat 缓冲区
#   start-bg     启动后台日志收集
#   stop-bg      停止后台日志收集
#   install      安装 debug APK 到设备
#   screenshot   截取设备屏幕
#   help         显示帮助信息
# ============================================================================

set -euo pipefail

# ── 配置 ──────────────────────────────────────────────────────────────
ADB="/opt/homebrew/share/android-commandlinetools/platform-tools/adb"
PACKAGE="com.hachimi.hachimi_app"
LOG_FILE="/tmp/hachimi-logcat.log"
PID_FILE="/tmp/hachimi-logcat.pid"
SCREENSHOT_DIR="/tmp"
APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
MAX_LOG_SIZE=$((5 * 1024 * 1024))  # 5MB
# ────────────────────────────────────────────────────────────────────────

# 默认参数
LINES=500
LEVEL="V"
TAG=""
SINCE=""

usage() {
  cat <<'HELP'
Hachimi ADB 设备调试工具

用法：
  ./scripts/adb-debug.sh <command> [options]

命令：
  status       设备连接状态 + App 运行状态
  logs         日志快照（默认最近 500 行，仅 Flutter 相关）
  errors       仅错误/异常（E/F 级别 + 关键词过滤）
  crash        最近一次崩溃的完整堆栈
  clear        清空 logcat 缓冲区（测试前重置）
  start-bg     启动后台日志收集（写入 /tmp/hachimi-logcat.log）
  stop-bg      停止后台日志收集
  install      安装 debug APK 到设备
  screenshot   截取设备屏幕到 /tmp/
  help         显示此帮助信息

选项：
  --lines N    返回日志行数（默认：500）
  --level X    最低日志级别：V/D/I/W/E/F（默认：V）
  --tag TAG    按标签过滤（如 FocusTimer、DiaryService）
  --since T    起始时间过滤（格式："MM-DD HH:MM:SS"）

示例：
  ./scripts/adb-debug.sh status
  ./scripts/adb-debug.sh logs --lines 100 --level W
  ./scripts/adb-debug.sh errors
  ./scripts/adb-debug.sh errors --since "03-13 14:30:00"
  ./scripts/adb-debug.sh logs --tag FocusTimer
  ./scripts/adb-debug.sh crash
  ./scripts/adb-debug.sh clear && ./scripts/adb-debug.sh errors
HELP
}

# ── 参数解析 ──────────────────────────────────────────────────────────
COMMAND="${1:-help}"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lines)
      LINES="$2"
      shift 2
      ;;
    --level)
      LEVEL="$2"
      shift 2
      ;;
    --tag)
      TAG="$2"
      shift 2
      ;;
    --since)
      SINCE="$2"
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
check_adb() {
  if [[ ! -x "${ADB}" ]]; then
    echo "错误: 未找到 adb，路径: ${ADB}"
    echo "请确认 Android SDK 已安装: brew install --cask android-commandlinetools"
    exit 1
  fi
}

check_device() {
  check_adb
  local devices
  devices=$("${ADB}" devices 2>/dev/null | grep -v "^List" | grep -v "^$" || true)
  if [[ -z "${devices}" ]]; then
    echo "错误: 没有检测到已连接的 Android 设备"
    echo "请检查: USB 连接、开发者模式、USB 调试已开启"
    exit 1
  fi
}

# 获取 App 进程 PID（App 未运行时返回空字符串）
get_app_pid() {
  "${ADB}" shell pidof "${PACKAGE}" 2>/dev/null | tr -d '[:space:]' || echo ""
}

# 输出日志头信息
print_header() {
  local label="$1"
  local model
  model=$("${ADB}" shell getprop ro.product.model 2>/dev/null | tr -d '[:space:]')
  echo "=== Hachimi ${label} ($(date '+%Y-%m-%d %H:%M:%S')) | 设备: ${model} ==="
}

# 检查并清理过大的日志文件
check_log_size() {
  if [[ -f "${LOG_FILE}" ]]; then
    local size
    size=$(stat -f%z "${LOG_FILE}" 2>/dev/null || echo "0")
    if [[ "${size}" -gt "${MAX_LOG_SIZE}" ]]; then
      truncate -s 0 "${LOG_FILE}"
      echo "[日志文件已清空：超过 5MB 上限]"
    fi
  fi
}

# ── 命令函数 ──────────────────────────────────────────────────────────

cmd_status() {
  check_adb
  echo "▶ 设备状态检查..."
  echo ""

  # 设备连接
  local devices
  devices=$("${ADB}" devices 2>/dev/null | grep -v "^List" | grep -v "^$" || true)
  if [[ -z "${devices}" ]]; then
    echo "设备: ❌ 未连接"
    return 0
  fi

  local model os_version
  model=$("${ADB}" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
  os_version=$("${ADB}" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
  echo "设备: ✅ ${model} (Android ${os_version})"

  # App 运行状态
  local pid
  pid=$(get_app_pid)
  if [[ -n "${pid}" ]]; then
    echo "App:  ✅ 运行中 (PID: ${pid})"
  else
    echo "App:  ⚪ 未运行"
  fi

  # 后台日志收集状态
  if [[ -f "${PID_FILE}" ]] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
    local log_size
    log_size=$(stat -f%z "${LOG_FILE}" 2>/dev/null || echo "0")
    echo "日志: ✅ 后台收集中 (${LOG_FILE}, $(( log_size / 1024 ))KB)"
  else
    echo "日志: ⚪ 未启动后台收集"
  fi
}

cmd_logs() {
  check_device
  print_header "Logcat 快照"

  local pid
  pid=$(get_app_pid)

  # 构建 logcat 参数
  local -a logcat_args=("-d")  # dump 模式（非持续流）

  if [[ -n "${SINCE}" ]]; then
    logcat_args+=("-T" "${SINCE}")
  fi

  if [[ -n "${pid}" ]]; then
    # App 运行中：按 PID 过滤（最精确）
    logcat_args+=("--pid=${pid}" "*:${LEVEL}")
  else
    # App 未运行：按标签过滤（捕获启动崩溃）
    logcat_args+=("-s" "flutter:${LEVEL}" "AndroidRuntime:*" "ActivityManager:*" "DEBUG:*")
  fi

  local output
  output=$("${ADB}" logcat "${logcat_args[@]}" 2>/dev/null || true)

  # 按标签二次过滤
  if [[ -n "${TAG}" ]]; then
    output=$(echo "${output}" | grep -i "${TAG}" || true)
  fi

  # 输出最后 N 行
  if [[ -n "${output}" ]]; then
    echo "${output}" | tail -n "${LINES}"
  else
    echo "(无日志)"
  fi
}

cmd_errors() {
  check_device
  print_header "错误日志"

  local pid
  pid=$(get_app_pid)

  # 获取原始日志
  local -a logcat_args=("-d")

  if [[ -n "${SINCE}" ]]; then
    logcat_args+=("-T" "${SINCE}")
  fi

  if [[ -n "${pid}" ]]; then
    logcat_args+=("--pid=${pid}" "*:W")  # Warning 及以上
  else
    logcat_args+=("-s" "flutter:W" "AndroidRuntime:*" "DEBUG:*")
  fi

  local raw
  raw=$("${ADB}" logcat "${logcat_args[@]}" 2>/dev/null || true)

  # 关键词过滤：错误、异常、崩溃、App 自定义错误格式
  local filtered
  filtered=$(echo "${raw}" | grep -iE \
    "E/flutter|F/|Exception|Error|FATAL|failed:|crash|ANR|at .*\(.*\.dart:" \
    2>/dev/null || true)

  # 按标签二次过滤
  if [[ -n "${TAG}" ]]; then
    filtered=$(echo "${filtered}" | grep -i "${TAG}" || true)
  fi

  if [[ -n "${filtered}" ]]; then
    echo "${filtered}" | tail -n "${LINES}"
    echo ""
    local count
    count=$(echo "${filtered}" | wc -l | tr -d ' ')
    echo "--- 共 ${count} 条错误/警告 ---"
  else
    echo "✅ 没有发现错误"
  fi
}

cmd_crash() {
  check_device
  print_header "崩溃堆栈"

  # 搜索 AndroidRuntime FATAL 异常和 Flutter 崩溃
  local raw
  raw=$("${ADB}" logcat -d -s "AndroidRuntime:E" "flutter:E" "DEBUG:*" 2>/dev/null || true)

  # 提取最后一个 FATAL EXCEPTION 块
  local crash_block
  crash_block=$(echo "${raw}" | \
    awk '/FATAL EXCEPTION|FATAL:/{found=1} found{print}' | \
    tail -n 100 || true)

  if [[ -z "${crash_block}" ]]; then
    # 尝试提取 Flutter 框架错误
    crash_block=$(echo "${raw}" | \
      awk '/══╡ EXCEPTION CAUGHT/{found=1} found{print} /══════════════════/{if(found) exit}' | \
      tail -n 100 || true)
  fi

  if [[ -n "${crash_block}" ]]; then
    echo "${crash_block}"
  else
    echo "✅ 没有发现崩溃记录"
  fi
}

cmd_clear() {
  check_device
  "${ADB}" logcat -c
  echo "✅ Logcat 缓冲区已清空"
}

cmd_start_bg() {
  check_device

  # 检查是否已在运行
  if [[ -f "${PID_FILE}" ]] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
    echo "后台日志收集已在运行中 (PID: $(cat "${PID_FILE}"))"
    return 0
  fi

  check_log_size

  local pid
  pid=$(get_app_pid)

  local -a logcat_args=()
  if [[ -n "${pid}" ]]; then
    logcat_args+=("--pid=${pid}")
  fi
  logcat_args+=("*:V")

  # 启动后台进程
  "${ADB}" logcat "${logcat_args[@]}" > "${LOG_FILE}" 2>&1 &
  local bg_pid=$!
  echo "${bg_pid}" > "${PID_FILE}"

  echo "✅ 后台日志收集已启动"
  echo "   PID: ${bg_pid}"
  echo "   日志文件: ${LOG_FILE}"
  echo "   读取方式: tail -n 100 ${LOG_FILE}"
}

cmd_stop_bg() {
  if [[ -f "${PID_FILE}" ]]; then
    local pid
    pid=$(cat "${PID_FILE}")
    if kill -0 "${pid}" 2>/dev/null; then
      kill "${pid}" 2>/dev/null || true
      echo "✅ 后台日志收集已停止 (PID: ${pid})"
    else
      echo "后台进程已不存在"
    fi
    rm -f "${PID_FILE}"
  else
    echo "没有运行中的后台日志收集"
  fi
}

cmd_install() {
  check_device

  if [[ ! -f "${APK_PATH}" ]]; then
    echo "错误: 未找到 APK 文件: ${APK_PATH}"
    echo "请先运行: flutter build apk --debug"
    exit 1
  fi

  echo "▶ 正在安装 debug APK..."
  # vivo 设备兼容性参数
  "${ADB}" shell settings put global package_verifier_enable 0 2>/dev/null || true
  "${ADB}" install -r -t -d "${APK_PATH}"
  echo "✅ 安装完成"
}

cmd_screenshot() {
  check_device

  local filename="hachimi-screenshot-$(date '+%Y%m%d-%H%M%S').png"
  local device_path="/sdcard/${filename}"
  local local_path="${SCREENSHOT_DIR}/${filename}"

  "${ADB}" shell screencap -p "${device_path}"
  "${ADB}" pull "${device_path}" "${local_path}" >/dev/null
  "${ADB}" shell rm "${device_path}"

  echo "✅ 截图已保存: ${local_path}"
}

# ── 命令分发 ──────────────────────────────────────────────────────────
case "${COMMAND}" in
  status)      cmd_status ;;
  logs)        cmd_logs ;;
  errors)      cmd_errors ;;
  crash)       cmd_crash ;;
  clear)       cmd_clear ;;
  start-bg)    cmd_start_bg ;;
  stop-bg)     cmd_stop_bg ;;
  install)     cmd_install ;;
  screenshot)  cmd_screenshot ;;
  help|--help|-h) usage ;;
  *)
    echo "未知命令: ${COMMAND}"
    usage
    exit 1
    ;;
esac
