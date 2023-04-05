variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

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

variable "backup_retention_period" {
  description = "The days to retain backups for."
  default     = 0
}

variable "security_group_ids" {
  description = "List of DB Security Groups to associate."
  default     = []
}

variable "subnet_ids" {
  description = "List of DB Security Groups to associate."
  default     = []
  type = list
}
