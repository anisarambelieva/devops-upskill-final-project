resource "aws_alb" "alb" {
  name            = "alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public.*.id
}

resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access denied"
      status_code  = "403"
    }
  }
}

resource "aws_alb_target_group" "service_target_group" {
  name                 = "target-group"
  port                 = var.container_port
  protocol             = "HTTP"
  vpc_id               = aws_vpc.default.id
  deregistration_delay = 5
  target_type          = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  depends_on = [aws_alb.alb]
}