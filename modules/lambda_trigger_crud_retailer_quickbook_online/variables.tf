variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "crud_retailer_sqs_name" {
  description = "The retailer SQS name."
  default     = ""
}

variable "trigger_crud_retailer_quickbook_online_name" {
  description = "The retailer forward handler name."
  default     = ""
}

variable "api_host" {
  description = "The api host."
  default     = ""
}

variable "lambda_secret" {
  description = "The lambda secret."
  default     = ""
}
