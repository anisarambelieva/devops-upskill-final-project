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

variable "assume_role" {
    type        = string
    description = "The role to assume when provisioning the resources"
}

variable "terraform_backend_bucket" {
    type        = string
    description = "S3 bucket for storing the Terraform state"
    default     = "terraform-backend"
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
  default     = "main"
}

variable "poll_source_changes" {
  type        = string
  default     = "false"
  description = "Periodically check the source code and run the pipeline if changes are detected"
}