aws_region     = "us-east-1"
aws_access_key = ""
aws_secret_key = ""

environment_name = "dev"

# ECS
ecs_cluster_name = "selleraxis-backend"
# End ECS

# VPC
vpc_name                 = "selleraxis-vpc"
vpc_cidr_block           = "10.0.0.0/16"
availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidr_block = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
# End VPC

# ECR
ecr_name     = "selleraxis"
mutability   = "MUTABLE"
scan_on_push = false
# End ECR

# AWS IAM ROLE
iam_role_name                 = "iam-selleraxis-role"
aws_iam_instance_profile_name = "iam-selleraxis-profile"
aws_iam_role_policy_name      = "selleraxis-policy"
# End AWS IAM ROLE

# AWS security group
security_group_name                   = "selleraxis-sg"
security_group_description            = "selleraxis security group tls"
security_group_http_cidr_blocks       = ["0.0.0.0/0"]
security_group_http_ipv6_cidr_blocks  = ["::/0"]
security_group_https_cidr_blocks      = ["0.0.0.0/0"]
security_group_https_ipv6_cidr_blocks = ["::/0"]
security_group_ssh_cidr_blocks        = ["0.0.0.0/0"]
# End AWS security group

# AWS Load balancing
alb_name        = "selleraxis-alb"
lb_target_group = "selleraxis-api-service"
# End AWS Load balancing

# RDS security group
rds_security_group_name        = "rds-sg"
rds_security_group_description = "RDS security group tls"
# End RDS security group

# RDS
allocated_storage               = 20
storage_type                    = "io1"
engine                          = "postgres"
engine_version                  = "12"
instance_class                  = "db.t4g.micro"
db_name                         = "selleraxis"
username                        = "postgres"
password                        = "51M5ua2u00WIdYHL"
database_authentication_enabled = true
backup_retention_period         = 7
# End RDS

# ACM Certificate
domain_name           = "api.selleraxis.com"
validation_method     = "DNS"
create_before_destroy = true
# End ACM Certificate

# New Cert
domain_name_new           = "api.dev.selleraxis.com"
# End new cert

# CloudWatch Log
cloudwatch_log_group_name = "selleraxis/backend-api-service"
# End CloudWatch Log

# ECS Service
ecs_service_private_namespace_name        = "selleraxis-private-namespace"
ecs_service_private_namespace_description = "selleraxis private namespace "
ecs_service_name                          = "selleraxis-api-service"
container_name                            = "backend-api-container"
container_port                            = 80
task_family_name                          = "selleraxis"
ecs_task_policy_name                      = "ecs-task-policy"
ecs_task_role_name                        = "ecs-task-role"
# End ECS service

# S3
photo_video_bucket_name = "selleraxis-bucket"
photo_video_bucket_acl  = "public-read"
# End S3

# SQS
acknowledge_sqs_name = "acknowledge_sqs"
# End SQS

# Lambda
acknowledge_forward_handler_name = "acknowledge_forward_handler"
lambda_secret                    = "N6r7SJ4OvMyMR6UraQcIK4Q2ybbgjzj8LDuEAOAmfsG58qSBN4jA9TS8rJCk6yuZ"
dev_lambda_secret                = "111"
# End Lambda

# SQS Update Inventory
update_inventory_sqs_name     = "update_inventory_sqs"
update_inventory_handler_name = "update_inventory_handler"
# End SQS Update Inventory

# SQS Crud Product
crud_product_sqs_name                       = "qbo_sync_product"
trigger_crud_product_quickbook_online_name  = "qbo_sync_product"
# End SQS Crud Product

# SQS Crud Retailer
crud_retailer_sqs_name                       = "qbo_sync_retailer"
trigger_crud_retailer_quickbook_online_name  = "qbo_sync_retailer"
# End SQS Crud Retailer

# SQS Update Retailer Inventory
update_retailer_inventory_sqs_name     = "update_retailer_inventory_sqs"
update_retailer_inventory_handler_name = "update_retailer_inventory_handler"

# SQS Update individual retailer Inventory

update_individual_retailer_inventory_sqs_name     = "update_individual_retailer_inventory_sqs"
update_individual_retailer_inventory_handler_name = "update_individual_retailer_inventory_handler"
# End SQS Update Retailer Inventory

# SQS update inventory to commercehub
update_inventory_to_commercehub_sqs_name          = "update_inventory_to_commercehub_sqs"
update_inventory_to_commercehub_handler_name      = "update_inventory_to_commercehub_handler"

# SQS qbo unhandled data
qbo_unhandled_data_sqs_name          = "qbo_unhandled_data_sqs"
qbo_unhandled_data_handler_name      = "qbo_unhandled_data_handler"

# Lambda error log handler
error_log_handler_name = "error_log_handler"
slack_webhook_host     = "https://hooks.slack.com/services/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"

# Lambda get new order
get_new_order_handle_name       = "get_new_order_lambda"
get_new_order_name              = "schedule_get_new_order_four_times_a_day"
trigger_get_new_order_name      = "call_lambda_get_new_order_trigger"
retailer_getting_order_sqs_name = "retailer_getting_order_sqs"
