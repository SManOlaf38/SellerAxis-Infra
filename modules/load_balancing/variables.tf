variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "alb_name" {
  description = "The application load balancing name."
  default     = ""
  type        = string
}

variable "lb_target_group" {
  description = "The load balancing target group."
  default     = ""
  type        = string
}

variable "security_group_ids" {
  description = "The list of security group."
  default     = []
  type        = list
}

variable "subnet_ids" {
  description = "The list of subnet."
  default     = []
  type        = list
}

variable "vpc_id" {
  description = "The VPC id."
  default     = ""
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of ACM certificate."
  default     = ""
  type        = string
}