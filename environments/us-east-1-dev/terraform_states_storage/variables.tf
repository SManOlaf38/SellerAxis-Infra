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
  description = "The name of enviroment use to iac"
  default = ""
}

variable "bucket_s3_storage_state_name" {
  description = "The name of S3 bucket to storage fle state."
  default = ""
}

variable "acl_s3_storage_state" {
  description = "The acl of S3 bucket to storage fle state."
  default     = ""
}