terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-backend-for-newsletter-subscriptions-app"
    key     = "initial-setup/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}