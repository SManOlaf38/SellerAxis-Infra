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

variable "alarm_metric_name" {
  description = "The alarm metric name."
  default     = ""
}

variable "sns_name" {
  description = "The sns name."
  default     = ""
}
