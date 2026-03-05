terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0"
    }
  }
}

locals {
  table_ttl_ms                  = floor(var.table_ttl_days * 24 * 60 * 60 * 1000)
  billing_account_id_normalized = replace(var.billing_account_id, "billingAccounts/", "")
  scheduled_query_service_account_email = var.enable_export_dependent_resources ? (
    var.scheduled_query_service_account_email != "" ? var.scheduled_query_service_account_email : google_service_account.scheduled_query[0].email
  ) : ""

  notification_channel_ids = compact(concat(
    var.chat_notification_channel_ids,
    var.alert_email == "" ? [] : [google_monitoring_notification_channel.email[0].name],
  ))
  budget_notification_channel_ids = var.alert_email == "" ? [] : [google_monitoring_notification_channel.email[0].name]

  ai_debug_refresh_query = templatefile("${path.module}/sql/refresh_ai_debug_tasks.sql.tftpl", {
    project_id          = var.project_id
    obs_dataset_id      = var.obs_dataset_id
    crashlytics_dataset = var.crashlytics_dataset
  })
}

resource "google_service_account" "scheduled_query" {
  count = var.enable_export_dependent_resources && var.scheduled_query_service_account_email == "" ? 1 : 0

  project      = var.project_id
  account_id   = "obs-scheduled-query"
  display_name = "Observability Scheduled Query"
}

resource "google_bigquery_dataset" "obs" {
  project                     = var.project_id
  dataset_id                  = var.obs_dataset_id
  location                    = var.bq_location
  default_table_expiration_ms = local.table_ttl_ms

  labels = {
    domain = "observability"
    app    = "hachimi"
    owner  = "platform"
  }
}

resource "google_bigquery_table" "ai_debug_tasks_v1" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "ai_debug_tasks_v1"
  deletion_protection = false
  schema              = file("${path.module}/schemas/ai_debug_tasks_v1.json")

  time_partitioning {
    type          = "DAY"
    field         = "event_date"
    expiration_ms = local.table_ttl_ms
  }

  clustering = ["issue_id", "feature", "error_code"]
}

resource "google_bigquery_table" "ai_debug_reports_v1" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "ai_debug_reports_v1"
  deletion_protection = false
  schema              = file("${path.module}/schemas/ai_debug_reports_v1.json")

  time_partitioning {
    type          = "DAY"
    field         = "created_at"
    expiration_ms = local.table_ttl_ms
  }

  clustering = ["issue_id", "model_name"]
}

resource "google_bigquery_table" "issue_daily_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "issue_daily_v1"
  deletion_protection = false

  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sql/issue_daily_v1.sql.tftpl", {
      project_id          = var.project_id
      crashlytics_dataset = var.crashlytics_dataset
    })
  }
}

resource "google_bigquery_table" "issue_velocity_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "issue_velocity_v1"
  deletion_protection = false

  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sql/issue_velocity_v1.sql.tftpl", {
      project_id          = var.project_id
      crashlytics_dataset = var.crashlytics_dataset
    })
  }
}

resource "google_bigquery_table" "issue_user_impact_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "issue_user_impact_v1"
  deletion_protection = false

  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sql/issue_user_impact_v1.sql.tftpl", {
      project_id          = var.project_id
      crashlytics_dataset = var.crashlytics_dataset
    })
  }
}

resource "google_bigquery_table" "flow_error_funnel_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "flow_error_funnel_v1"
  deletion_protection = false

  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sql/flow_error_funnel_v1.sql.tftpl", {
      project_id        = var.project_id
      analytics_dataset = var.analytics_dataset
    })
  }
}

resource "google_bigquery_table" "release_stability_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project             = var.project_id
  dataset_id          = google_bigquery_dataset.obs.dataset_id
  table_id            = "release_stability_v1"
  deletion_protection = false

  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sql/release_stability_v1.sql.tftpl", {
      project_id          = var.project_id
      crashlytics_dataset = var.crashlytics_dataset
    })
  }
}

resource "google_bigquery_data_transfer_config" "refresh_ai_debug_tasks_v1" {
  count = var.enable_export_dependent_resources ? 1 : 0

  project                = var.project_id
  location               = var.bq_location
  data_source_id         = "scheduled_query"
  display_name           = "hachimi_refresh_ai_debug_tasks_v1"
  destination_dataset_id = google_bigquery_dataset.obs.dataset_id
  schedule               = "every 15 minutes"

  service_account_name = local.scheduled_query_service_account_email

  params = {
    query = local.ai_debug_refresh_query
  }

  depends_on = [
    google_bigquery_table.ai_debug_tasks_v1,
  ]
}

resource "google_logging_project_sink" "observability_sink" {
  project                = var.project_id
  name                   = "hachimi-observability-sink"
  destination            = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.obs.dataset_id}"
  unique_writer_identity = true

  filter = join("\n", [
    "(resource.type=\"cloud_function\" OR resource.type=\"cloud_run_revision\")",
    "OR logName:\"firebasecrashlytics.googleapis.com\"",
  ])
}

resource "google_bigquery_dataset_iam_member" "observability_sink_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.obs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.observability_sink.writer_identity
}

resource "google_monitoring_notification_channel" "email" {
  count = var.alert_email == "" ? 0 : 1

  project      = var.project_id
  display_name = "hachimi-alerts-email"
  type         = "email"
  labels = {
    email_address = var.alert_email
  }
  enabled = true
}

resource "google_logging_metric" "crashlytics_fatal_events" {
  project     = var.project_id
  name        = "obs_crashlytics_fatal_events"
  description = "Fatal Crashlytics events routed through Cloud Logging"

  filter = join("\n", [
    "logName:\"firebasecrashlytics.googleapis.com\"",
    "severity>=ERROR",
  ])

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_logging_metric" "delete_account_errors" {
  project     = var.project_id
  name        = "obs_delete_account_errors"
  description = "deleteAccountV2 and wipeUserDataV2 failures"

  filter = join("\n", [
    "(resource.type=\"cloud_function\" OR resource.type=\"cloud_run_revision\")",
    "jsonPayload.function_name=~\"(deleteAccountV2|wipeUserDataV2)\"",
    "jsonPayload.result=\"failure\"",
  ])

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_logging_metric" "high_velocity_issues" {
  project     = var.project_id
  name        = "obs_high_velocity_issues"
  description = "High velocity issue detection events from triage pipeline"

  filter = join("\n", [
    "(resource.type=\"cloud_function\" OR resource.type=\"cloud_run_revision\")",
    "jsonPayload.function_name=\"runAiDebugTriageV2\"",
    "jsonPayload.tasks_total>=${var.high_velocity_issue_threshold_count}",
  ])

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_logging_metric" "ai_pipeline_failures" {
  project     = var.project_id
  name        = "obs_ai_pipeline_failures"
  description = "AI debug triage failures"

  filter = join("\n", [
    "(resource.type=\"cloud_function\" OR resource.type=\"cloud_run_revision\")",
    "jsonPayload.function_name=\"runAiDebugTriageV2\"",
    "jsonPayload.result=\"failure\"",
  ])

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_monitoring_alert_policy" "crash_free_users" {
  project      = var.project_id
  display_name = "crash_free_users"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "fatal events spike"

    condition_threshold {
      filter          = "resource.type=\"global\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.crashlytics_fatal_events.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.fatal_event_threshold_count
      duration        = "0s"

      aggregations {
        alignment_period     = "900s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "Crash free user ratio degraded. Check Crashlytics issue trends and release stability dashboard."
  }
}

resource "google_monitoring_alert_policy" "fatal_rate" {
  project      = var.project_id
  display_name = "fatal_rate"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "fatal rate threshold"

    condition_threshold {
      filter          = "resource.type=\"global\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.crashlytics_fatal_events.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.fatal_event_threshold_count
      duration        = "0s"

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "Fatal crash rate exceeded threshold. Investigate top impacted users and regressed issues."
  }
}

resource "google_monitoring_alert_policy" "delete_account_error_rate" {
  project      = var.project_id
  display_name = "delete_account_error_rate"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "delete account callable failures"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.delete_account_errors.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.delete_account_error_threshold_count
      duration        = "0s"

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "deleteAccountV2/wipeUserDataV2 failure rate is above threshold. Validate App Check token path and retry behavior."
  }
}

resource "google_monitoring_alert_policy" "high_velocity_issues" {
  project      = var.project_id
  display_name = "high_velocity_issues"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "high velocity issue detected"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.high_velocity_issues.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"

      aggregations {
        alignment_period     = "900s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "Triage pipeline detected high issue velocity. Prioritize regression analysis and mitigation."
  }
}

resource "google_monitoring_alert_policy" "ai_pipeline_failure" {
  project      = var.project_id
  display_name = "ai_pipeline_failure"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "AI triage pipeline failures"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.ai_pipeline_failures.name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.ai_pipeline_failure_threshold_count
      duration        = "0s"

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "AI triage pipeline reported failures. Check Vertex IAM, BigQuery writes, and GitHub App token exchange."
  }
}

resource "google_monitoring_alert_policy" "budget_threshold" {
  count = var.billing_account_id == "" || !var.enable_budget_metric_alert ? 0 : 1

  project      = var.project_id
  display_name = "budget_threshold"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "billing total cost threshold"

    condition_threshold {
      filter = join(" AND ", [
        "resource.type=\"global\"",
        "metric.type=\"billing.googleapis.com/billing/account/total_cost\"",
      ])
      comparison      = "COMPARISON_GT"
      threshold_value = var.budget_cost_threshold
      duration        = "0s"

      aggregations {
        alignment_period     = "3600s"
        per_series_aligner   = "ALIGN_MAX"
        cross_series_reducer = "REDUCE_MAX"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = local.notification_channel_ids

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    mime_type = "text/markdown"
    content   = "Billing spend exceeded threshold. Review BigQuery query cost, log retention, and model invocation volume."
  }
}

resource "google_billing_budget" "obs_budget" {
  count = var.billing_account_id == "" ? 0 : 1

  billing_account = local.billing_account_id_normalized
  display_name    = "hachimi-observability-budget"

  amount {
    specified_amount {
      currency_code = var.budget_currency
      units         = tostring(var.budget_amount)
    }
  }

  threshold_rules {
    threshold_percent = 0.50
  }

  threshold_rules {
    threshold_percent = 0.80
  }

  threshold_rules {
    threshold_percent = 1.00
  }

  all_updates_rule {
    monitoring_notification_channels = local.budget_notification_channel_ids
    disable_default_iam_recipients   = false
  }
}

resource "google_secret_manager_secret" "github_app_private_key" {
  project   = var.project_id
  secret_id = var.github_app_private_key_secret_name

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_app_private_key" {
  count = var.github_app_private_key == "" ? 0 : 1

  secret      = google_secret_manager_secret.github_app_private_key.id
  secret_data = var.github_app_private_key
}

resource "google_secret_manager_secret_iam_member" "functions_secret_accessor" {
  count = var.functions_runtime_service_account_email == "" ? 0 : 1

  project   = var.project_id
  secret_id = google_secret_manager_secret.github_app_private_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.functions_runtime_service_account_email}"
}

resource "google_bigquery_dataset_iam_member" "functions_obs_editor" {
  count = var.functions_runtime_service_account_email == "" ? 0 : 1

  project    = var.project_id
  dataset_id = google_bigquery_dataset.obs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${var.functions_runtime_service_account_email}"
}

resource "google_project_iam_member" "functions_bq_job_user" {
  count = var.functions_runtime_service_account_email == "" ? 0 : 1

  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.functions_runtime_service_account_email}"
}

resource "google_project_iam_member" "functions_aiplatform_user" {
  count = var.functions_runtime_service_account_email == "" ? 0 : 1

  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${var.functions_runtime_service_account_email}"
}

resource "google_bigquery_dataset_iam_member" "scheduled_query_editor" {
  count = local.scheduled_query_service_account_email == "" ? 0 : 1

  project    = var.project_id
  dataset_id = google_bigquery_dataset.obs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${local.scheduled_query_service_account_email}"
}

resource "google_project_iam_member" "scheduled_query_job_user" {
  count = local.scheduled_query_service_account_email == "" ? 0 : 1

  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${local.scheduled_query_service_account_email}"
}
