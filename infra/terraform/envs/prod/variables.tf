variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "bq_location" {
  type    = string
  default = "US"
}

variable "obs_dataset_id" {
  type    = string
  default = "obs"
}

variable "crashlytics_dataset" {
  type    = string
  default = "firebase_crashlytics"
}

variable "analytics_dataset" {
  type = string
}

variable "enable_export_dependent_resources" {
  type    = bool
  default = false
}

variable "table_ttl_days" {
  type    = number
  default = 90
}

variable "scheduled_query_service_account_email" {
  type    = string
  default = ""
}

variable "functions_runtime_service_account_email" {
  type    = string
  default = ""
}

variable "alert_email" {
  type    = string
  default = ""
}

variable "chat_notification_channel_ids" {
  type    = list(string)
  default = []
}

variable "fatal_event_threshold_count" {
  type    = number
  default = 3
}

variable "delete_account_error_threshold_count" {
  type    = number
  default = 3
}

variable "high_velocity_issue_threshold_count" {
  type    = number
  default = 8
}

variable "ai_pipeline_failure_threshold_count" {
  type    = number
  default = 1
}

variable "billing_account_id" {
  type    = string
  default = ""
}

variable "budget_amount" {
  type    = number
  default = 50
}

variable "budget_currency" {
  type    = string
  default = "USD"
}

variable "budget_cost_threshold" {
  type    = number
  default = 50
}

variable "enable_budget_metric_alert" {
  type    = bool
  default = false
}

variable "github_app_private_key_secret_name" {
  type    = string
  default = "GITHUB_APP_PRIVATE_KEY"
}

variable "github_app_private_key" {
  type      = string
  default   = ""
  sensitive = true
}
