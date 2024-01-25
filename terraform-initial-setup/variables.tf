variable "region" {
  type        = string
  description = "The region in which to provision the resources"
  default     = "eu-west-1"
}

variable "account_id" {
  type        = string
  description = "ID of the AWS account"
  default     = "933920645082"
}

variable "terraform_backend_bucket" {
  type        = string
  description = "S3 bucket for storing the Terraform state"
  default     = "terraform-backend-for-newsletter-subscriptions-app"
}

variable "codepipeline-artifacts-bucket" {
  type        = string
  description = "S3 bucket for storing the CodePipeline artifacts"
  default     = "codepipeline-artifacts-for-newsletter-subscriptions-app"
}

variable "terraform_state_object" {
  type        = string
  description = "S3 object name for the Terraform state"
  default     = "terraform.tfstate"
}

variable "codebuild_plan_project_name" {
  type = string
  description = "CodeBuild project name for the Terraform plan stage"
  default = "terraform-plan-codebuild-project" 
}

variable "codebuild_apply_project_name" {
  type = string
  description = "CodeBuild project name for the Terraform apply stage"
  default = "terraform-apply-codebuild-project" 
}

variable "codebuild_build_project_name" {
  type = string
  description = "CodeBuild project name for the Docker build stage"
  default = "build-codebuild-project" 
}

variable "codebuild_policy_name" {
  type = string
  description = "IAM policy name for the CodeBuild projects"
  default = "newsletter-subscriptions-app-codebuild-policy" 
}

variable "codebuild_role_name" {
  type = string
  description = "IAM role name for the CodeBuild projects"
  default = "newsletter-subscriptions-app-codebuild-role" 
}

variable "codepipeline_policy_name" {
  type = string
  description = "IAM policy name for the CodePipeline pipeline"
  default = "newsletter-subscriptions-app-codepipeline-policy" 
}

variable "codepipeline_role_name" {
  type = string
  description = "IAM role name for the CodePipeline pipeline"
  default = "newsletter-subscriptions-app-codepipeline-role" 
}

variable "git_owner" {
  type        = string
  description = "Github username"
  default     = "anisarambelieva"
}

variable "git_repo" {
  type        = string
  description = "Github repository name"
  default = "devops-upskill-final-project"
}

variable "git_branch" {
  type        = string
  description = "Github branch name"
  default     = "add-eks-cluster"
}

variable "ecr_repository_name" {
  type        = string
  description = "ECR repository name"
  default     = "newsletter-subscriptions-app-images"
}