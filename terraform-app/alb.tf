resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security-group-2.id]
  subnets            = ["${aws_subnet.subnets[0].id}", "${aws_subnet.subnets[1].id}"]

}

resource "aws_lb_target_group" "target-group" {
  name        = "target-group"
  port        = var.container_port
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
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
  }
}