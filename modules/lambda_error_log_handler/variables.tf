variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "aws_region" {
  description = "The region aws"
  default     = ""
}

variable "lambda_name" {
  description = "The product forward handler name."
  default     = ""
}

variable "slack_webhook_host" {
  description = "The api host."
  default     = ""
}

variable "cloudwatch_log_arn" {
  description = "CloudWatch Log arn."
  default     = ""
}

variable "cloudwatch_log_name" {
  description = "CloudWatch Log name."
  default     = ""
}
