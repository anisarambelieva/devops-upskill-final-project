# resource "aws_alb" "alb" {
#   name            = "alb"
#   security_groups = [aws_security_group.alb.id]
#   subnets         = aws_subnet.public.*.id
# }

# resource "aws_alb_listener" "alb_default_listener_http" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = 8080
# #   port              = 443
#   protocol          = "HTTP"
# #   protocol          = "HTTPS"
# #   certificate_arn   = "arn:aws:acm:eu-west-1:933920645082:certificate/a98f1382-15d7-4f56-9e67-30b9f10471a3"
# #   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

#   default_action {
#     type = "forward"
#     target_group_arn = aws_alb_target_group.service_target_group.arn
#   }
# }

# resource "aws_alb_target_group" "service_target_group" {
#   name                 = "target-group"
#   port                 = var.container_port
#   protocol             = "HTTP"
#   vpc_id               = aws_vpc.default.id
#   deregistration_delay = 300
#   target_type          = "ip"

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     interval            = 60
#     matcher             = "200"
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 30
#   }

#   depends_on = [aws_alb.alb]
# }

# NEW

resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = ["${aws_subnet.pub-subnets[0].id}", "${aws_subnet.pub-subnets[1].id}"]

}

resource "aws_lb_target_group" "tg-group" {
  name        = "tg-group"
  port        = "5000"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"
  target_type = "ip"

}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.app-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
  }
}