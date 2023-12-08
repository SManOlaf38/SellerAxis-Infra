variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "get_new_order_handle_name" {
	description = "The acknowledge forward handler name."
  default     = ""
}

variable "get_new_order_name" {
	description = "The acknowledge retailer getting order name."
  default     = ""
}

variable "trigger_get_new_order_name" {
	description = "The acknowledge trigger retailer getting order name."
  default     = ""
}

variable "api_host" {
  description = "The acknowledge api host."
  default     = ""
}

variable "lambda_secret" {
	description = "The acknowledge lambda secret."
  default     = ""
}

variable "retailer_getting_order_sqs_name" {
  description = "The name of sqs"
  default     = ""
}
