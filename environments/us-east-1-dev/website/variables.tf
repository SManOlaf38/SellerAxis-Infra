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
  type        = string
  description = " Name of the repository."
  default     = ""
}

variable "mutability" {
  type        = string
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
  type        = string
  description = "The name security group."
  default     = ""
}

variable "security_group_description" {
  type        = string
  description = "The description for security group"
  default     = ""
}

variable "security_group_http_cidr_blocks" {
  type        = list(any)
  description = "The list of CIDR blocks for http"
  default     = []
}

variable "security_group_http_ipv6_cidr_blocks" {
  type        = list(any)
  description = "The list of CIDR blocks for http"
  default     = []
}

variable "security_group_https_cidr_blocks" {
  type        = list(any)
  description = "The list of CIDR blocks for https"
  default     = []
}

variable "security_group_https_ipv6_cidr_blocks" {
  type        = list(any)
  description = "The list of CIDR blocks for https"
  default     = []
}

variable "security_group_ssh_cidr_blocks" {
  type        = list(any)
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
  type        = list(any)
}

variable "subnet_ids" {
  description = "The list of subnet."
  default     = []
  type        = list(any)
}
# End AWS Load balancing

# RDS security group
variable "rds_security_group_name" {
  type        = string
  description = "The name security group of RDS."
  default     = ""
}

variable "rds_security_group_description" {
  type        = string
  description = "The description for security group of RDS"
  default     = ""
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  default     = 0
}
# End RDS security group

# RDS
variable "engine" {
  description = "The database engine to use."
  default     = ""
}

variable "engine_version" {
  description = "(Optional) The engine version to use"
  default     = ""
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  default     = ""
}

variable "db_name" {
  description = "The database name."
  default     = ""
}

variable "username" {
  description = "The username."
  default     = ""
}

variable "password" {
  description = "The password."
  default     = ""
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  default     = ""
}

variable "storage_type" {
  description = "The amount of provisioned IOPS."
  default     = ""
}

variable "database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = false
}

variable "security_group_names" {
  description = "List of DB Security Groups to associate."
  default     = []
}
# End RDS

# ACM Certificate
variable "domain_name_new" {
  type = string
  description = "The domain name."
  default = ""
}
variable "domain_name" {
  type        = string
  description = "The domain name."
  default     = ""
}

variable "validation_method" {
  type        = string
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

variable "dev_lambda_secret" {
  description = "The dev lambda secret."
  default     = ""
}
# End Lambda

# SQS Update Inventory
variable "update_inventory_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_inventory_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

# SQS product crud
variable "crud_product_sqs_name" {
  description = "The product SQS name."
  default     = ""
}

variable "trigger_crud_product_quickbook_online_name" {
  description = "The product forward handler name."
  default     = ""
}

# SQS retailer crud
variable "crud_retailer_sqs_name" {
  description = "The retailer SQS name."
  default     = ""
}

variable "trigger_crud_retailer_quickbook_online_name" {
  description = "The retailer forward handler name."
  default     = ""
}

# SQS Update Retailer Inventory
variable "update_retailer_inventory_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_retailer_inventory_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

# SQS Update individual retailer inventory

variable "update_individual_retailer_inventory_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_individual_retailer_inventory_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

# SQS Update inventory to commercehub

variable "update_inventory_to_commercehub_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "update_inventory_to_commercehub_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

variable "qbo_unhandled_data_sqs_name" {
  description = "The acknowledge SQS name."
  default     = ""
}

variable "qbo_unhandled_data_handler_name" {
  description = "The acknowledge forward handler name."
  default     = ""
}

# Lambda error log handler
variable "error_log_handler_name" {
  description = "Error log handler name."
  default     = ""
}

variable "slack_webhook_host" {
  description = "Slack webhook host."
  default     = ""
}

# Schedule get new order
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

variable "retailer_getting_order_sqs_name" {
  description = "The acknowledge retailer getting order sqs name."
  default     = ""
}
# End schedule get new order
