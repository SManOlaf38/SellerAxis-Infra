variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "update_retailer_inventory_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_retailer_inventory_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

variable "update_individual_retailer_inventory_sqs_name" {
  description = "The update individual inventory queue name."
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