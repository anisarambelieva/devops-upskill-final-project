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
  default     = 5000
}

variable "az_count" {
  description = "Describes how many availability zones are used"
  default     = 2
  type        = number
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.1.0.0/16"
  type        = string
}

variable "domain_name" {
  default     = "telerik-newsletter-subscriptions.com"
  type        = string
}


# NEW SETUP
variable "cidr" {
  type    = string
  default = "145.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "eu-west-1a",
    "eu-west-1b"
  ]
}

variable "subnets-ip" {
  type = list(string)
  default = [
    "145.0.1.0/24",
    "145.0.2.0/24"
  ]

}