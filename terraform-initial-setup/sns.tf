resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.codebuild_notifications.arn
  protocol  = "email"
  endpoint  = "anisarambelieva@gmail.com"
}

resource "aws_sns_topic" "codebuild_notifications" {
  name = "CodeBuildNotifications"
  kms_master_key_id = "alias/aws/sns"
}