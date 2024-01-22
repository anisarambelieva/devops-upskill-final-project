# resource "aws_ecs_cluster" "default" {
#   name = "newsletter-subscriptions-app-cluster"
# }

# resource "aws_ecs_service" "service" {
#   name                               = "newsletter-subscriptions-app-ecs-service"
#   cluster                            = aws_ecs_cluster.default.id
#   task_definition                    = aws_ecs_task_definition.default.arn
#   desired_count                      = 2
#   deployment_minimum_healthy_percent = 50
#   deployment_maximum_percent         = 100
#   launch_type                        = "FARGATE"

#   load_balancer {
#     target_group_arn = aws_alb_target_group.service_target_group.arn
#     container_name   = "newsletter-subscriptions-app"
#     container_port   = 5000
#   }

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_container_instance.id]
#     subnets          = aws_subnet.private.*.id
#     assign_public_ip = false
#   }

#   lifecycle {
#     ignore_changes = [desired_count]
#   }
# }

# resource "aws_ecs_task_definition" "default" {
#   family                   = "newsletter-subscriptions-app-task-definition"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_iam_role.arn
#   cpu                      = var.cpu_units
#   memory                   = var.memory

#   container_definitions = jsonencode([
#     {
#       name         = "newsletter-subscriptions-app"
#       image        = "933920645082.dkr.ecr.eu-west-1.amazonaws.com/newsletter-subscriptions-app-images:latest"
#     #   image = "nginx:1.25.3"
#       cpu          = var.cpu_units
#       memory       = var.memory
#       essential    = true
#       portMappings = [
#         {
#           containerPort = var.container_port
#           hostPort      = var.container_port
#           protocol      = "tcp"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs",
#         options   = {
#           "awslogs-group"         = aws_cloudwatch_log_group.log_group.name,
#           "awslogs-region"        = var.region,
#           "awslogs-stream-prefix" = "newsletter-subscriptions-app-log-stream"
#         }
#       }
#     }
#   ])
# }

# resource "aws_security_group" "ecs_container_instance" {
#   name        = "app-security-group"
#   description = "Security group for ECS task running on Fargate"
#   vpc_id      = aws_vpc.default.id

#   ingress {
#     description     = "Allow ingress traffic from ALB on HTTP only"
#     from_port       = var.container_port
#     to_port         = var.container_port
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#   }

#   egress {
#     description = "Allow all egress traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "alb" {
#   name        = "newsletter-subscriptions-alb-sg"
#   description = "Security group for ALB"
#   vpc_id      = aws_vpc.default.id

#   egress {
#     description = "Allow all egress traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# data "aws_ec2_managed_prefix_list" "cloudfront" {
#   name = "com.amazonaws.global.cloudfront.origin-facing"
# }

# resource "aws_security_group_rule" "alb_cloudfront_http_ingress_only" {
#   security_group_id = aws_security_group.alb.id
#   description       = "Allow HTTPS access only from CloudFront CIDR blocks"
#   from_port         = 8080
# #   from_port         = 443
#   protocol          = "tcp"
#   prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
#   to_port           = 8080
# #   to_port           = 443
#   type              = "ingress"
# }

# NEW

# ECS CLUSTER
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "clusterDev"
}

data "aws_iam_role" "ecs-task" {
  name = "ecsTaskExecutionRole"
}

# TASK DEFINITION
resource "aws_ecs_task_definition" "task" {
  family                   = "HTTPserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${data.aws_iam_role.ecs-task.arn}"

  container_definitions = jsonencode([
    {
      name   = "golang-container"
      image  = "${var.uri_repo}:latest" #URI
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 5000
        }
      ]
    }
  ])
}

# ECS SERVICE
resource "aws_ecs_service" "svc" {
  name            = "golang-Service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
  desired_count   = 2
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.pub-subnets[0].id}", "${aws_subnet.pub-subnets[1].id}"]
    security_groups  = ["${aws_security_group.sg1.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "golang-container"
    container_port   = "5000"
  }
}