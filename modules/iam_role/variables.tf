variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "iam_role_name" {
  description = "The role name."
  default     = ""
  type        = string
}

variable "aws_iam_instance_profile_name" {
  description = "The aws iam instance profile name"
  default     = ""
  type        = string
}

variable "aws_iam_role_policy_name" {
  description = "The aws iam role policy name"
  default     = ""
  type        = string
}
