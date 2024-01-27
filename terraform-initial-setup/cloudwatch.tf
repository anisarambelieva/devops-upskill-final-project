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
    ProjectName = "terraform-plan-codebuild-project"
  }

  alarm_actions = [aws_sns_topic.codebuild_notifications.arn]
}
