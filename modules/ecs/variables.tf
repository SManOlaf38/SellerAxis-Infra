variable "environment_name" {
  description = "The name of environment."
  default     = ""
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name."
  default     = ""
  type        = string
}
