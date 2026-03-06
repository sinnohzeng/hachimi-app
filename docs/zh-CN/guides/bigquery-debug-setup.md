# BigQuery 调试数据导出配置指南

> 将 Firebase Crashlytics 和 GA4 Analytics 数据导出到 BigQuery，实现 API 化查询辅助调试。

| 项目 | 说明 |
|------|------|
| **Status** | Active |
| **Scope** | Firebase → BigQuery 数据导出 + 查询模板 |
| **Evidence** | Firebase Console 配置、`scripts/bq-debug-queries.sh` |
| **Related** | `docs/release/google-play-setup.md`、`infra/terraform/modules/observability/` |

---

## 一、架构概览

```
┌─────────────────┐     ┌──────────────┐     ┌──────────────┐
│ Hachimi App     │────▶│ Firebase     │────▶│ BigQuery     │
│ (Crashlytics +  │     │ (Crashlytics │     │ (每日批量    │
│  Analytics)     │     │  + GA4)      │     │  自动导出)   │
└─────────────────┘     └──────────────┘     └──────────────┘
                                                    │
                                              ┌─────▼─────┐
                                              │ bq CLI /  │
                                              │ REST API  │
                                              │ (查询调试) │
                                              └───────────┘
```

**数据流**：应用产生的崩溃和事件数据 → Firebase 自动收集 → 每日批量导出到 BigQuery → 通过 `bq` CLI 或 API 查询。

---

## 二、前置条件

| 条件 | 验证方式 |
|------|----------|
| Firebase 项目 `hachimi-ai` 已启用 Crashlytics | Firebase Console → Crashlytics 页面有数据 |
| Firebase 项目已启用 GA4 Analytics | Firebase Console → Analytics 页面有数据 |
| GCP 项目已启用 BigQuery API | `gcloud services list --enabled --project=hachimi-ai \| grep bigquery` |
| `bq` CLI 已安装 | `bq version`（随 gcloud SDK 一起安装） |

---

## 三、Crashlytics → BigQuery 导出

### 3.1 在 Firebase Console 中配置

1. 打开 [Firebase Console](https://console.firebase.google.com) → 项目 **hachimi-ai**
2. 左侧导航 → **Crashlytics**
3. 页面右上角 **齿轮图标** → **BigQuery 链接**（或在 Project Settings → Integrations → BigQuery 中操作）
4. 勾选 **Export Crashlytics data to BigQuery**
5. 选择数据集位置（建议 `us` 或与主要用户群匹配的区域）
6. 点击 **Link**

### 3.2 可选：实时流式导出

- 在同一配置页面勾选 **Include streaming export**
- 优点：崩溃数据近实时可查（延迟约 1-2 分钟）
- 缺点：按流式写入计费，费用高于每日批量导出
- 建议：初期使用**每日批量**即可，需要实时调试时再开启

### 3.3 数据集结构

导出后 BigQuery 中会自动创建以下数据集和表：

```
hachimi-ai (project)
└── firebase_crashlytics (dataset)
    └── com_hachimi_hachimi_app (table, 按 event_timestamp 分区)
        ├── event_timestamp     TIMESTAMP   崩溃发生时间
        ├── event_id            STRING      崩溃事件 ID
        ├── platform            STRING      android / ios
        ├── bundle_identifier   STRING      com.hachimi.hachimi_app
        ├── app_version         STRING      2.27.0
        ├── os_version          STRING      Android 16
        ├── device_model        STRING      vivo V2405A
        ├── is_fatal            BOOLEAN     是否致命崩溃
        ├── issue_id            STRING      Crashlytics issue 分组 ID
        ├── issue_title         STRING      崩溃标题
        ├── blame_frame         RECORD      触发崩溃的堆栈帧
        │   ├── file            STRING
        │   ├── line            INT64
        │   └── symbol          STRING
        ├── exceptions          RECORD[]    异常堆栈列表
        └── custom_keys         RECORD[]    自定义键值对
```

---

## 四、GA4 Analytics → BigQuery 导出

### 4.1 在 Firebase Console 中配置

1. 打开 [Firebase Console](https://console.firebase.google.com) → 项目 **hachimi-ai**
2. 左下角 **齿轮图标** → **Project Settings**
3. 选择 **Integrations** 标签页
4. 找到 **BigQuery** 卡片 → 点击 **Link**
5. 勾选 **Google Analytics** 数据流
6. 确认数据集位置
7. 点击 **Link to BigQuery**

### 4.2 数据集结构

```
hachimi-ai (project)
└── analytics_522585423 (dataset)
    └── events_YYYYMMDD (table, 每日分区)
        ├── event_date          STRING      事件日期 YYYYMMDD
        ├── event_timestamp     INT64       事件时间（微秒）
        ├── event_name          STRING      事件名称
        ├── event_params        RECORD[]    事件参数键值对
        │   ├── key             STRING
        │   └── value           RECORD
        │       ├── string_value  STRING
        │       ├── int_value     INT64
        │       └── float_value   FLOAT64
        ├── user_properties     RECORD[]    用户属性
        ├── device              RECORD      设备信息
        │   ├── category        STRING
        │   ├── mobile_brand    STRING
        │   └── operating_system STRING
        ├── app_info            RECORD      应用信息
        │   └── version         STRING
        └── geo                 RECORD      地理位置
            ├── country         STRING
            └── city            STRING
```

### 4.3 费用说明

- **每日批量导出**：免费（Firebase Blaze 计划已包含）
- **BigQuery 存储**：前 10 GB/月免费
- **BigQuery 查询**：前 1 TB/月免费
- 对于 Hachimi 当前规模，基本不会产生额外费用

---

## 五、常用调试查询

### 5.1 查看最近崩溃（按版本）

```sql
SELECT
  event_timestamp,
  app_version,
  device_model,
  os_version,
  issue_title,
  blame_frame.file,
  blame_frame.line,
  blame_frame.symbol
FROM `hachimi-ai.firebase_crashlytics.com_hachimi_hachimi_app`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND app_version = '2.27.0'
ORDER BY event_timestamp DESC
LIMIT 50
```

### 5.2 崩溃热力图（按 issue 分组统计）

```sql
SELECT
  issue_id,
  issue_title,
  COUNT(*) AS crash_count,
  COUNT(DISTINCT device_model) AS affected_devices,
  MIN(event_timestamp) AS first_seen,
  MAX(event_timestamp) AS last_seen
FROM `hachimi-ai.firebase_crashlytics.com_hachimi_hachimi_app`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY issue_id, issue_title
ORDER BY crash_count DESC
LIMIT 20
```

### 5.3 崩溃前用户行为路径

```sql
SELECT
  event_name,
  TIMESTAMP_MICROS(event_timestamp) AS event_time,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'screen_name') AS screen,
  app_info.version AS app_version
FROM `hachimi-ai.analytics_522585423.events_*`
WHERE user_pseudo_id = 'TARGET_USER_ID'
  AND _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY event_timestamp
LIMIT 100
```

### 5.4 功能使用频率排行

```sql
SELECT
  event_name,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM `hachimi-ai.analytics_522585423.events_*`
WHERE _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
  AND event_name NOT IN ('session_start', 'first_visit', 'screen_view', 'user_engagement')
GROUP BY event_name
ORDER BY event_count DESC
LIMIT 30
```

### 5.5 版本对比（崩溃率趋势）

```sql
SELECT
  app_version,
  COUNT(*) AS total_crashes,
  COUNTIF(is_fatal) AS fatal_crashes,
  COUNT(DISTINCT device_model) AS affected_devices
FROM `hachimi-ai.firebase_crashlytics.com_hachimi_hachimi_app`
WHERE event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY app_version
ORDER BY app_version DESC
```

---

## 六、命令行快速查询

使用 `bq` CLI 直接查询：

```bash
# 查看最近 10 条崩溃
bq query --use_legacy_sql=false --max_rows=10 '
SELECT event_timestamp, app_version, issue_title, device_model
FROM `hachimi-ai.firebase_crashlytics.com_hachimi_hachimi_app`
ORDER BY event_timestamp DESC
LIMIT 10'
```

项目提供了封装脚本，更方便使用：

```bash
# 查看最近 7 天的崩溃
./scripts/bq-debug-queries.sh crashes --days 7

# 查看特定版本的崩溃
./scripts/bq-debug-queries.sh crashes --version 2.27.0

# 查看崩溃热力图
./scripts/bq-debug-queries.sh hotspots --days 30

# 查看功能使用排行
./scripts/bq-debug-queries.sh usage --days 7

# 版本崩溃率对比
./scripts/bq-debug-queries.sh versions
```

详见 `scripts/bq-debug-queries.sh --help`。

---

## 七、配置验证

配置完成后，运行以下命令验证数据集是否已创建：

```bash
# 列出 BigQuery 数据集
bq ls --project_id=hachimi-ai

# 验证 Crashlytics 数据集
bq ls hachimi-ai:firebase_crashlytics

# 验证 Analytics 数据集
bq ls hachimi-ai:analytics_522585423
```

> **注意**：首次导出需要 24-48 小时才能看到数据。配置当天查询可能为空，这是正常的。

---

## Changelog

| 日期 | 变更 |
|------|------|
| 2026-03-06 | 初版：Crashlytics + GA4 → BigQuery 导出配置指南 |
