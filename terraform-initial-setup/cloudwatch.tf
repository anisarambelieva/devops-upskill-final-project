resource "aws_cloudwatch_metric_alarm" "codebuild_build_failure_alarm" {
  alarm_name          = "CodeBuildBuildFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedBuilds"
  namespace           = "AWS/CodeBuild"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm for CodeBuild Terraform plan failure"

  dimensions = {
    ProjectName = var.codebuild_build_project_name
  }

  alarm_actions = [aws_sns_topic.codebuild_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "codebuild_plan_failure_alarm" {
  alarm_name          = "CodeBuildPlanFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedBuilds"
  namespace           = "AWS/CodeBuild"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm for CodeBuild Terraform plan failure"

  dimensions = {
    ProjectName = var.codebuild_plan_project_name
  }

  alarm_actions = [aws_sns_topic.codebuild_notifications.arn]
}

resource "aws_cloudwatch_metric_alarm" "codebuild_apply_failure_alarm" {
  alarm_name          = "CodeBuildApplyFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedBuilds"
  namespace           = "AWS/CodeBuild"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm for CodeBuild Terraform apply failure"

  dimensions = {
    ProjectName = var.codebuild_apply_project_name
  }

  alarm_actions = [aws_sns_topic.codebuild_notifications.arn]
}
