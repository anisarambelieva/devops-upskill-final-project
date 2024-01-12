resource "aws_codestarconnections_connection" "github-connection" {
  name          = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "provision-infrastructure-pipeline"
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifacts-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_code"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github-connection.arn
        FullRepositoryId     = "${var.git_owner}/${var.git_repo}"
        BranchName           = var.git_branch
        DetectChanges        = false # CodePipeline does not start your pipeline on new commits
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