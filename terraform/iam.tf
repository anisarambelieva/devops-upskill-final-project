# IAM for CodeBuild

data "aws_iam_policy_document" "codebuild-policy-document" {
    statement{
        actions = ["logs:*"]
        resources = ["*"]
        effect = "Allow"
    }

    statement{
        actions = ["s3:*"]
        resources = [
          "${aws_s3_bucket.terraform-backend-bucket.arn}/*",
          "${aws_s3_bucket.terraform-backend-bucket.arn}"
        ]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "codebuild-policy" {
    name = var.codebuild_policy_name
    policy = data.aws_iam_policy_document.codebuild-policy-document.json
}

resource "aws_iam_role" "codebuild-role" {
  name = var.codebuild_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild-policy-attachment" {
    policy_arn  = aws_iam_policy.codebuild-policy.arn
    role        = aws_iam_role.codebuild-role.id
}

# IAM for CodePipeline

data "aws_iam_policy_document" "codepipeline-policy-document" {
    statement{
        actions = ["logs:*"]
        resources = ["*"]
        effect = "Allow"
    }

    statement{
        actions = ["codebuild:*"]
        resources = [
          "arn:aws:codebuild:${var.aws_region}:${var.account_id}:project/${var.codebuild_plan_project_name}",
          "arn:aws:codebuild:${var.aws_region}:${var.account_id}:project/${var.codebuild_apply_project_name}"
          ]
        effect = "Allow"
    }

    statement{
        actions = ["s3:*"]
        resources = ["${aws_s3_bucket.terraform_backend_bucket.arn}/*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "codepipeline-policy" {
    name = var.codepipeline_policy_name
    policy = data.aws_iam_policy_document.codepipeline-policy-document.json
}

resource "aws_iam_role" "codepipeline-role" {
  name = var.codepipeline_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline-policy-attachment" {
    policy_arn  = aws_iam_policy.codepipeline-policy.arn
    role        = aws_iam_role.codepipeline-role.id
}