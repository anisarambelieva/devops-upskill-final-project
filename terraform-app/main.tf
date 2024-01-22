terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-backend-for-newsletter-subscriptions-app"
    key            = "app/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "verginia"
  region = "us-east-1"
}