output "obs_dataset_id" {
  description = "Observability BigQuery dataset id"
  value       = google_bigquery_dataset.obs.dataset_id
}

output "notification_channel_ids" {
  description = "Notification channel resource names used by alert policies"
  value       = local.notification_channel_ids
}

output "alert_policy_ids" {
  description = "Alert policy resource ids"
  value = {
    crash_free_users          = google_monitoring_alert_policy.crash_free_users.id
    fatal_rate                = google_monitoring_alert_policy.fatal_rate.id
    delete_account_error_rate = google_monitoring_alert_policy.delete_account_error_rate.id
    high_velocity_issues      = google_monitoring_alert_policy.high_velocity_issues.id
    ai_pipeline_failure       = google_monitoring_alert_policy.ai_pipeline_failure.id
    budget_threshold          = var.billing_account_id == "" || !var.enable_budget_metric_alert ? null : google_monitoring_alert_policy.budget_threshold[0].id
  }
}

output "budget_id" {
  description = "Billing budget id"
  value       = var.billing_account_id == "" ? null : google_billing_budget.obs_budget[0].id
}

output "github_app_private_key_secret_id" {
  description = "Secret Manager id for GitHub App private key"
  value       = google_secret_manager_secret.github_app_private_key.id
}

output "logging_sink_writer_identity" {
  description = "Service account identity used by logging sink"
  value       = google_logging_project_sink.observability_sink.writer_identity
}
