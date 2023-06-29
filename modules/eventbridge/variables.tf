variable "eventbridge_rule_name" {
  description = "The name of event rule."
  default     = ""
  type        = string
}

variable "schedule_expression" {
  description = "The schedule expression that determines when the rule is triggered."
  type        = string
}

variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of Lambda function."
  default     = ""
}

variable "lambda_function_name" {
  type        = string
  description = "The name of Lambda function."
  default     = ""
}
