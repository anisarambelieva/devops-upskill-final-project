resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/newsletter-subscriptions-app"
  retention_in_days = 7
}