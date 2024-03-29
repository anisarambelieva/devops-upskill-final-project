resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "task" {
  family                   = "HTTPserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_iam_role.arn

  container_definitions = jsonencode([
    {
      name   = "app-container"
      image  = "933920645082.dkr.ecr.eu-west-1.amazonaws.com/newsletter-subscriptions-app-images:latest"
      cpu    = var.cpu_units
      memory = var.memory
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task.id
  desired_count   = length(var.azs)
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.subnets[0].id}", "${aws_subnet.subnets[1].id}"]
    security_groups  = ["${aws_security_group.security-group-1.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group.arn
    container_name   = "app-container"
    container_port   = var.container_port
  }
}