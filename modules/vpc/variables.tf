variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "vpc_name" {
  description = "The VPC name."
  default     = ""
  type        = string
}

variable "vpc_cidr_block" {
  description = "Main VPC CIDR Block."
  default     = ""
  type        = string
}

variable "availability_zones" {
  description = "AWS Region Availability Zones."
  default     = []
  type        = list
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR Block."
  default     = []
  type        = list
}
