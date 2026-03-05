project_id  = "hachimi-ai"
region      = "us-central1"
bq_location = "US"

obs_dataset_id                    = "obs"
crashlytics_dataset               = "firebase_crashlytics"
analytics_dataset                 = "analytics_123456789"
enable_export_dependent_resources = false
table_ttl_days                    = 90

scheduled_query_service_account_email   = ""
functions_runtime_service_account_email = ""

alert_email = "sinnoh@carissie.com"
chat_notification_channel_ids = [
  "projects/hachimi-ai/notificationChannels/7564813615993522229", # hachimi-alerts-prod-p1
  "projects/hachimi-ai/notificationChannels/7202234633594020254"  # hachimi-alerts-prod-ops
]

fatal_event_threshold_count          = 5
delete_account_error_threshold_count = 3
high_velocity_issue_threshold_count  = 10
ai_pipeline_failure_threshold_count  = 1

billing_account_id         = "billingAccounts/01E301-C31477-88FDAB"
budget_amount              = 150
budget_currency            = "USD"
budget_cost_threshold      = 120
enable_budget_metric_alert = false

github_app_private_key_secret_name = "GITHUB_APP_PRIVATE_KEY"
github_app_private_key             = ""
