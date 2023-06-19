terraform {
  required_providers { aws = "~> 3.60" }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    bucket = "dev-selleraxis-state-terraform"
    key    = "environments/us-east-2-dev/website/terraform.tfstate"
    region = "us-east-1"
  }
}

module "ecs" {
  environment_name                    = var.environment_name
  source                              = "../../../modules/ecs"
  ecs_cluster_name                    = var.ecs_cluster_name
}

module "vpc" {
  environment_name                    = var.environment_name
  source                              = "../../../modules/vpc"
  vpc_name                            = var.vpc_name
  vpc_cidr_block                      = var.vpc_cidr_block
  availability_zones                  = var.availability_zones
  public_subnet_cidr_block            = var.public_subnet_cidr_block
}

module "ecr" {
  environment_name                    = var.environment_name
  source                              = "../../../modules/ecr"
  ecr_name                            = var.ecr_name
  mutability                          = var.mutability
  scan_on_push                        = var.scan_on_push
}

module "iam_role" {
  environment_name                    = var.environment_name
  source                              = "../../../modules/iam_role"
  iam_role_name                       = var.iam_role_name
  aws_iam_instance_profile_name       = var.aws_iam_instance_profile_name
  aws_iam_role_policy_name            = var.aws_iam_role_policy_name
}

module "security_group" {
  environment_name                      = var.environment_name
  source                                = "../../../modules/security_group"
  vpc_id                                = module.vpc.vpc_id
  vpc_cidr_blocks                       = [module.vpc.vpc_cidr_blocks]
  security_group_name                   = var.security_group_name
  security_group_description            = var.security_group_description
  security_group_http_cidr_blocks       = var.security_group_http_cidr_blocks
  security_group_http_ipv6_cidr_blocks  = var.security_group_http_ipv6_cidr_blocks
  security_group_https_cidr_blocks      = var.security_group_https_cidr_blocks
  security_group_https_ipv6_cidr_blocks = var.security_group_https_ipv6_cidr_blocks
  security_group_ssh_cidr_blocks        = var.security_group_ssh_cidr_blocks
}

module "acm_certificate" {
  environment_name                      = var.environment_name
  source                                = "../../../modules/acm_certificate"
  domain_name                           = var.domain_name
  validation_method                     = var.validation_method
  create_before_destroy                 = var.create_before_destroy
}

module "load_balancing" {
  environment_name                      = var.environment_name
  source                                = "../../../modules/load_balancing"
  alb_name                              = var.alb_name
  lb_target_group                       = var.lb_target_group
  security_group_ids                    = [module.security_group.id]
  subnet_ids                            = module.vpc.subnet_ids
  vpc_id                                = module.vpc.vpc_id
  acm_certificate_arn                   = module.acm_certificate.acm_certificate_arn
  health_check_path                     = "/api/"
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_security_group_name}-${var.environment_name}"
  description = "${var.rds_security_group_description}-${var.environment_name}"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = concat([module.vpc.vpc_cidr_blocks], [
      "116.105.72.78/32",
    ])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "rds" {
  environment_name                = var.environment_name
  source                          = "../../../modules/rds"
  allocated_storage               = var.allocated_storage
  storage_type                    = var.storage_type
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_name                         = var.db_name
  username                        = var.username
  password                        = var.password
  database_authentication_enabled = var.database_authentication_enabled
  backup_retention_period         = var.backup_retention_period
  security_group_ids              = [aws_security_group.rds_sg.id]
  subnet_ids                      = concat(module.vpc.subnet_ids)
}

module "cloudwatch_log" {
  source                                = "../../../modules/cloudwatch_log"
  cloudwatch_log_group_name             = var.cloudwatch_log_group_name
}

module "ecs_service" {
  environment_name                            = var.environment_name
  source                                      = "../../../modules/ecs_service"
  vpc_id                                      = module.vpc.vpc_id
  iam_role_arn                                = module.iam_role.iam_role_arn
  ecs_cluster_id                              = module.ecs.ecs_cluster_id
  repository_url                              = module.ecr.repository_url
  aws_lb_target_group_arn                     = module.load_balancing.aws_lb_target_group_arn
  ecs_service_private_namespace_name          = var.ecs_service_private_namespace_name
  ecs_service_private_namespace_description   = var.ecs_service_private_namespace_description
  ecs_service_name                            = var.ecs_service_name
  container_name                              = var.container_name
  container_port                              = var.container_port
  subnet_ids                                  = module.vpc.subnet_ids
  security_group_ids                          = [module.security_group.id]
  aws_region                                  = var.aws_region
  cloudwatch_log_group_name                   = module.cloudwatch_log.name
  ecs_cluster_name                            = var.ecs_cluster_name
  task_family_name                            = var.task_family_name
  ecs_task_policy_name                        = var.ecs_task_policy_name
  ecs_task_role_name                          = var.ecs_task_role_name
}

module "s3" {
  environment_name                      = var.environment_name
  source                                = "../../../modules/s3"
  photo_video_bucket_name               = var.photo_video_bucket_name
  photo_video_bucket_acl                = var.photo_video_bucket_acl
}

module "lambdas" {
  environment_name                      = var.environment_name
  source                                = "../../../modules/lambdas"
  acknowledge_forward_handler_name      = var.acknowledge_forward_handler_name
  acknowledge_sqs_name                  = var.acknowledge_sqs_name
  lambda_secret                         = var.lambda_secret
  api_host                              = "https://${var.domain_name}"
}
