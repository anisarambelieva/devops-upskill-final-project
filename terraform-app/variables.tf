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

