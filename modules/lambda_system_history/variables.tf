variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "system_history_name" {
  description = "The system history prefix."
  default     = ""
}

variable "system_history_database_name" {
  description = "The system history prefix."
  default     = "system_history"
}

variable "system_history_bucket_name" {
  description = "The system history bucket name."
  default     = "system-history-bucket"
}

variable "acl_s3_system_history" {
  description = ""
  default     = "private"
}
