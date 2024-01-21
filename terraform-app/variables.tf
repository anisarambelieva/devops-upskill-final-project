variable "region" {
  type        = string
  description = "The region in which to provision the resources"
  default     = "eu-west-1"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "newsletter-subscriptions-app-cluster"
}

variable "cpu_units" {
  description = "Amount of CPU units for a single ECS task"
  default     = 256
  type        = number
}

variable "memory" {
  description = "Amount of memory in MB for a single ECS task"
  default     = 512
  type        = number
}

variable "container_port" {
  description = "Port of the container"
  type        = number
  default     = 3000
}

variable "az_count" {
  description = "Describes how many availability zones are used"
  default     = 2
  type        = number
}