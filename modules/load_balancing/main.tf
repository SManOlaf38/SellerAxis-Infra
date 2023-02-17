resource "aws_lb" "selleraxis_lb" {
  name               = "${var.alb_name}-${var.environment_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = true

  tags = {
    Environment = var.environment_name
  }
}

resource "aws_lb_target_group" "selleraxis_lb_target_group" {
  name        = "${var.lb_target_group}-${var.environment_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/api/"
    protocol            = "HTTP"
    timeout             = "5"
    interval            = "30"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "selleraxis_lb_listener" {
  load_balancer_arn = aws_lb.selleraxis_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.selleraxis_lb_target_group.arn
  }
}

resource "aws_lb_listener_rule" "selleraxis_lb_listener_rule" {
  listener_arn = aws_lb_listener.selleraxis_lb_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.selleraxis_lb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
