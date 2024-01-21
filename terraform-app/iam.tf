resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "newsletter-subscriptions-app-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}

data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    actions = ["ecr:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_iam_role" {
  name               = "newsletter-subscriptions-app-esc-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
}