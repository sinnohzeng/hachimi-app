terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0"
    }
  }
}

provider "google" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
  billing_project       = var.project_id
}

module "observability" {
  source = "../../modules/observability"

  project_id = var.project_id
  region     = var.region

  bq_location                       = var.bq_location
  obs_dataset_id                    = var.obs_dataset_id
  crashlytics_dataset               = var.crashlytics_dataset
  analytics_dataset                 = var.analytics_dataset
  enable_export_dependent_resources = var.enable_export_dependent_resources
  table_ttl_days                    = var.table_ttl_days

  scheduled_query_service_account_email   = var.scheduled_query_service_account_email
  functions_runtime_service_account_email = var.functions_runtime_service_account_email

  alert_email                   = var.alert_email
  chat_notification_channel_ids = var.chat_notification_channel_ids

  fatal_event_threshold_count          = var.fatal_event_threshold_count
  delete_account_error_threshold_count = var.delete_account_error_threshold_count
  high_velocity_issue_threshold_count  = var.high_velocity_issue_threshold_count
  ai_pipeline_failure_threshold_count  = var.ai_pipeline_failure_threshold_count

  billing_account_id         = var.billing_account_id
  budget_amount              = var.budget_amount
  budget_currency            = var.budget_currency
  budget_cost_threshold      = var.budget_cost_threshold
  enable_budget_metric_alert = var.enable_budget_metric_alert

  github_app_private_key_secret_name = var.github_app_private_key_secret_name
  github_app_private_key             = var.github_app_private_key
}

output "obs_dataset_id" {
  value = module.observability.obs_dataset_id
}

output "notification_channel_ids" {
  value = module.observability.notification_channel_ids
}

output "alert_policy_ids" {
  value = module.observability.alert_policy_ids
}

output "budget_id" {
  value = module.observability.budget_id
}
