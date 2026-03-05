variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "region" {
  description = "Default region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "bq_location" {
  description = "BigQuery location (e.g., US, asia-northeast1)"
  type        = string
  default     = "US"
}

variable "obs_dataset_id" {
  description = "BigQuery dataset id for observability objects"
  type        = string
  default     = "obs"
}

variable "crashlytics_dataset" {
  description = "Crashlytics export dataset id"
  type        = string
  default     = "firebase_crashlytics"
}

variable "analytics_dataset" {
  description = "Firebase Analytics export dataset id (analytics_<property_id>)"
  type        = string
}

variable "enable_export_dependent_resources" {
  description = "Whether to create resources that depend on Crashlytics/Analytics BigQuery exports"
  type        = bool
  default     = false
}

variable "table_ttl_days" {
  description = "Default table TTL in days"
  type        = number
  default     = 90
}

variable "scheduled_query_service_account_email" {
  description = "Optional service account for scheduled queries"
  type        = string
  default     = ""
}

variable "functions_runtime_service_account_email" {
  description = "Functions runtime service account email"
  type        = string
  default     = ""
}

variable "alert_email" {
  description = "Email fallback notification channel"
  type        = string
  default     = ""
}

variable "chat_notification_channel_ids" {
  description = "Existing Google Chat Monitoring notification channel resource names"
  type        = list(string)
  default     = []
}

variable "fatal_event_threshold_count" {
  description = "Fatal crash event threshold per alignment window"
  type        = number
  default     = 3
}

variable "delete_account_error_threshold_count" {
  description = "Delete account error threshold per alignment window"
  type        = number
  default     = 3
}

variable "high_velocity_issue_threshold_count" {
  description = "High velocity issue threshold per alignment window"
  type        = number
  default     = 8
}

variable "ai_pipeline_failure_threshold_count" {
  description = "AI pipeline failure threshold per alignment window"
  type        = number
  default     = 1
}

variable "budget_cost_threshold" {
  description = "Budget threshold alert value in billing currency"
  type        = number
  default     = 50
}

variable "enable_budget_metric_alert" {
  description = "Whether to create Monitoring metric alert for billing cost threshold"
  type        = bool
  default     = false
}

variable "billing_account_id" {
  description = "Billing account id in form billingAccounts/XXXX-XXXX-XXXX"
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "Monthly budget amount"
  type        = number
  default     = 50
}

variable "budget_currency" {
  description = "Billing budget currency code"
  type        = string
  default     = "USD"
}

variable "github_app_private_key_secret_name" {
  description = "Secret Manager secret id for GitHub App private key"
  type        = string
  default     = "GITHUB_APP_PRIVATE_KEY"
}

variable "github_app_private_key" {
  description = "Optional initial value for GitHub App private key"
  type        = string
  default     = ""
  sensitive   = true
}
