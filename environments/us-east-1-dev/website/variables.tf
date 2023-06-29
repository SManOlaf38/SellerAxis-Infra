variable "aws_region" {
  description = "The region aws"
  default     = ""
}

variable "aws_access_key" {
  description = "The aws access key"
  default     = ""
}

variable "aws_secret_key" {
  description = "The aws secret key"
  default     = ""
}

variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

# ECS
variable "ecs_cluster_name" {
  description = "The ECS cluster name."
  default     = ""
}
# End ECS

# VPC
variable "vpc_name" {
  description = "The VPC name."
  default     = ""
}

variable "vpc_cidr_block" {
  description = "Main VPC CIDR Block."
  default     = ""
}

variable "availability_zones" {
  description = "AWS Region Availability Zones."
  default     = ""
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR Block."
  default     = ""
}
# End VPC

# ECR
variable "ecr_name" {
  type = string
  description = " Name of the repository."
  default     = ""
}

variable "mutability" {
  type = string
  description = "The tag mutability setting for the repository."
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  default     = false
}
# End ECR

# AWS IAM ROLE
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
# End AWS IAM ROLE

# AWS Security group
variable "security_group_name" {
  type = string
  description = "The name security group."
  default     = ""
}

variable "security_group_description" {
  type = string
  description = "The description for security group"
  default     = ""
}

variable "security_group_http_cidr_blocks" {
  type = list
  description = "The list of CIDR blocks for http"
  default     = []
}

variable "security_group_http_ipv6_cidr_blocks" {
  type = list
  description = "The list of CIDR blocks for http"
  default     = []
}

variable "security_group_https_cidr_blocks" {
  type = list
  description = "The list of CIDR blocks for https"
  default     = []
}

variable "security_group_https_ipv6_cidr_blocks" {
  type = list
  description = "The list of CIDR blocks for https"
  default     = []
}

variable "security_group_ssh_cidr_blocks" {
  type = list
  description = "The list of CIDR blocks for ssh"
  default     = []
}
# End AWS Security group

# AWS Load balancing
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
# End AWS Load balancing

# ACM Certificate
variable "domain_name" {
  type = string
  description = "The domain name."
  default     = ""
}

variable "validation_method" {
  type = string
  description = "The validate method for certification."
  default     = ""
}

variable "create_before_destroy" {
  description = "Create certification before destroy."
  default     = true
}
# End ACM Certificate

# CloudWatch Log
variable "cloudwatch_log_group_name" {
  description = "Name of CloudWatch Log group."
  default     = ""
  type        = string
}
# End CloudWatch Log

# ECS Service
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

variable "container_name" {
  description = "The ECS service container name"
  default     = ""
  type        = string
}

variable "container_port" {
  description = "The ECS service container port"
  default     = ""
  type        = string
}

variable "task_family_name" {
  description = "The ECS task definition family name."
  default     = ""
  type        = string
}

variable "ecs_task_role_name" {
  description = "The ECS task definition role name."
  default     = ""
  type        = string
}


variable "ecs_task_policy_name" {
  description = "The ECS task definition policy name."
  default     = ""
  type        = string
}

# End ECS Service

# S3
variable "photo_video_bucket_name" {
  description = "The bucket name."
  default     = ""
}

variable "photo_video_bucket_acl" {
  description = "the access control list for bucket"
  default     = ""
}
# End S3

# SQS
variable "acknowledge_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}
# End SQS

# Lambda
variable "acknowledge_forward_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

variable "lambda_secret" {
  description = "The lambda secret."
  default     = ""
}
# End Lambda

# Lambda Update Inventory
variable "update_inventory_handler_name" {
  description = "The update inventory handler name."
  default     = ""
}
# End Lambda Update Inventory

# Eventbridge
variable "eventbridge_rule_name" {
  description = "The eventbridge rule name."
  default     = ""
  type        = string
}

variable "schedule_expression" {
  description = "The schedule expression."
  default     = ""
  type        = string
}
# End Eventbridge

# SQS Update Retailer Inventory
variable "update_retailer_inventory_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_retailer_inventory_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}
# End SQS