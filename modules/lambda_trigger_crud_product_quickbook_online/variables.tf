variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "crud_product_sqs_name" {
  description = "The product SQS name."
  default     = ""
}

variable "trigger_crud_product_quickbook_online_name" {
  description = "The product forward handler name."
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
