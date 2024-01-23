resource "aws_codebuild_project" "codebuild_project_plan_stage" {
  name          = var.codebuild_plan_project_name
  description   = "Terraform Plan Stage"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
 }
 
  source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/buildspec-plan.yml")
 }
}

resource "aws_codebuild_project" "codebuild_project_apply_stage" {
  name          = var.codebuild_apply_project_name
  description   = "Terraform Apply Stage"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
 }

  source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/buildspec-apply.yml")
 }
}

resource "aws_codebuild_project" "codebuild_project_deploy_stage" {
  name          = var.codebuild_deploy_project_name
  description   = "Deploy Stage"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
 }

  source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/buildspec-docker.yml")
 }
}
