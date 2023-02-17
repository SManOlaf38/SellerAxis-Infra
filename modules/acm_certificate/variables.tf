variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "domain_name" {
  type = string
  description = "The domain name."
  default     = ""
}

variable "validation_method" {
  type = string
  description = "The validate method for certification."
  default     = ""
}

variable "create_before_destroy" {
  description = "Create certification before destroy."
  default     = true
}