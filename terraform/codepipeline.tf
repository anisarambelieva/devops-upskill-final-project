resource "aws_codepipeline" "codepipeline" {
  name     = "provision-infrastructure-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_code"]

      configuration = {
        OAuthToken           = var.github_oauth_token
        Owner                = var.repo_owner
        Repo                 = var.repo_name
        Branch               = var.branch
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_code"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project_plan_stage.name
      }
    }
  }

  stage {
    name = "Apply" 

    action  {
        name = "Apply"
        category = "Build"
        provider = "CodeBuild"
        version = "1"
        owner = "AWS"
        input_artifacts = ["source_code"]

        configuration = {
            ProjectName = aws_codebuild_project.codebuild_project_apply_stage.name
        }
    }
  }
}

data "aws_kms_alias" "s3kmskey" {
  name = "alias/myKmsKey"
}