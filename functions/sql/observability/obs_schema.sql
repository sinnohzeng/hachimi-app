-- Hachimi observability schema (BigQuery Standard SQL)
-- Target dataset: obs

CREATE TABLE IF NOT EXISTS `obs.ai_debug_tasks_v1` (
  issue_id STRING NOT NULL,
  feature STRING NOT NULL,
  error_code STRING NOT NULL,
  velocity_24h INT64 NOT NULL,
  impacted_users INT64 NOT NULL,
  sample_error STRING,
  sample_stack STRING,
  first_seen TIMESTAMP,
  event_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY event_date
CLUSTER BY issue_id, feature, error_code;

CREATE TABLE IF NOT EXISTS `obs.ai_debug_reports_v1` (
  issue_id STRING NOT NULL,
  root_cause_hypothesis STRING NOT NULL,
  repro_steps STRING NOT NULL,
  affected_scope STRING NOT NULL,
  fix_suggestion STRING NOT NULL,
  model_name STRING NOT NULL,
  prompt_version STRING NOT NULL,
  decision_trace_id STRING NOT NULL,
  github_issue_url STRING,
  created_at TIMESTAMP NOT NULL
)
PARTITION BY DATE(created_at)
CLUSTER BY issue_id, model_name;

CREATE OR REPLACE VIEW `obs.issue_daily_v1` AS
SELECT
  DATE(event_timestamp) AS event_date,
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'feature' LIMIT 1),
    'unknown'
  ) AS feature,
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'error_code' LIMIT 1),
    'unknown_error'
  ) AS error_code,
  COUNT(*) AS issue_count,
  COUNT(DISTINCT (
    SELECT value FROM UNNEST(custom_keys) WHERE key = 'uid_hash' LIMIT 1
  )) AS impacted_users
FROM `firebase_crashlytics.*`
WHERE REGEXP_CONTAINS(_TABLE_SUFFIX, r'_(ANDROID|IOS)(?:_REALTIME)?$')
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY event_date, feature, error_code;

CREATE OR REPLACE VIEW `obs.issue_velocity_v1` AS
SELECT
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'feature' LIMIT 1),
    'unknown'
  ) AS feature,
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'error_code' LIMIT 1),
    'unknown_error'
  ) AS error_code,
  COUNTIF(event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)) AS velocity_24h,
  COUNTIF(event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 2 HOUR)) AS velocity_2h
FROM `firebase_crashlytics.*`
WHERE REGEXP_CONTAINS(_TABLE_SUFFIX, r'_(ANDROID|IOS)(?:_REALTIME)?$')
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY feature, error_code;

CREATE OR REPLACE VIEW `obs.issue_user_impact_v1` AS
SELECT
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'feature' LIMIT 1),
    'unknown'
  ) AS feature,
  IFNULL(
    (SELECT value FROM UNNEST(custom_keys) WHERE key = 'error_code' LIMIT 1),
    'unknown_error'
  ) AS error_code,
  COUNT(DISTINCT (
    SELECT value FROM UNNEST(custom_keys) WHERE key = 'uid_hash' LIMIT 1
  )) AS impacted_users_7d
FROM `firebase_crashlytics.*`
WHERE REGEXP_CONTAINS(_TABLE_SUFFIX, r'_(ANDROID|IOS)(?:_REALTIME)?$')
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY feature, error_code;

CREATE OR REPLACE VIEW `obs.flow_error_funnel_v1` AS
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  event_name,
  IFNULL(
    (
      SELECT
        COALESCE(
          ep.value.string_value,
          CAST(ep.value.int_value AS STRING),
          CAST(ep.value.double_value AS STRING)
        )
      FROM UNNEST(event_params) ep
      WHERE ep.key = 'feature'
      LIMIT 1
    ),
    'unknown'
  ) AS feature,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_pseudo_id) AS distinct_users
FROM `__ANALYTICS_DATASET__.events_*`
WHERE event_name IN ('app_opened', 'sign_up', 'app_error', 'account_deletion_failed')
  AND _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
GROUP BY event_date, event_name, feature;

CREATE OR REPLACE VIEW `obs.release_stability_v1` AS
SELECT
  DATE(event_timestamp) AS event_date,
  IFNULL(application.display_version, 'unknown') AS app_version,
  COUNT(*) AS crash_events,
  COUNT(DISTINCT (
    SELECT value FROM UNNEST(custom_keys) WHERE key = 'uid_hash' LIMIT 1
  )) AS impacted_users
FROM `firebase_crashlytics.*`
WHERE REGEXP_CONTAINS(_TABLE_SUFFIX, r'_(ANDROID|IOS)(?:_REALTIME)?$')
  AND event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
GROUP BY event_date, app_version;
