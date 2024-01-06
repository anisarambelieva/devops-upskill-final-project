terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.11.0"
    }
  }
  
  backend "s3" {
    bucket         = var.terraform_backend_bucket
    key            = var.terraform_state_object
    region         = var.region
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn  = var.assume_role
  }
}