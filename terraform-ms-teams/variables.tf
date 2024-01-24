variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "teams_webhook" {
  type        = string
  description = "teams webhook"
  default = " https://telerikacademy.webhook.office.com/webhookb2/6418911f-f4e8-4ba3-8871-104978e0ecda@b1720f58-a86a-437a-b829-7a6e544e48ac/IncomingWebhook/054d8dbf67ec4259a6dadfa0851dd5a1/812ca9b3-7cfc-4d41-9792-6b14f88cbee4"
}

variable "teams_timeout" {
  type        = string
  description = "timeout for teams lambda function"
  default     = "30"
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key for encrypting environment variables of the Lambda function. Defaults to `null` which uses the AWS-managed key aws/lambda."
  default     = null
}

variable "api_access_log_retention" {
  type        = number
  description = "Number of days to retain access logs from API."
  default     = 30
}

variable "api_execution_log_retention" {
  type        = number
  description = "Number of days to retain execution logs from API."
  default     = 30
}

variable "api_execution_log_level" {
  type        = string
  description = "Specifies the logging level for this method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are `OFF`, `ERROR`, and `INFO`. Defaults to `ERROR`."
  default     = "ERROR"
}

variable "logs_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

# variable "ms_teams_server_ips" {
#   type        = list(string)
#   description = "List of source IPs of MS Teams. Used to restrict traffic to the API"
# }