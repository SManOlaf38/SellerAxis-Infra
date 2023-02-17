variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "security_group_name" {
  type = string
  description = "The security group name ec2."
  default     = ""
}

variable "vpc_id" {
  description = "The vpc id."
  default     = ""
  type = string
}

variable "vpc_cidr_blocks" {
  type = list
  description = "The vpc cidr blocks."
  default     = []
}

variable "security_group_description" {
  type = string
  description = "The public key material"
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
