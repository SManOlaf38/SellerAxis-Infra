variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "ecr_name" {
  type        = string
  description = " Name of the repository."
  default     = ""
}

variable "mutability" {
  type        = string
  description = "The tag mutability setting for the repository."
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  default     = false
}

