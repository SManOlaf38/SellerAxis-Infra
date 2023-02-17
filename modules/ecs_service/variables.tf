variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "ecs_service_private_namespace_name" {
  description = "The service private namespace name."
  default     = ""
  type        = string
}

variable "ecs_service_private_namespace_description" {
  description = "The service private namespace description."
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "The VPC id"
  default     = ""
  type        = string
}

variable "ecs_service_name" {
  description = "The service name"
  default     = ""
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ECS cluster id"
  default     = ""
  type        = string
}

variable "iam_role_arn" {
  description = "The ECS task definition ARN"
  default     = ""
  type        = string
}

variable "repository_url" {
  description = "The ECR Repository URL"
  default     = ""
  type        = string
}

variable "aws_ecs_task_definition" {
  description = "The ECS task definition"
  default     = ""
  type        = string
}

variable "container_name" {
  description = "The ECS service container name"
  default     = ""
  type        = string
}

variable "aws_lb_target_group_arn" {
  description = "The ALB Target group ARN"
  default     = ""
  type        = string
}

variable "container_port" {
  description = "The ECS service container port"
  default     = ""
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet."
  default     = []
  type        = list
}

variable "security_group_ids" {
  description = "The list of security group."
  default     = []
  type        = list
}

variable "aws_region" {
  description = "The region aws"
  default     = ""
}

variable "cloudwatch_log_group_name" {
  description = "Name of CloudWatch Log group."
  default     = ""
  type        = string
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name."
  default     = ""
  type        = string
}

variable "task_family_name" {
  description = "The ECS task definition family name."
  default     = ""
  type        = string
}
