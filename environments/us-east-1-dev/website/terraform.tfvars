aws_region = "us-east-1"
aws_access_key = ""
aws_secret_key = ""

environment_name                    = "dev"

# ECS
ecs_cluster_name                    = "selleraxis-backend"
# End ECS

# VPC
vpc_name                            = "selleraxis-vpc"
vpc_cidr_block                      = "10.0.0.0/16"
availability_zones                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidr_block            = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
# End VPC

# ECR
ecr_name = "selleraxis"
mutability = "MUTABLE"
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

# Mongodb security group
mongodb_security_group_name        = "mongodb-sg"
mongodb_security_group_description = "Mongodb security group tls"
# End Mongodb security group

# AWS Load balancing
alb_name                      = "selleraxis-alb"
lb_target_group               = "selleraxis-api-service"
# End AWS Load balancing

# ACM Certificate
domain_name                   = "api.selleraxis.com"
validation_method             = "DNS"
create_before_destroy         = true
# End ACM Certificate

# CloudWatch Log
cloudwatch_log_group_name                   = "selleraxis/backend-api-service"
# End CloudWatch Log

# ECS Service
ecs_service_private_namespace_name          = "selleraxis-private-namespace"
ecs_service_private_namespace_description   = "selleraxis private namespace "
ecs_service_name                            = "selleraxis-api-service"
container_name                              = "backend-api-container"
container_port                              = 80
task_family_name                            = "selleraxis"
# End ECS service

# S3
photo_video_bucket_name        = "selleraxis-bucket"
photo_video_bucket_acl         = "public-read"
# End S3
