variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "Name of CloudWatch Log group."
  default     = ""
}
