resource "aws_db_subnet_group" "default" {
  name       = "${var.db_name}-rds-subnet-group-${var.environment_name}"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "default" {
  allocated_storage                       = var.allocated_storage
  engine                                  = var.engine
  engine_version                          = var.engine_version
  instance_class                          = var.instance_class
  name                                    = var.db_name
  username                                = var.username
  password                                = var.password
  iam_database_authentication_enabled     = var.database_authentication_enabled
  skip_final_snapshot                     = "true"
  publicly_accessible                     = "true"

  backup_retention_period                 = var.backup_retention_period
  backup_window                           = "07:00-07:30"
  copy_tags_to_snapshot                   = "true"

  db_subnet_group_name                    = aws_db_subnet_group.default.id
  vpc_security_group_ids                  = var.security_group_ids
}
